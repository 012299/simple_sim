--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 20/07/2017
-- Time: 21:33
-- To change this template use File | Settings | File Templates.
--
local name, SimpleSim = ...;

SimpleSim.Settings = {}
SimpleSim.Relics = {}
-- Fight settings
SimpleSim.Settings.BASE_CONC = 4000
SimpleSim.Settings.CONC_INCREASE = 300
SimpleSim.Settings.CONC_UPTIME = 20 / 60
SimpleSim.Settings.FIGHT_LENGHT = 300 -- used for BL
SimpleSim.Settings.RELEVANT_FIGHT_LENGTH = (FIGHT_LENGHT - 40) / FIGHT_LENGHT -- starvation during BL doesn't occur, haste is worthless during BL
SimpleSim.Settings.BOB_CD = 90
SimpleSim.Settings.EK_CD = 75
SimpleSim.Settings.BASE_REGEN = 10
SimpleSim.Settings.KS_COST = 40
SimpleSim.Settings.TP_COST = 25
SimpleSim.Settings.BOS_DMG = {TWO_TP=0,THREE_TP=0.266173880000277} --chest/shoulder support
-- Relic vars
SimpleSim.Relics.OsF_MoD = 0.03
SimpleSim.Relics.CONCORDANCE_ID = 239042
SimpleSim.Relics.FACE_PALM_ID = 213116
SimpleSim.Relics.OBSIDIAN_FIST_ID = 213051
