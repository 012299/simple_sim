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
local ACTUAL_LENGTH_PERCENT = (FIGHT_LENGHT - 40) / FIGHT_LENGHT -- actual fight without BL
local BOB_CD = 90
local EK_CD = 75
local BASE_REGEN = 10

function calculate_haste_3tp(haste)
    local fp_ranks = 4 -- #TODO grab actual ranks
    local brew_reduction_cycle = 4.8 + 3 + (3 * .1 * fp_ranks) + 9 -- 3 tps, 1 KS
    local brew_gen_sec = brew_reduction_cycle / 9
    local bob_cd = BOB_CD / brew_gen_sec - 6 -- There's no starvation on base energy regen for the last 6 casts in the cycle
end

function calculate_starvation(haste,energy_out,duration)
    local haste_perc = haste/375
    local energy_regen = BASE_REGEN * (1+haste_perc/100)
    local energy_in = energy_regen*duration
    
    end