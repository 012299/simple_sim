--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 20/07/2017
-- Time: 21:33
-- To change this template use File | Settings | File Templates.
--
local name, SimpleBrewSim = ...;


SimpleBrewSim.Settings = {}
SimpleBrewSim.Relics = {}
SimpleBrewSim.Armour = {ARMOUR_TYPES={} }
---SimpleBrewSim.Gems = {}
---Saber's Eye of Agility
---Versatile Maelstrom Sapphire
---Deadly Eye of Prophecy
---Quick Dawnlight
---Masterful Shadowruby
SimpleBrewSim.CACHED_TRAITS = {}
-- rating values
SimpleBrewSim.MASTERY = 400
SimpleBrewSim.CRIT = 400
SimpleBrewSim.HASTE = 375
SimpleBrewSim.VERS = 475
-- Fight settings
SimpleBrewSim.Settings.BASE_CONC = 4000
SimpleBrewSim.Settings.CONC_INCREASE = 300
SimpleBrewSim.Settings.CONC_UPTIME = 20 / 60
SimpleBrewSim.Settings.FIGHT_LENGHT = 300 -- used for BL
SimpleBrewSim.Settings.RELEVANT_FIGHT_LENGTH = (SimpleBrewSim.Settings.FIGHT_LENGHT - 40) / SimpleBrewSim.Settings.FIGHT_LENGHT -- starvation during BL doesn't occur, haste is worthless during BL
SimpleBrewSim.Settings.BOB_CD = 90
SimpleBrewSim.Settings.EK_CD = 75
SimpleBrewSim.Settings.BASE_REGEN = 10
SimpleBrewSim.Settings.KS_COST = 40
SimpleBrewSim.Settings.TP_COST = 25
SimpleBrewSim.Settings.BOS_DMG = {TWO_TP=0,THREE_TP=0.266173880000277} --chest/shoulder support
-- Relic vars
SimpleBrewSim.Relics.OSF_MOD = 0.03
SimpleBrewSim.Relics.CONCORDANCE_ID = 239042
SimpleBrewSim.Relics.FACE_PALM_ID = 213116
SimpleBrewSim.Relics.OBSIDIAN_FIST_ID = 213051
--Armor constants
SimpleBrewSim.Armour.ARMOUR_TYPES[LE_ITEM_ARMOR_GENERIC]=true
SimpleBrewSim.Armour.ARMOUR_TYPES[LE_ITEM_ARMOR_LEATHER]=true





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

