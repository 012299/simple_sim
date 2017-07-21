--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 20/07/2017
-- Time: 21:33
-- To change this template use File | Settings | File Templates.
--
local name, settings = ...;


settings.Settings = {}
settings.Relics = {}
settings.Armour = {ARMOUR_TYPES={}}
settings.CACHED_TRAITS = {}
-- rating values
settings.MASTERY = 400
settings.CRIT = 400
settings.HASTE = 375
settings.VERS = 475
-- Fight settings
settings.Settings.BASE_CONC = 4000
settings.Settings.CONC_INCREASE = 300
settings.Settings.CONC_UPTIME = 20 / 60
settings.Settings.FIGHT_LENGHT = 300 -- used for BL
settings.Settings.RELEVANT_FIGHT_LENGTH = (settings.Settings.FIGHT_LENGHT - 40) / settings.Settings.FIGHT_LENGHT -- starvation during BL doesn't occur, haste is worthless during BL
settings.Settings.BOB_CD = 90
settings.Settings.EK_CD = 75
settings.Settings.BASE_REGEN = 10
settings.Settings.KS_COST = 40
settings.Settings.TP_COST = 25
settings.Settings.BOS_DMG = {TWO_TP=0,THREE_TP=0.266173880000277} --chest/shoulder support
-- Relic vars
settings.Relics.OSF_MOD = 0.03
settings.Relics.CONCORDANCE_ID = 239042
settings.Relics.FACE_PALM_ID = 213116
settings.Relics.OBSIDIAN_FIST_ID = 213051

--Armor constants
settings.Armour.ARMOUR_TYPES[LE_ITEM_ARMOR_GENERIC]=true
settings.Armour.ARMOUR_TYPES[LE_ITEM_ARMOR_LEATHER]=true  -- #TODO localisation GetItemSubClassInfo(LE_ITEM_CLASS_ARMOR)





--Armorslot constants because blizz is dumb
-- Maps between INVTYPEs and slot IDs
settings.INV_TYPES = {
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

