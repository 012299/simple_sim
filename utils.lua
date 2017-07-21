--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 18/07/2017
-- Time: 11:06
-- To change this template use File | Settings | File Templates.
--
local name, settings = ...;
local LAD = LibStub("LibArtifactData-1.0")

function settings:create_set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

function settings:ARTIFACT_TRAITS_CHANGED()
    print('ARTIFACT_TRAITS_CHANGED')
    settings:cache_base_stats()
end
function settings:get_traits(spellIDs)
    LAD:ForceUpdate()
    local traits = select(2, LAD:GetArtifactTraits())

    local return_list = {}
    if not traits then
        return return_list
    end

    for _, trait in pairs(traits) do
        local spellID = trait['spellID']
        if spellIDs[spellID] then
            return_list[spellID] = trait['currentRank']
        end
    end
    return return_list
end

function settings:round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

function settings:get_delta(stat_delta, stat)
    return stat_delta[stat] or 0
end
LAD.RegisterCallback(settings,"ARTIFACT_TRAITS_CHANGED")
