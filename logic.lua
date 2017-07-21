--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 16/07/2017
-- Time: 12:36
-- To change this template use File | Settings | File Templates.
--
local name, SimpleBrewSim = ...;
local base_stats = {}
local equipped_ratings = {}
local crit_adjust = 0
local stat_delta = {}
local new_stats = {}
local haste_value = 0
-- Caching functions
function SimpleBrewSim:cache_base_stats()
    base_stats.agi = select(2, UnitStat("player", 2)) - select(3, UnitStat("player", 2)) --most likely not needed
    base_stats.mastery = SimpleBrewSim.round(GetMastery() - GetCombatRatingBonus(CR_MASTERY), 2)
    base_stats.crit = SimpleBrewSim.round(GetCritChance() - GetCombatRatingBonus(CR_CRIT_MELEE), 2)
    base_stats.haste = SimpleBrewSim.round(GetHaste() - GetCombatRatingBonus(CR_HASTE_MELEE), 2)
    base_stats.vers = SimpleBrewSim.round(SimpleBrewSim:CalculateConcVers() / 475, 2)
end

function SimpleBrewSim:cache_traits()
    local templist = { SimpleBrewSim.Relics.CONCORDANCE_ID, SimpleBrewSim.Relics.FACE_PALM_ID, SimpleBrewSim.Relics.OBSIDIAN_FIST_ID }
    SimpleBrewSim.CACHED_TRAITS = SimpleBrewSim:get_traits(SimpleBrewSim:create_set(templist))
    crit_adjust = SimpleBrewSim.CACHED_TRAITS[SimpleBrewSim.Relics.OBSIDIAN_FIST_ID] * SimpleBrewSim.Relics.OSF_MOD * SimpleBrewSim.Settings.BOS_DMG.THREE_TP
end

-- Gets calculated whenever gear changes
-- TODO: consider buffs (and ignore them)
function SimpleBrewSim:cache_equipped_ratings()
    equipped_ratings.agi = select(2, UnitStat("player", 2)) -- support for flasks etc
    equipped_ratings.mastery = GetCombatRating(CR_MASTERY)
    equipped_ratings.crit = GetCombatRating(CR_CRIT_MELEE)
    equipped_ratings.haste = GetCombatRating(CR_HASTE_MELEE)
    equipped_ratings.vers = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
end

function SimpleBrewSim:CalculateConcVers()
    local conc_rank = SimpleBrewSim.CACHED_TRAITS[SimpleBrewSim.Relics.CONCORDANCE_ID] or 0

    local base_vers = 0
    if conc_rank > 0 then
        base_vers = SimpleBrewSim.Settings.BASE_CONC
        conc_rank = conc_rank - 1
        for i = conc_rank, 1, -1 do
            base_vers = base_vers + SimpleBrewSim.Settings.CONC_INCREASE
        end
        base_vers = base_vers * SimpleBrewSim.Settings.CONC_UPTIME
    end
    return base_vers
end

-- called when comparing items
function SimpleBrewSim:compare_items(equipped_item, new_item)
    SimpleBrewSim:calculate_gear_delta(equipped_item, new_item)
    local equipped_score = SimpleBrewSim:calculate_stat_score(equipped_ratings)
    local new_score = SimpleBrewSim:calculate_stat_score(new_stats)
    wipe(new_stats)
    return (new_score - equipped_score) / equipped_score * 100
end

function SimpleBrewSim:calculate_gear_delta(equipped_item, new_item)
    GetItemStatDelta(new_item, equipped_item, stat_delta)
    new_stats.agi = equipped_ratings['agi'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_AGILITY_SHORT')
    new_stats.mastery = equipped_ratings['mastery'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_MASTERY_RATING_SHORT')
    new_stats.crit = equipped_ratings['crit'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_CRIT_RATING_SHORT')
    new_stats.haste = equipped_ratings['haste'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_HASTE_RATING_SHORT')
    new_stats.vers = equipped_ratings['vers'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_VERSATILITY')
    wipe(stat_delta)
end

-- #TODO move OSF mod to rotations, support for multiple rotations
function SimpleBrewSim:calculate_stat_score(stats)
    haste_value = SimpleBrewSim:calc_haste_val_3tp(stats['haste'])
    return stats['agi'] * (1 + (stats['mastery'] / SimpleBrewSim.MASTERY + base_stats.mastery) / 100) * (1 + (stats['crit'] / SimpleBrewSim.CRIT + base_stats.crit) / 100 + crit_adjust) * (1 + (stats['vers'] / SimpleBrewSim.VERS + base_stats.vers) / 100) * haste_value
end


