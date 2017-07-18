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
local ENERGY_PER_HASTE_POINT = .01 / 375 * 10 --Energy regen granted by a single point of haste

function calc_haste_val_3tp(haste)
    local fp_ranks = 4 -- #TODO grab actual ranks
    local rotation_duration = 9
    local energy_out = 115
    local brew_reduction_cycle = 4.8 + 3 + (3 * .1 * fp_ranks) + rotation_duration -- 3 tps, 1 KS
    local brew_gen_sec = brew_reduction_cycle / rotation_duration
    local bob_cd = BOB_CD / brew_gen_sec - 6 -- There's no starvation on base energy regen for the last 6 casts in the cycle, haste does nothing for us at this point
    return calculate_downtime(haste, energy_out, rotation_duration, bob_cd)
end

-- Calculates after how many cycles there's not enough energy for the next KS
function calculate_downtime(haste, energy_out, duration, bob_cd)
    local haste_perc = haste / 375
    local energy_regen = BASE_REGEN * (1 + haste_perc / 100)
    local energy = 100 -- #TODO add support for racial/arcway neck
    local energy_in = energy_regen * duration
    local energy_diff = energy_out - energy_in
    local energy_def = 0
    local starvation_cut_off = 0
    local ek_adjust = bob_cd / EK_CD -- EK on cd for max dps, filling a gcd with EK gives time to regen energy. For average downtime calculation, use average EK cast
    for i = 0, bob_cd, duration do -- redo this properly at some point
        energy = energy - energy_diff
        if energy < KS_COST then
            energy_def = KS_COST - energy
            energy_def = TP_COST - 2 * energy_regen + energy_def -- TP energy requirement
            starvation_cut_off = i
        end
    end
    local downtime = (energy_def / energy_regen - ek_adjust) / (bob_cd + ek_adjust) * RELEVANT_FIGHT_LENGTH
    if downtime < 0 then
        return 1
    end
    return 1 - downtime
end





--    local energy_requirement_points = math.abs((energy_def/starvation_cut_off)/ENERGY_PER_HASTE_POINT) --For later, when using weights etcRequired energy/second, energy regen needs to go up over the course of the fight in order to not starve
