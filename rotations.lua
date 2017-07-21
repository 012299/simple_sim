
-- 3tp energy calculations
--[[ 3tp rotation, 9 casts per cycle
4.8 sec KS reduction (recursive stave off not reliable enough for average brew reduction)
Energy requirement to be able to start a cycle and cast the first TP
 ]]
local name, SimpleBrewSim = ...;


function SimpleBrewSim:calc_haste_val_3tp(haste)
    local fp_ranks = SimpleBrewSim.CACHED_TRAITS[SimpleBrewSim.Relics.FACE_PALM_ID] -- #TODO grab actual ranks
    local rotation_duration = 9
    local energy_out = 115
    local brew_reduction_cycle = 4.8 + 3 + (3 * .1 * fp_ranks) + rotation_duration -- 3 tps, 1 KS
    local brew_gen_sec = brew_reduction_cycle / rotation_duration
    local bob_cd = math.floor(SimpleBrewSim.Settings.BOB_CD / brew_gen_sec/rotation_duration)*rotation_duration +3 --Energy starvation only occurs during the first 3 casts (ks/tp) of a cycle if that cycle has to be started without BoB up
    return SimpleBrewSim:calculate_downtime(haste, energy_out, rotation_duration, bob_cd)
end

-- Calculates after how many cycles there's not enough energy for the next KS
function SimpleBrewSim:calculate_downtime(haste, energy_out, duration, bob_cd)
    local haste_perc = haste / SimpleBrewSim.HASTE
    local energy_regen = SimpleBrewSim.Settings.BASE_REGEN * (1 + haste_perc / 100)
    local energy = UnitPowerMax("player")
    local energy_in = energy_regen * duration
    local energy_diff = energy_out - energy_in
    local energy_def = 0
    local ek_adjust = bob_cd / SimpleBrewSim.Settings.EK_CD -- EK on cd for max dps, filling a gcd with EK gives time to regen energy. For average downtime calculation, use average EK cast
    for i = duration, bob_cd, duration do -- redo this properly at some point
        energy = energy - energy_diff
        if energy < SimpleBrewSim.Settings.KS_COST then
            energy_def = SimpleBrewSim.Settings.KS_COST - energy
            energy_def = SimpleBrewSim.Settings.TP_COST - 2 * energy_regen + energy_def -- TP energy requirement
        end
    end
    local downtime_seconds = energy_def/energy_regen-ek_adjust
    local downtime = (downtime_seconds) / (bob_cd+downtime_seconds+ek_adjust) * SimpleBrewSim.Settings.RELEVANT_FIGHT_LENGTH

    if downtime < 0 then
        return 1
    end
    return 1 - downtime
end





--    local energy_requirement_points = math.abs((energy_def/starvation_cut_off)/ENERGY_PER_HASTE_POINT) --For later, when using weights etcRequired energy/second, energy regen needs to go up over the course of the fight in order to not starve
--local ENERGY_PER_HASTE_POINT = .01 / 375 * 10 --Energy regen granted by a single point of haste
