local EVENT = {}
CreateConVar("randomat_gunfire_timer", 20, FCVAR_ARCHIVE, "Seconds before a player is ignited", 1, 120)
EVENT.Title = "Gunfire"
EVENT.Description = "Not shooting for too long sets you on fire!"
EVENT.id = "gunfire"

EVENT.Categories = {"moderateimpact"}

util.AddNetworkString("GunfireRandomatClientBegin")
util.AddNetworkString("GunfireRandomatClientClickExtinguish")
util.AddNetworkString("GunfireRandomatClientEnd")

local function RestartExtinguishTimer(ply)
    timer.Create(ply:SteamID64() .. "_gunfire_timer", 1, GetConVar("randomat_gunfire_timer"):GetInt(), function()
        if timer.RepsLeft(ply:SteamID64() .. "_gunfire_timer") == 0 and ply:Alive() and not ply:IsSpec() then
            ply:Ignite(60)
            ply:PrintMessage(HUD_PRINTCENTER, "Shoot to extinguish!")
            ply:PrintMessage(HUD_PRINTTALK, "'" .. EVENT.Title .. "' is active!\n" .. EVENT.Description)
        end
    end)
end

function EVENT:Begin()
    -- Initial player igniting timer
    for i, ply in pairs(self:GetAlivePlayers()) do
        RestartExtinguishTimer(ply)
    end

    -- Extinguish respawned players 
    self:AddHook("PlayerSpawn", function(ply)
        RestartExtinguishTimer(ply)
    end)

    net.Start("GunfireRandomatClientBegin")
    net.Broadcast("GunfireRandomatClientBegin")

    -- Extinguish players when they press their primary attack button at the appropriate time
    net.Receive("GunfireRandomatClientClickExtinguish", function(len, ply)
        RestartExtinguishTimer(ply)
        ply:Extinguish()
    end)
end

function EVENT:End()
    for i, ply in pairs(self:GetPlayers()) do
        timer.Remove(ply:SteamID64() .. "_gunfire_timer")
        ply:Extinguish()
    end

    net.Start("GunfireRandomatClientEnd")
    net.Broadcast()
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"timer"}) do
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