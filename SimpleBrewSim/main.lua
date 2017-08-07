local name, SimpleBrewSim = ...;
local lineAdded = false
local is_active_spec = false
local BREW_SPEC_ID = 268
--- Reduce table lookup
local INV_TYPES = SimpleBrewSim.INV_TYPES
local LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_ARMOR
local ARMOUR_TYPES = SimpleBrewSim.ARMOUR_TYPES
--- TOOLTIP COLOURS
local red_loss = 0.760784314
local green_loss = 0.482352941
local blue_loss = 0.62745098
local red_gain = 0
local green_gain = 1
local blue_gain = 0.501960784
local dps_gain_text = 'gain: '
local dps_loss_text = 'loss: '


local function calculate_dps_change(tooltip, new_item_link, equipped_id)
    local equipped_item_link = GetInventoryItemLink("player", equipped_id)
    if not equipped_item_link or equipped_item_link == new_item_link  then return end
    local item_name = GetItemInfo(equipped_item_link)
    local dps_change = dps_loss_text
    local r, g, b, r2, g2, b2 = red_loss, green_loss, blue_loss, red_gain, green_gain, blue_gain
    -- round number workaround
    local dps_value = SimpleBrewSim:compare_items(equipped_item_link, new_item_link) -- string to number
    local dps_str_value = SimpleBrewSim:round(SimpleBrewSim:round(math.abs(dps_value), 3), 2)
    if dps_value > 0 then
        dps_change, r, g, b, r2, g2, b2 = dps_gain_text, red_gain, green_gain, blue_gain, red_loss, green_loss, blue_loss
    end
    tooltip:AddDoubleLine("DPS " .. dps_change .. dps_str_value .. "% ", "(" .. item_name .. ")", r, g, b, r2, g2, b2) --#TODO look into string concat
end

local function show_dps_change(tooltip)
    local _, new_item_link = tooltip:GetItem()
    if not new_item_link then
        return
    end
    local equip_slot, _, _, item_class, item_subclass = select(9, GetItemInfo(new_item_link))
    if item_class ~= LE_ITEM_CLASS_ARMOR then
        return
    end
    if not ARMOUR_TYPES[item_subclass] and not ARMOUR_TYPES[equip_slot] then
        return
    end

    local equipped_id = INV_TYPES[equip_slot]
    calculate_dps_change(tooltip, new_item_link, equipped_id)

    if equipped_id == INV_TYPES['INVTYPE_TRINKET'] or equipped_id == INV_TYPES['INVTYPE_FINGER'] then
        equipped_id = equipped_id + 1
        calculate_dps_change(tooltip, new_item_link, equipped_id)
    end
end


local function OnTooltipSetItem(tooltip, ...)
    if not is_active_spec or lineAdded then
        return
    end
    show_dps_change(tooltip)
    lineAdded = true
end

local function OnTooltipCleared(tooltip, ...)
    lineAdded = false
end

local function check_spec()
    is_active_spec = GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex("player")) == BREW_SPEC_ID  -- #TODO localisation
end

local frame, events = CreateFrame("FRAME", "SimpleBrewSimFrame"), {};
function events:PLAYER_SPECIALIZATION_CHANGED(...)
    check_spec()
    if is_active_spec then
        SimpleBrewSim:cache_traits()
        SimpleBrewSim:cache_base_stats()
        SimpleBrewSim:cache_equipped_ratings()
    end
end

function events:PLAYER_EQUIPMENT_CHANGED(...)
    if not is_active_spec then
        return
    end
    SimpleBrewSim:cache_equipped_ratings()
end

function events:PLAYER_LOGIN(...)
    GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
    ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    ItemRefTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
    check_spec()
    if is_active_spec then
        SimpleBrewSim:cache_base_stats()
        SimpleBrewSim:cache_equipped_ratings()
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...);
end)
for k, v in pairs(events) do
    frame:RegisterEvent(k)
end


