local EVENT = {}
CreateConVar("randomat_speedrun_time", 60, FCVAR_ARCHIVE, "Time in seconds the round will last", 30, 120)
EVENT.Title = "Speedrun!"
EVENT.Description = GetConVar("randomat_speedrun_time"):GetInt() .. " second round"
EVENT.id = "speedrun"

EVENT.Categories = {"biased_innocent", "biased", "largeimpact"}

local modelExists = util.IsValidModel("models/vinrax/player/mgs_solid_snake.mdl")

if modelExists then
    table.insert(EVENT.Categories, "modelchange")
end

util.AddNetworkString("SpeedrunRandomatPlayAlertSound")
local speedrunRandomat = false
local hasteMode = false
local hasteMinutes = 0.5

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

    -- Plays the TF2 announcer voice as the time runs out
    -- Play an initial voice-over as the timer below won't activate until after a second
    if time == 120 then
        net.Start("SpeedrunRandomatPlayAlertSound")
        net.WriteString("speedrun/2mins.mp3")
        net.Broadcast()
    elseif time == 60 then
        net.Start("SpeedrunRandomatPlayAlertSound")
        net.WriteString("speedrun/60sec.mp3")
        net.Broadcast()
    elseif time == 30 then
        net.Start("SpeedrunRandomatPlayAlertSound")
        net.WriteString("speedrun/30sec.mp3")
        net.Broadcast()
    end

    timer.Create("SpeedrunRandomatAnnouncerTimer", 1, time, function()
        if timer.RepsLeft("SpeedrunRandomatAnnouncerTimer") == 120 then
            net.Start("SpeedrunRandomatPlayAlertSound")
            net.WriteString("speedrun/2mins.mp3")
            net.Broadcast()
        elseif timer.RepsLeft("SpeedrunRandomatAnnouncerTimer") == 60 then
            net.Start("SpeedrunRandomatPlayAlertSound")
            net.WriteString("speedrun/60sec.mp3")
            net.Broadcast()
        elseif timer.RepsLeft("SpeedrunRandomatAnnouncerTimer") == 30 then
            net.Start("SpeedrunRandomatPlayAlertSound")
            net.WriteString("speedrun/30sec.mp3")
            net.Broadcast()
        elseif timer.RepsLeft("SpeedrunRandomatAnnouncerTimer") == 20 then
            net.Start("SpeedrunRandomatPlayAlertSound")
            net.WriteString("speedrun/20sec.mp3")
            net.Broadcast()
        elseif timer.RepsLeft("SpeedrunRandomatAnnouncerTimer") == 10 then
            net.Start("SpeedrunRandomatPlayAlertSound")
            net.WriteString("speedrun/10sec.mp3")
            net.Broadcast()
        end
    end)

    -- Boba playermodel easter egg
    if modelExists then
        for i, ply in ipairs(self:GetAlivePlayers()) do
            if ply:GetModel() == "models/bna/michiru.mdl" or ply:Nick() == "boba" then
                Randomat:ForceSetPlayermodel(ply, "models/vinrax/player/mgs_solid_snake.mdl")
                ply:ChatPrint("Your name or model has triggered an easter egg!\nYour playermodel has changed for this randomat")
            end
        end

        self:AddHook("PlayerSpawn", function(ply)
            timer.Simple(1, function()
                if ply:GetModel() == "models/bna/michiru.mdl" or ply:Nick() == "boba" then
                    Randomat:ForceSetPlayermodel(ply, "models/vinrax/player/mgs_solid_snake.mdl")
                end
            end)
        end)
    end
end

function EVENT:End()
    if speedrunRandomat then
        speedrunRandomat = false

        if hasteMode then
            GetConVar("ttt_haste"):SetBool(true)
            GetConVar("ttt_haste_minutes_per_death"):SetFloat(hasteMinutes)
        end

        timer.Remove("SpeedrunRandomatAnnouncerTimer")
        -- Prevent the end function from being run until this randomat triggers again
        Randomat:ForceResetAllPlayermodels()
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