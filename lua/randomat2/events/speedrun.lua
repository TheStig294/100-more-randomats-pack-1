local EVENT = {}

CreateConVar("randomat_speedrun_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time in seconds the round will last", 30, 120)

EVENT.Title = "Speedrun!"
EVENT.Description = GetConVar("randomat_speedrun_time"):GetInt() .. " second round"
EVENT.id = "speedrun"
local speedrunRandomat = false
local hasteMode = false
local hasteMinutes = 0.5
local modelExists = util.IsValidModel("models/vinrax/player/mgs_solid_snake.mdl")

function EVENT:Begin()
    speedrunRandomat = true
    hasteMode = GetConVar("ttt_haste"):GetBool()
    hasteMinutes = GetConVar("ttt_haste_minutes_per_death"):GetFloat()
    local time = GetConVar("randomat_speedrun_time"):GetInt()
    self.Description = time .. " second round"

    -- This global float controls the time the round will end, part of base TTT
    if hasteMode then
        GetConVar("ttt_haste"):SetBool(false)
        GetConVar("ttt_haste_minutes_per_death"):SetFloat(0)
        SetGlobalFloat("ttt_haste_end", CurTime() + time)
        SetGlobalFloat("ttt_round_end", CurTime() + time)
    else
        SetGlobalFloat("ttt_round_end", CurTime() + time)
    end

    if modelExists then
        for i, ply in ipairs(self:GetAlivePlayers()) do
            if ply:GetModel() == "models/bna/michiru.mdl" or ply:Nick() == "boba" then
                ForceSetPlayermodel(ply, "models/vinrax/player/mgs_solid_snake.mdl")
                ply:ChatPrint("Your name or model has triggered an easter egg!\nYour playermodel has changed for this randomat")
            end
        end

        self:AddHook("PlayerSpawn", function(ply)
            timer.Simple(1, function()
                if ply:GetModel() == "models/bna/michiru.mdl" or ply:Nick() == "boba" then
                    ForceSetPlayermodel(ply, "models/vinrax/player/mgs_solid_snake.mdl")
                end
            end)
        end)
    end
end

function EVENT:End()
    if speedrunRandomat then
        if hasteMode then
            GetConVar("ttt_haste"):SetBool(true)
            GetConVar("ttt_haste_minutes_per_death"):SetFloat(hasteMinutes)
        end

        -- Prevent the end function from being run until this randomat triggers again
        speedrunRandomat = false
        ForceResetAllPlayermodels()
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