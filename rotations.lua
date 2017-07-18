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
local RELEVANT_FIGHT_LENGTH = (FIGHT_LENGHT - 40) / FIGHT_LENGHT -- starvation during BL doesn't occur, haste is worthless during BL
local BOB_CD = 90
local EK_CD = 75
local BASE_REGEN = 10
local KS_COST = 40
local TP_COST = 25

function calculate_haste_3tp(haste)
    local fp_ranks = 4 -- #TODO grab actual ranks
    local brew_reduction_cycle = 4.8 + 3 + (3 * .1 * fp_ranks) + 9 -- 3 tps, 1 KS
    local brew_gen_sec = brew_reduction_cycle / 9
    local bob_cd = BOB_CD / brew_gen_sec - 6 -- There's no starvation on base energy regen for the last 6 casts in the cycle
end

-- Calculates after how many cycles there's not enough energy for the next KS
-- At 0% haste, ignoring the third cycle and only calculating energy requirements for the 5th cycle, resulted in the same amount of
-- downtime as calculating it starting at the third cycle(25 energy after calculating 3 cycles)
function calculate_starvation(haste, energy_out, duration, bob_cd)
    local haste_perc = haste / 375
    local energy_regen = BASE_REGEN * (1 + haste_perc / 100)
    local energy = 100 -- #TODO add support for racial/arcway neck
    local energy_in = energy_regen * duration
    local energy_diff = energy_out - energy_in
    local energy_def = 0
    local ek_adjust = bob_cd / EK_CD -- EK on cd for max dps, filling a gcd with EK gives time to regen energy. For average downtime calculation, use average EK cast
    for i = 0, bob_cd, duration do -- redo this properly at some point
        energy = energy - energy_diff
        if energy < KS_COST then
            energy_def = KS_COST - energy
            energy_def = TP_COST - 2 * energy_regen + energy_def -- TP energy requirement
            break
        end
    end
    local average_downtime = energy_def / energy_regen - ek_adjust
end