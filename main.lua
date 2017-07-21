--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 16/07/2017
-- Time: 12:36
-- To change this template use File | Settings | File Templates.
--
local name, settings = ...;

local spec = select(2, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex("player")));
if spec ~= "Brewmaster" then
    return
end
-- Maybe add a 'do nothing if same item'
function GetItem()
    local new_item_link = select(2, GameTooltip:GetItem())
    local equip_slot, _, _, item_class, item_subclass = select(9, GetItemInfo(new_item_link))
    if item_class ~= LE_ITEM_CLASS_ARMOR then
        return
    end
    if not settings.ARMOUR.ARMOUR_TYPES[item_subclass] then
        return
    end
    local equipped_id = settings.INV_TYPES[equip_slot]
    if not equipped_id then
        return
    end
    if equipped_id == settings.INV_TYPES[INVTYPE_TRINKET] or equipped_id == settings.INV_TYPES[INVTYPE_FINGER] then
        -- take care of multiple items
    end
    local equipped_item_link = GetInventoryItemLink("player",equipped_id)
    local upgrade = settings:compare_items(equipped_item_link,new_item_link)

end
