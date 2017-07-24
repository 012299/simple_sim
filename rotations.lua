
-- 3tp energy calculations
--[[ 3tp rotation, 9 casts per cycle
4.8 sec KS reduction (recursive stave off not reliable enough for average brew reduction)
Energy requirement to be able to start a cycle and cast the first TP
 ]]
local name, SimpleBrewSim = ...;
local BOB_CD = SimpleBrewSim.BOB_CD
local HASTE = SimpleBrewSim.HASTE
local BASE_REGEN = SimpleBrewSim.BASE_REGEN
local EK_CD = SimpleBrewSim.EK_CD
local KS_COST = SimpleBrewSim.KS_COST
local TP_COST = SimpleBrewSim.TP_COST
local RELEVANT_FIGHT_LENGTH = SimpleBrewSim.RELEVANT_FIGHT_LENGTH
local FACE_PALM_ID = SimpleBrewSim.FACE_PALM_ID

-- TODO #arcway necklace support etc
local function calculate_downtime(haste, energy_out, duration, bob_cd,ek_adjust)
    local haste_perc = haste / HASTE
    local energy_regen = BASE_REGEN * (1 + haste_perc / 100)
    local energy = UnitPowerMax("player")
    local energy_in = energy_regen * duration
    local energy_diff = energy_out - energy_in
    local energy_def = 0
    for i = duration, bob_cd, duration do -- redo this properly at some point
        energy = energy - energy_diff
        if energy < KS_COST then
            energy_def = KS_COST - energy
            energy_def = TP_COST - 2 * energy_regen + energy_def -- TP energy requirement
        end
    end
    local downtime_seconds = energy_def/energy_regen-ek_adjust
    local downtime = (downtime_seconds) / (bob_cd+downtime_seconds+ek_adjust) * RELEVANT_FIGHT_LENGTH

    if downtime < 0 then
        return 1
    end
    return 1 - downtime
end
function SimpleBrewSim:calc_haste_val_3tp(haste)
    local fp_ranks = SimpleBrewSim.CACHED_TRAITS[FACE_PALM_ID]
    local rotation_duration = 9
    local energy_out = 115
    local brew_reduction_cycle = 4.8 + 3 + (3 * .1 * fp_ranks) + rotation_duration -- 3 tps, 1 KS
    local brew_gen_sec = brew_reduction_cycle / rotation_duration
    local bob_cd = BOB_CD / brew_gen_sec
    local ek_adjust = bob_cd / EK_CD -- EK isn't 'required' every 'adjusted_bob_cd' time, but every bob_cast
    bob_cd = math.floor(bob_cd/rotation_duration)*rotation_duration +3 --Energy starvation only occurs during the first 3 casts (ks/tp) of a cycle if that cycle has to be started without BoB up
    return calculate_downtime(haste, energy_out, rotation_duration, bob_cd,ek_adjust)
end






--    local energy_requirement_points = math.abs((energy_def/starvation_cut_off)/ENERGY_PER_HASTE_POINT) --For later, when using weights etcRequired energy/second, energy regen needs to go up over the course of the fight in order to not starve
--local ENERGY_PER_HASTE_POINT = .01 / 375 * 10 --Energy regen granted by a single point of haste
