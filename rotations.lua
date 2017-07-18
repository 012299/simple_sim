--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 18/07/2017
-- Time: 17:20
-- To change this template use File | Settings | File Templates.
--

-- 3tp energy calculations
--[[ 3tp rotation, 9 casts per cycle
4.8 sec KS reduction (recursive stave off not reliable enough for average brew reduction)
Energy requirement to be able to start a cycle and cast the first TP
 ]]
local FIGHT_LENGHT = 300 -- used for BL
local 
function placeholder()
    local fp_ranks = 4 -- #TODO grab actual ranks
    local brew_reduction_cycle = 4.8 + 3 + (3*.1*fp_ranks) + 9 -- 3 tps, 1 KS
    local brew_gen_sec = brew_reduction_cycle / 9



end
