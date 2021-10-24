local EVENT = {}

CreateConVar("randomat_speedrun_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time in seconds the round will last", 5)

EVENT.Title = "Speedrun!"
EVENT.Description = GetConVar("randomat_speedrun_time"):GetInt() .. " second round"
EVENT.id = "speedrun"
local speedrunRandomat = false
local hasteMode = false
local hasteMinutes = 0.5

function EVENT:Begin()
    speedrunRandomat = true
    hasteMode = GetConVar("ttt_haste"):GetBool()
    hasteMinutes = GetConVar("ttt_haste_minutes_per_death"):GetFloat()

    -- This global float controls the time the round will end, part of base TTT
    if hasteMode then
        GetConVar("ttt_haste"):SetBool(false)
        GetConVar("ttt_haste_minutes_per_death"):SetFloat(0)
        SetGlobalFloat("ttt_haste_end", CurTime() + GetConVar("randomat_speedrun_time"):GetInt())
        SetGlobalFloat("ttt_round_end", CurTime() + GetConVar("randomat_speedrun_time"):GetInt())
    else
        SetGlobalFloat("ttt_round_end", CurTime() + GetConVar("randomat_speedrun_time"):GetInt())
    end
end

function EVENT:End()
    -- If the begin function has run, set the zombie prime weapons setting to what it was,
    if speedrunRandomat then
        GetConVar("ttt_zombie_prime_only_weapons"):SetBool(initialPrimeOnlyWeapons)

        if hasteMode then
            GetConVar("ttt_haste"):SetBool(true)
            GetConVar("ttt_haste_minutes_per_death"):SetFloat(hasteMinutes)
        end

        -- And prevent the end function from being run until this randomat triggers again
        speedrunRandomat = false
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"time"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)