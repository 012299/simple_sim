--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 16/07/2017
-- Time: 12:36
-- To change this template use File | Settings | File Templates.
--
local LAD = LibStub("LibArtifactData-1.0")
local BASE_CONC = 4000
local CONC_INCREASE = 300
local CONC_UPTIME = 20 / 60
local base_stats = {}
local equipped_ratings = {}

-- Caching functions
function cache_base_stats()
    --Something with base stats
    base_stats.agi = select(2, UnitStat("player", 2)) - select(3, UnitStat("player", 2))
    base_stats.mastery = round(GetMastery() - GetCombatRatingBonus(CR_MASTERY), 2)
    base_stats.crit = round(GetCritChance() - GetCombatRatingBonus(CR_CRIT_MELEE), 2)
    base_stats.haste = round(GetHaste() - GetCombatRatingBonus(CR_HASTE_MELEE), 2)
    base_stats.vers = round(CalculateConcVers() / 475, 2)
end

-- Gets calculated whenever gear changes
-- TODO: consider buffs (and ignore them)
function cache_equipped_ratings()
    equipped_ratings.agi = select(2, UnitStat("player", 2)) -- support for flasks etc
    equipped_ratings.mastery = GetCombatRatingBonus(CR_MASTERY)
    equipped_ratings.crit = GetCombatRatingBonus(CR_CRIT_MELEE)
    equipped_ratings.haste = GetCombatRatingBonus(CR_HASTE_MELEE)
    equipped_ratings.vers = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)
end

function CalculateConcVers()

    local traits = select(2, LAD:GetArtifactTraits())
    local conc_rank = 0
    local base_vers = 0
    for key, trait in pairs(traits) do
        local spellID = trait['spellID']
        if spellID == 239042 then
            conc_rank = trait['currentRank']
            break;
        end
    end
    if conc_rank > 0 then
        base_vers = BASE_CONC
        conc_rank = conc_rank - 1
        for i = conc_rank, 1, -1 do
            base_vers = base_vers + CONC_INCREASE
        end
        base_vers = base_vers * CONC_UPTIME
    end
    return base_vers
end

-- called when comparing items
function compare_items(equipped_item,new_item)
    local new_stats = calculate_gear_delta(equipped_item,new_item)
    local equipped_score = calculate_stat_score(equipped_ratings)
    local new_score = calculate_stat_score(new_stats)
    local upgrade = (new_score - equipped_score)/equipped_score*100

end

--name, link = GameTooltip:GetItem()-
function calculate_gear_delta(equipped_item,new_item)
    local stat_delta = GetItemStatDelta(equipped_item,new_item)
    local new_stats = {}
    new_stats.agi = base_stats['agi'] + get_delta(stat_delta,'ITEM_MOD_AGILITY_SHORT')
    new_stats.mastery = base_stats['mastery'] + get_delta(stat_delta,'ITEM_MOD_MASTERY_RATING_SHORT')
    new_stats.crit = base_stats['crit'] + get_delta(stat_delta,'ITEM_MOD_CRIT_RATING_SHORT')
    new_stats.haste = base_stats['haste'] + get_delta(stat_delta,'ITEM_MOD_HASTE_RATING_SHORT')
    new_stats.vers = base_stats['vers'] + get_delta(stat_delta,'ITEM_MOD_VERSATILITY')
    return new_stats
end

function calculate_stat_score(stats)
    local haste = calc_haste_val_3tp(stats['haste'])
    return stats['agi'] * (1 + stats['mastery'] / 100) * (1 + stats['crit'] / 100) * (1 + stats['vers'] / 100) * haste
end

