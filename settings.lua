--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 20/07/2017
-- Time: 21:33
-- To change this template use File | Settings | File Templates.
--
local name, SimpleBrewSim = ...;

--- Minimize table usage
---SimpleBrewSim.Gems = {}
---Saber's Eye of Agility
---Versatile Maelstrom Sapphire
---Deadly Eye of Prophecy
---Quick Dawnlight
---Masterful Shadowruby
--- TABLES
SimpleBrewSim.CACHED_TRAITS = {}
SimpleBrewSim.ARMOUR_TYPES ={}
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
SimpleBrewSim.BOS_DMG = {TWO_TP=0,THREE_TP=0.266173880000277} --chest/shoulder support
--- RELIC IDS
SimpleBrewSim.OBSIDIAN_FIST_MOD = 0.03
SimpleBrewSim.CONCORDANCE_ID = 239042
SimpleBrewSim.FACE_PALM_ID = 213116
SimpleBrewSim.OBSIDIAN_FIST_ID = 213051
---ARMOUR IDS
SimpleBrewSim.ARMOUR_TYPES['INVTYPE_CLOAK'] = true
SimpleBrewSim.ARMOUR_TYPES[LE_ITEM_ARMOR_GENERIC]=true
SimpleBrewSim.ARMOUR_TYPES[LE_ITEM_ARMOR_LEATHER]=true


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

