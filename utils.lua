--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 18/07/2017
-- Time: 11:06
-- To change this template use File | Settings | File Templates.
--
local name, SimpleSim = ...;
local LAD = LibStub("LibArtifactData-1.0")

function SimpleSim:get_traits(spellIDs)
    local traits = select(2, LAD:GetArtifactTraits())
    local return_list = {}
    for key, trait in pairs(traits) do
        local spellID = trait['spellID']
        if spellIDs[spellID] then
            returnList[spellID] = trait['currentRank']
        end
    end
    return return_list
end

function SimpleSim:round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

function SimpleSim:get_delta(stat_delta, stat)
    return stat_delta[stat] or 0
end
