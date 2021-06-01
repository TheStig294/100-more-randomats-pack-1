local EVENT = {}

CreateConVar("randomat_speedrun_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time in seconds the round will last", 5)

EVENT.Title = "Speedrun!"
EVENT.Description = GetConVar("randomat_speedrun_time"):GetInt().." second round"
EVENT.id = "speedrun"

function EVENT:Begin()
	SetGlobalFloat("ttt_round_end", CurTime() + GetConVar("randomat_speedrun_time"):GetInt())
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