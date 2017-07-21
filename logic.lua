--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 16/07/2017
-- Time: 12:36
-- To change this template use File | Settings | File Templates.
--
local name, settings = ...;
local base_stats = {}
local equipped_ratings = {}

-- Caching functions
function settings:cache_base_stats()
    --Something with base stats
    settings.CACHED_TRAITS = get_traits(settings.create_set({ settings.Relics.CONCORDANCE_ID, settings.Relics.FACE_PALM_ID, settings.Relics.OBSIDIAN_FIST_ID }))
    base_stats.agi = select(2, UnitStat("player", 2)) - select(3, UnitStat("player", 2)) --most likely not needed
    base_stats.mastery = settings.round(GetMastery() - GetCombatRatingBonus(CR_MASTERY), 2)
    base_stats.crit = settings.round(GetCritChance() - GetCombatRatingBonus(CR_CRIT_MELEE), 2)
    base_stats.haste = settings.round(GetHaste() - GetCombatRatingBonus(CR_HASTE_MELEE), 2)
    base_stats.vers = settings.round(CalculateConcVers() / 475, 2)
end

-- Gets calculated whenever gear changes
-- TODO: consider buffs (and ignore them)
function settings:cache_equipped_ratings()
    equipped_ratings.agi = select(2, UnitStat("player", 2)) -- support for flasks etc
    equipped_ratings.mastery = GetCombatRatingBonus(CR_MASTERY)
    equipped_ratings.crit = GetCombatRatingBonus(CR_CRIT_MELEE)
    equipped_ratings.haste = GetCombatRatingBonus(CR_HASTE_MELEE)
    equipped_ratings.vers = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
end

function CalculateConcVers()
    local conc_rank = settings.CACHED_TRAITS[settings.Relics.CONCORDANCE_ID]
    local base_vers = 0
    if conc_rank > 0 then
        base_vers = settings.settings.BASE_CONC
        conc_rank = conc_rank - 1
        for i = conc_rank, 1, -1 do
            base_vers = base_vers + settings.settings.CONC_INCREASE
        end
        base_vers = base_vers * settings.settings.CONC_UPTIME
    end
    return base_vers
end

-- called when comparing items
function settings:compare_items(equipped_item, new_item)
    local new_stats = calculate_gear_delta(equipped_item, new_item)
    local equipped_score = calculate_stat_score(equipped_ratings)
    local new_score = calculate_stat_score(new_stats)
    return (new_score - equipped_score) / equipped_score * 100
end

--name, link = GameTooltip:GetItem()-
function calculate_gear_delta(equipped_item, new_item)
    local stat_delta = GetItemStatDelta(equipped_item, new_item)
    local new_stats = {}
    new_stats.agi = equipped_ratings['agi'] + settings:get_delta(stat_delta, 'ITEM_MOD_AGILITY_SHORT')
    new_stats.mastery = equipped_ratings['mastery'] + settings:get_delta(stat_delta, 'ITEM_MOD_MASTERY_RATING_SHORT')
    new_stats.crit = equipped_ratings['crit'] + settings:get_delta(stat_delta, 'ITEM_MOD_CRIT_RATING_SHORT')
    new_stats.haste = equipped_ratings['haste'] + settings:get_delta(stat_delta, 'ITEM_MOD_HASTE_RATING_SHORT')
    new_stats.vers = equipped_ratings['vers'] + settings:get_delta(stat_delta, 'ITEM_MOD_VERSATILITY')
    return new_stats
end

function calculate_stat_score(stats)
    local haste = SimpleSimcalc_haste_val_3tp(stats['haste'])
    local crit_adjust = settings.CACHED_TRAITS[settings.Relics.OBSIDIAN_FIST_ID] * settings.Relics.OSF_MOD * settings.Settings.BOS_DMG.THREE_TP
    return stats['agi'] * (1 + stats['mastery'] / 100) * (1 + stats['crit'] / 100 + crit_adjust) * (1 + stats['vers'] / 100) * haste
end


