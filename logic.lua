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
local relic_list = SimpleBrewSim:create_set({ SimpleBrewSim.CONCORDANCE_ID, SimpleBrewSim.FACE_PALM_ID, SimpleBrewSim.OBSIDIAN_FIST_ID })
-- Caching functions
function SimpleBrewSim:cache_base_stats()
    base_stats.agi = select(2, UnitStat("player", 2)) - select(3, UnitStat("player", 2)) --most likely not needed
    base_stats.mastery = SimpleBrewSim:round(GetMastery() - GetCombatRatingBonus(CR_MASTERY), 2)
    base_stats.crit = SimpleBrewSim:round(GetCritChance() - GetCombatRatingBonus(CR_CRIT_MELEE), 2)
    base_stats.haste = SimpleBrewSim:round(GetHaste() - GetCombatRatingBonus(CR_HASTE_MELEE), 2)
    -- no round for conc vers
    self.calculate_conc_vers()
    --base_stats.vers = SimpleBrewSim:CalculateConcVers() / 475
    --base_stats.vers = SimpleBrewSim:round(SimpleBrewSim:CalculateConcVers() / 475, 2)
end

function SimpleBrewSim:cache_traits()
    SimpleBrewSim.CACHED_TRAITS = SimpleBrewSim:get_traits(relic_list)
    crit_adjust = SimpleBrewSim.CACHED_TRAITS[SimpleBrewSim.OBSIDIAN_FIST_ID] or 0 * SimpleBrewSim.OBSIDIAN_FIST_MOD * SimpleBrewSim.BOS_DMG.THREE_TP
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

function SimpleBrewSim:calculate_conc_vers()
    local conc_rank = SimpleBrewSim.CACHED_TRAITS[SimpleBrewSim.CONCORDANCE_ID] or 0

    local base_vers = 0
    if conc_rank > 0 then
        base_vers = SimpleBrewSim.BASE_CONC + (conc_rank-1) * SimpleBrewSim.CONC_INCREASE * SimpleBrewSim.CONC_UPTIME / SimpleBrewSim.VERS
        print('vers conc: ',base_vers)
    end
    base_stats.vers = base_vers
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
    -- if new item has a gem, get stat and add it to new stats
    -- if old item has a gem, get stat and remove it from new stats
    wipe(stat_delta)
    GetItemStatDelta(new_item, equipped_item, stat_delta)
    new_stats.agi = equipped_ratings['agi'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_AGILITY_SHORT')
    new_stats.mastery = equipped_ratings['mastery'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_MASTERY_RATING_SHORT')
    new_stats.crit = equipped_ratings['crit'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_CRIT_RATING_SHORT')
    new_stats.haste = equipped_ratings['haste'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_HASTE_RATING_SHORT')
    new_stats.vers = equipped_ratings['vers'] + SimpleBrewSim:get_delta(stat_delta, 'ITEM_MOD_VERSATILITY')
end

-- #TODO move OSF mod to rotations, support for multiple rotations
function SimpleBrewSim:calculate_stat_score(stats)
    local haste_value = SimpleBrewSim:calc_haste_val_3tp(stats['haste'])
--[[
    print('agi ', stats['agi'])
    print('mastery: ', (1 + (stats['mastery'] / SimpleBrewSim.MASTERY + base_stats.mastery) / 100))
    print('crit: ', (1 + (stats['crit'] / SimpleBrewSim.CRIT + base_stats.crit) / 100 + crit_adjust))
    print('vers: ', (1 + (stats['vers'] / SimpleBrewSim.VERS + base_stats.vers) / 100))
    print('haste: ', haste_value)
    ]]--
    return stats['agi'] * (1 + (stats['mastery'] / SimpleBrewSim.MASTERY + base_stats.mastery) / 100) * (1 + (stats['crit'] / SimpleBrewSim.CRIT + base_stats.crit) / 100 + crit_adjust) * (1 + (stats['vers'] / SimpleBrewSim.VERS + base_stats.vers) / 100) * haste_value
end


