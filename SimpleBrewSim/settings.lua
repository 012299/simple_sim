--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 20/07/2017
-- Time: 21:33
-- To change this template use File | Settings | File Templates.
--
local name, SimpleBrewSim = ...;

--- GEMS
SimpleBrewSim['Saber\'s Eye of Agility'] = { 'agi', 200 }
SimpleBrewSim['Versatile Maelstrom Sapphire'] = { 'vers', 150 }
SimpleBrewSim['Deadly Eye of Prophecy'] = { 'crit', 150 }
SimpleBrewSim['Quick Dawnlight'] = { 'haste', 150 }
SimpleBrewSim['Masterful Shadowruby'] = { 'mastery', 150 }
--- TABLES
SimpleBrewSim.CACHED_TRAITS = {}
--- RATING VALUES values #TODO change to support multiplication
SimpleBrewSim.MASTERY = 400
SimpleBrewSim.CRIT = 400
SimpleBrewSim.HASTE = 375
SimpleBrewSim.VERS = 475

--- FIGHT SETTINGS
SimpleBrewSim.FIGHT_LENGHT = 300 -- used for BL
SimpleBrewSim.RELEVANT_FIGHT_LENGTH = (SimpleBrewSim.FIGHT_LENGHT - 40) / SimpleBrewSim.FIGHT_LENGHT -- starvation during BL doesn't occur, haste is worthless during BL
--- ABILITY SETTINGS
SimpleBrewSim.BASE_CONC = 4000
SimpleBrewSim.CONC_INCREASE = 300
SimpleBrewSim.CONC_UPTIME = 20 / 60
SimpleBrewSim.BOB_CD = 90
SimpleBrewSim.EK_CD = 75
SimpleBrewSim.BASE_REGEN = 10
SimpleBrewSim.KS_COST = 40
SimpleBrewSim.TP_COST = 25
SimpleBrewSim.BOS_DMG = { TWO_TP = 0, THREE_TP = 0.266173880000277 } -- #TODO chest/shoulder support
--- RELIC IDS
SimpleBrewSim.OBSIDIAN_FIST_MOD = 0.03
SimpleBrewSim.CONCORDANCE_ID = 239042
SimpleBrewSim.FACE_PALM_ID = 213116
SimpleBrewSim.OBSIDIAN_FIST_ID = 213051
SimpleBrewSim.GIFTED_STUDENT_ID = 213136
--- ARMOUR IDS
SimpleBrewSim.ARMOUR_TYPES = { ['INVTYPE_CLOAK'] = true, [LE_ITEM_ARMOR_GENERIC] = true, [LE_ITEM_ARMOR_LEATHER] = true }

--- BUFFS
SimpleBrewSim.consumables_filter = {
    --- agi buffs
    [188033] = { 'agi' , 1300 }, -- seventh demon
    [242551] = { 'agi' , 500 }, -- legionfall
    [224001] = { 'agi' , 325 }, -- defiled rune
    [201639] = { 'agi' , 500 }, -- big boy feast
    [201635] = { 'agi' , 400 }, -- whiny baby feast
    --- haste buffs
    [201330] = { 'haste' , 225 },
    [225598] = { 'haste' , 300 },
    [225603] = { 'haste' , 375 },
    --- vers buffs
    [201334] = { 'vers' , 225 },
    [225600] = { 'vers' , 300 },
    [225605] = { 'vers' , 375 },
    --- mastery buffs
    [201332] = { 'mastery' , 225 },
    [225599] = { 'mastery' , 300 },
    [225604] = { 'mastery' , 375 },
    --- crit buffs
    [201223] = { 'crit' , 225 },
    [225597] = { 'crit' , 300 },
    [225602] = { 'crit' , 375 },
}
SimpleBrewSim.consumables = { flask = { 'agi', 1300 }, food_buff = { 'agi', 500 }, rune = { 'agi', 325 } }




--Armorslot constants because blizz is dumb
-- Maps between INVTYPEs and slot IDs
SimpleBrewSim.INV_TYPES = {
    INVTYPE_HEAD = 1,
    INVTYPE_NECK = 2,
    INVTYPE_SHOULDER = 3,
    INVTYPE_BODY = 4,
    INVTYPE_CHEST = 5,
    INVTYPE_ROBE = 5,
    INVTYPE_WAIST = 6,
    INVTYPE_LEGS = 7,
    INVTYPE_FEET = 8,
    INVTYPE_WRIST = 9,
    INVTYPE_HAND = 10,
    INVTYPE_FINGER = 11, -- also 12
    INVTYPE_TRINKET = 13, -- also 14
    INVTYPE_CLOAK = 15,
}

