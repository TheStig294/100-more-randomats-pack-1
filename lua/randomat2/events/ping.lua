local EVENT = {}

CreateConVar("randomat_ping_cooldown", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds until you can ping again", 0, 200)

CreateConVar("randomat_ping_global_cooldown", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds until anyone can ping again after 1 person pings", 0, 200)

CreateConVar("randomat_ping_spectators", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether spectators can ping", 0, 1)

CreateConVar("randomat_ping_sound", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether pinging plays a sound", 0, 1)

EVENT.Title = "Press E to ping"

if GetConVar("randomat_ping_spectators"):GetBool() then
    EVENT.Description = "Spectators can also ping!"
end

EVENT.id = "ping"

EVENT.Categories = {"spectator", "biased_innocent", "biased", "smallimpact"}

util.AddNetworkString("PingRandomatBegin")
util.AddNetworkString("PingRandomatPressedE")
util.AddNetworkString("PingRandomatEnd")
local pingPositions = {}
local pingEntities = {}

function EVENT:Begin()
    if GetConVar("randomat_ping_spectators"):GetBool() then
        self.Description = "Spectators can also ping!"
    else
        self.Description = nil
    end

    net.Start("PingRandomatBegin")
    net.Broadcast()

    for _, ply in ipairs(player.GetAll()) do
        ply:SetNWBool("PingRandomatCooldown", false)
    end

    local globalPingCooldown = false

    self:AddHook("PlayerButtonDown", function(ply, button)
        if (not GetConVar("randomat_ping_spectators"):GetBool()) and (ply:IsSpec() or not ply:Alive()) then return end

        if button == KEY_E and (not ply:GetNWBool("PingRandomatCooldown")) and (not globalPingCooldown) then
            local eyeTraceData = ply:GetEyeTrace()
            local pos = eyeTraceData.HitPos
            local ent = eyeTraceData.Entity
            net.Start("PingRandomatPressedE")
            net.WriteVector(pos)
            net.WriteEntity(ent)
            net.WriteUInt(GetConVar("randomat_ping_cooldown"):GetInt(), 8)
            net.WriteBool(GetConVar("randomat_ping_sound"):GetBool())
            net.Broadcast()
            ply:SetNWBool("PingRandomatCooldown", true)

            if not globalPingCooldown then
                globalPingCooldown = true

                timer.Simple(GetConVar("randomat_ping_global_cooldown"):GetInt(), function()
                    globalPingCooldown = false
                end)
            end

            if IsValid(ent) and ent ~= game.GetWorld() then
                table.insert(pingEntities, ent)
            else
                table.insert(pingPositions, pos)
            end

            timer.Simple(GetConVar("randomat_ping_cooldown"):GetInt(), function()
                ply:SetNWBool("PingRandomatCooldown", false)

                if IsValid(ent) and ent ~= game.GetWorld() then
                    table.RemoveByValue(pingEntities, ent)
                else
                    table.RemoveByValue(pingPositions, pos)
                end
            end)
        end
    end)

    self:AddHook("PostPlayerDeath", function(ply)
        if not GetConVar("randomat_ping_spectators"):GetBool() then return end
        SpectatorRandomatAlert(ply, EVENT)
    end)

    -- Forces the area around pings to load so they can always be seen through walls
    -- Copied some optimisations from the randomat base
    self:AddHook("SetupPlayerVisibility", function(ply, _)
        if ply.ShouldBypassCulling and not ply:ShouldBypassCulling() then return end

        for _, pos in ipairs(pingPositions) do
            if ply:TestPVS(pos) then continue end

            if not ply.IsOnScreen or ply:IsOnScreen(pos) then
                AddOriginToPVS(pos)
            end
        end

        for _, ent in ipairs(pingEntities) do
            local pos = ent:GetPos()
            if ply:TestPVS(pos) then continue end

            if not ply.IsOnScreen or ply:IsOnScreen(pos) then
                AddOriginToPVS(pos)
            end
        end
    end)
end

function EVENT:End()
    net.Start("PingRandomatEnd")
    net.Broadcast()
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"cooldown", "global_cooldown"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)
            convar:Revert()

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    local checks = {}

    for _, v in pairs({"spectators"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks
end

Randomat:register(EVENT)