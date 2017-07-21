local name, SimpleBrewSim = ...;
local LAD = LibStub("LibArtifactData-1.0")

function SimpleBrewSim:create_set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

function SimpleBrewSim:ARTIFACT_TRAITS_CHANGED()
    print('ARTIFACT_TRAITS_CHANGED')
    SimpleBrewSim:cache_traits()
    SimpleBrewSim:cache_base_stats()
end

function SimpleBrewSim:get_traits(spellIDs)
    local traits = select(2, LAD:GetArtifactTraits())
    if not traits then
        LAD:ForceUpdate()
        traits = select(2, LAD:GetArtifactTraits())
    end
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

function SimpleBrewSim:round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

function SimpleBrewSim:get_delta(stat_delta, stat)
    if not stat_delta or not stat_delta[stat] then
        return 0
    end

    return stat_delta[stat]
end

LAD.RegisterCallback(SimpleBrewSim, "ARTIFACT_TRAITS_CHANGED")
