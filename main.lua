local name, SimpleBrewSim = ...;
local lineAdded = false

-- move to function, run when spec changes

--[[
local spec = select(2, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex("player")));
if spec ~= "Brewmaster" then
    return
end ]] --
-- Maybe add a 'do nothing if same item'
local function show_dps_change()
    local new_item_link = select(2, GameTooltip:GetItem())
    if not new_item_link then
        return nil
    end

    local equip_slot, _, _, item_class, item_subclass = select(9, GetItemInfo(new_item_link))
    if item_class ~= LE_ITEM_CLASS_ARMOR then
        return nil
    end

    if not SimpleBrewSim.Armour.ARMOUR_TYPES[item_subclass] then
        return nil
    end
    local equipped_id = SimpleBrewSim.INV_TYPES[equip_slot]
    if not equipped_id then
        return nil
    end
    if equipped_id == SimpleBrewSim.INV_TYPES['INVTYPE_TRINKET'] or equipped_id == SimpleBrewSim.INV_TYPES[INVTYPE_FINGER] then
        -- take care of multiple items
        print('it\'s a finger or trink')
        return nil
    end
    local equipped_item_link = GetInventoryItemLink("player", equipped_id)
    -- round number workaround
    local dps_value = SimpleBrewSim:compare_items(equipped_item_link, new_item_link)  -- string to number
    local dps_str_value = SimpleBrewSim:round(math.abs(dps_value),2)
    if dps_value < 0 then
        return string.format("DPS loss: %s%%",dps_str_value), 194/255, 123/255, 160/255
    end
    return string.format("DPS gain %s%%",dps_str_value), 0, 255/255, 128/255
end

local function OnTooltipSetItem(tooltip, ...)
    if not lineAdded then
        local upgrade_text, r,g,b = show_dps_change()
        if upgrade_text then
            tooltip:AddLine(upgrade_text,r,g,b)
            lineAdded = true
        end
    end
end

local function OnTooltipCleared(tooltip, ...)
    lineAdded = false

end

local frame, events = CreateFrame("FRAME", "SimpleBrewSimFrame"), {};
--function events:PLAYER_ENTERING_WORLD(...)end
function events:PLAYER_EQUIPMENT_CHANGED(...)
    SimpleBrewSim:cache_equipped_ratings()
end
function events:PLAYER_LOGIN(...)
    SimpleBrewSim:cache_traits()
    SimpleBrewSim:cache_base_stats()
    SimpleBrewSim:cache_equipped_ratings()
    GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
end
frame:SetScript("OnEvent", function(self,event, ...)
    events[event](self, ...);
end)
for k,v in pairs(events) do
    frame:RegisterEvent(k)
end


