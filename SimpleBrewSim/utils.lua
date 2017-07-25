local name, SimpleBrewSim = ...;
local LAD = LibStub("LibArtifactData-1.0")
local brew_ID = 128938
function SimpleBrewSim:create_set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

function SimpleBrewSim:ARTIFACT_TRAITS_CHANGED()
    SimpleBrewSim:cache_traits()
end

function SimpleBrewSim:ARTIFACT_ADDED(event, artifactID)
    if artifactID ~= brew_ID then
        return
    end
    SimpleBrewSim:cache_traits()
end

function SimpleBrewSim:get_traits(spellIDs)
    local _, traits = LAD:GetArtifactTraits(brew_ID)
    if not traits then
        LAD:ForceUpdate()
        _, traits = LAD:GetArtifactTraits(brew_ID)
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
LAD.RegisterCallback(SimpleBrewSim, "ARTIFACT_ADDED")

