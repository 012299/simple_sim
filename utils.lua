--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 18/07/2017
-- Time: 11:06
-- To change this template use File | Settings | File Templates.
--
local name, settings = ...;
local LAD = LibStub("LibArtifactData-1.0")
-- #TODO will most likely need to adjust spellID array to table

function settings:create_set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

function settings:get_traits(spellIDs)
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

function settings:round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

function settings:get_delta(stat_delta, stat)
    return stat_delta[stat] or 0
end
