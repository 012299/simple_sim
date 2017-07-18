--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 18/07/2017
-- Time: 11:06
-- To change this template use File | Settings | File Templates.
--
function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

function get_delta(stat_delta,stat)
    return stat_delta[stat] or 0
end
