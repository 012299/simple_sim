local name, SimpleBrewSim = ...;
local lineAdded = false
local is_active_spec = false
local BREW_SPEC_ID = 268
local MONK_CLASS_ID = 10
-- Upvalues
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
--- Reduce table lookup
local INV_TYPES = SimpleBrewSim.INV_TYPES
local LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_ARMOR
local ARMOUR_TYPES = SimpleBrewSim.ARMOUR_TYPES
-- TOOLTIP COLOURS
local red_loss = 0.760784314
local green_loss = 0.482352941
local blue_loss = 0.62745098
local red_gain = 0
local green_gain = 1
local blue_gain = 0.501960784
local DPS_GAIN_TEXT = 'gain: '
local DPS_LOSS_TEXT = 'loss: '
-- Caching to avoid unnecessary calculations when tooltip show/hide gets called multiple times
local last_item_link, line_left, line_right, r, g, b, r2, g2, b2
local line_left_2, line_right_2, r_2, g_2, b_2, r2_2, g2_2, b2_2

local function add_tooltip_line(tooltip)
    -- for ring/trinket caching
    if line_left_2 then
        tooltip:AddDoubleLine(line_left_2, line_right_2, r_2, g_2, b_2, r2_2, g2_2, b2_2)
    end
    tooltip:AddDoubleLine(line_left, line_right, r, g, b, r2, g2, b2)
end

local function calculate_dps_change(tooltip, new_item_link, equipped_id)
    local equipped_item_link = GetInventoryItemLink("player", equipped_id)
    if not equipped_item_link or equipped_item_link == new_item_link then
        last_item_link = nil
        line_left_2 = nil
        return
    end
    local item_name = GetItemInfo(equipped_item_link)
    -- round number workaround
    local dps_value = SimpleBrewSim:compare_items(equipped_item_link, new_item_link) -- string to number
    local dps_str_value = SimpleBrewSim:round(SimpleBrewSim:round(math.abs(dps_value), 3), 2)
    if dps_value > 0 then
        line_left, line_right, r, g, b, r2, g2, b2 = "DPS " .. DPS_GAIN_TEXT .. dps_str_value .. "% ", "(" .. item_name .. ")", red_gain, green_gain, blue_gain, red_loss, green_loss, blue_loss
    else
        line_left, line_right, r, g, b, r2, g2, b2 = "DPS " .. DPS_LOSS_TEXT .. dps_str_value .. "% ", "(" .. item_name .. ")", red_loss, green_loss, blue_loss, red_gain, green_gain, blue_gain
    end
    add_tooltip_line(tooltip)
end

local function show_dps_change(tooltip)
    local _, new_item_link = tooltip:GetItem()
    if not new_item_link then
        return
    end
    -- if same item (tooltip show gets called multiple times per second), use stored string. No need to recalculate gain/loss.
    if new_item_link == last_item_link then
        add_tooltip_line(tooltip)
        return
    end
    -- new item, set last_item_link to nil to avoid strings on non-armour items.
    last_item_link = nil
    line_left_2 = nil
    local _, _, _, _, _, _, _, _, equip_slot, _, _, item_class, item_subclass = GetItemInfo(new_item_link)
    if item_class ~= LE_ITEM_CLASS_ARMOR then
        return
    end
    if not ARMOUR_TYPES[item_subclass] and not ARMOUR_TYPES[equip_slot] then
        return
    end
    last_item_link = new_item_link
    local equipped_id = INV_TYPES[equip_slot]
    calculate_dps_change(tooltip, new_item_link, equipped_id)

    if equipped_id == INV_TYPES['INVTYPE_TRINKET'] or equipped_id == INV_TYPES['INVTYPE_FINGER'] then
        equipped_id = equipped_id + 1
        -- reassign cached item to new var so second comparison item can be cached
        line_left_2, line_right_2, r_2, g_2, b_2, r2_2, g2_2, b2_2 = line_left, line_right, r, g, b, r2, g2, b2
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
    is_active_spec = GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex("player")) == BREW_SPEC_ID
end

local frame, events = CreateFrame("FRAME", "SimpleBrewSimFrame"), {};
function events:PLAYER_SPECIALIZATION_CHANGED(...)
    check_spec()
    if is_active_spec then
        -- clear tooltip cache, maybe move it to a method at some point
        last_item_link, line_left_2 = nil, nil
        SimpleBrewSim:cache_traits()
        SimpleBrewSim:cache_base_stats()
        SimpleBrewSim:cache_equipped_ratings()
    end
end

function events:PLAYER_EQUIPMENT_CHANGED(...)
    if not is_active_spec then
        return
    end
    --clear tooltip cache
    last_item_link, line_left_2 = nil, nil
    SimpleBrewSim:cache_equipped_ratings()
end

function events:PLAYER_LOGIN(...)
    local _, _, class_id = UnitClass("player")
    if class_id ~= MONK_CLASS_ID then
        return
    end
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

-- Add one time UNIT_AURA event listener to deal with active consumables on login
function events:UNIT_AURA(...)
    if is_active_spec then
        SimpleBrewSim:cache_equipped_ratings()
    end
    frame:UnregisterEvent("UNIT_AURA")
end

frame:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...);
end)
for k, v in pairs(events) do
    frame:RegisterEvent(k)
end


