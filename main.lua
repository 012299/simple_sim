--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 16/07/2017
-- Time: 12:36
-- To change this template use File | Settings | File Templates.
--
local name, settings = ...;
local lineAdded = false

-- move to function, run when spec changes

--[[
local spec = select(2, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex("player")));
if spec ~= "Brewmaster" then
    return
end ]] --
-- Maybe add a 'do nothing if same item'
function show_upgrade()
    local new_item_link = select(2, GameTooltip:GetItem())
    local equip_slot, _, _, item_class, item_subclass = select(9, GetItemInfo(new_item_link))
    if item_class ~= LE_ITEM_CLASS_ARMOR then
        return nil
    end

    if not settings.Armour.ARMOUR_TYPES[item_subclass] then
        return nil
    end
    local equipped_id = settings.INV_TYPES[equip_slot]
    if not equipped_id then
        return nil
    end
    if equipped_id == settings.INV_TYPES['INVTYPE_TRINKET'] or equipped_id == settings.INV_TYPES[INVTYPE_FINGER] then
        -- take care of multiple items
        print('it\'s a finger or trink')
        return nil
    end
    local equipped_item_link = GetInventoryItemLink("player", equipped_id)
    return settings:compare_items(equipped_item_link, new_item_link)
end

local function OnTooltipSetItem(tooltip, ...)
    if not lineAdded then
        local upgrade_text = show_upgrade()
        if upgrade_text then
            tooltip:AddLine(string.format('Upgrade text: %s', upgrade_text))
            lineAdded = true
        end
    end
end

local function OnTooltipCleared(tooltip, ...)
    lineAdded = false
end

local frame = CreateFrame("FRAME", "SimpleBrewSimFrame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
    settings:cache_base_stats()
    settings:cache_equipped_ratings()
    GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
end

frame:SetScript("OnEvent", eventHandler)

