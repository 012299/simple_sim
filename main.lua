local name, SimpleBrewSim = ...;
local lineAdded = false
local is_active_spec = false
local INV_TYPES = SimpleBrewSim.INV_TYPES
local red_loss = .76
local green_loss = .48
local blue_loss = .63
local red_gain = 0
local green_gain= 1
local blue_gain = .51

local function calculate_dps_change(new_item_link, equipped_id)

    local equipped_item_link = GetInventoryItemLink("player", equipped_id)
    -- round number workaround
    --attempt to compare string with number
    local dps_value = SimpleBrewSim:compare_items(equipped_item_link, new_item_link) -- string to number
    --  print('dps value: ', dps_value)
    local dps_str_value = SimpleBrewSim:round(SimpleBrewSim:round(math.abs(dps_value), 4), 3)
    if dps_value < 0 then
        return "DPS loss: " .. dps_str_value .. "%", red_loss, blue_loss, green_loss
    end
    return "DPS gain: " .. dps_str_value .. "%", red_gain, blue_gain, green_gain
end

local function show_dps_change()
    local _, new_item_link = GameTooltip:GetItem()
    if not new_item_link or IsEquippedItem(new_item_link) then
        return
    end
    local equip_slot, _, _, item_class, item_subclass = select(9, GetItemInfo(new_item_link))
    if item_class ~= LE_ITEM_CLASS_ARMOR then
        return
    end
    if not SimpleBrewSim.ARMOUR_TYPES[item_subclass] and not SimpleBrewSim.ARMOUR_TYPES[equip_slot] then
        return
    end

    local equipped_id = INV_TYPES[equip_slot]
    local dps_string, r,g,b = calculate_dps_change(new_item_link,equipped_id)

    if equipped_id == INV_TYPES['INVTYPE_TRINKET'] or equipped_id == INV_TYPES['INVTYPE_FINGER'] then
        -- get itemlimk for same slot, get name. Do regular calculation, add line with name to tooltip
        -- do itemlink for slot+1, get name, do regular calculation.
    end
    return dps_string,r,g,b
end


local function OnTooltipSetItem(tooltip, ...)
    if not is_active_spec then
        return
    end
    if not lineAdded then
        local upgrade_text, r, g, b = show_dps_change()
        if upgrade_text then
            tooltip:AddLine(upgrade_text, r, g, b)
            lineAdded = true
        end
    end
end

local function OnTooltipCleared(tooltip, ...)
    lineAdded = false
end

local function check_spec()
    is_active_spec = select(2, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex("player"))) == 'Brewmaster' -- #TODO localisation
end

local frame, events = CreateFrame("FRAME", "SimpleBrewSimFrame"), {};
--function events:PLAYER_ENTERING_WORLD(...)end
function events:PLAYER_SPECIALIZATION_CHANGED(...)
    check_spec()
    if is_active_spec then
        print('player spec changed')
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
    check_spec()
    if is_active_spec then
        --- SimpleBrewSim:cache_traits() #TODO Might need to re-enable later, avoid for now since artifact gets added on login
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


