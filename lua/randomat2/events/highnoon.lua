local EVENT = {}
EVENT.Title = "It's high noon..."
EVENT.Description = "Time for innocents and traitors to duel!"
EVENT.id = "highnoon"

EVENT.Type = {EVENT_TYPE_WEAPON_OVERRIDE, EVENT_TYPE_MUSIC}

EVENT.Categories = {"largeimpact", "item", "rolechange"}

util.AddNetworkString("HighnoonBeginEvent")
util.AddNetworkString("HighnoonEndEvent")

local musicConvar = CreateConVar("randomat_highnoon_music", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Play music during this event", 0, 1)

local eventTriggered

function EVENT:Begin()
    eventTriggered = true

    -- Remove all weapons on players and the ground that take up the pistol slot
    for _, ent in pairs(ents.GetAll()) do
        if (ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY) and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    for i, ply in ipairs(self:GetAlivePlayers()) do
        -- Transform all jesters/independents to innocents so we know there can only be an innocent or traitor win
        if Randomat:IsJesterTeam(ply) or Randomat:IsIndependentTeam(ply) then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
        end

        timer.Simple(0.1, function()
            ply:SetFOV(0, 0.2)
            ply:Give("weapon_ttt_duel_revolver_randomat")
            ply:SelectWeapon("weapon_ttt_duel_revolver_randomat")
        end)
    end

    SendFullStateUpdate()

    -- Disable round end sounds and 'Ending Flair' event so ending music can play
    if musicConvar:GetBool() then
        DisableRoundEndSounds()
    end

    net.Start("HighnoonBeginEvent")
    net.WriteBool(GetConVar("randomat_highnoon_music"):GetBool())
    net.Broadcast()

    -- Gives respawning players a revolver
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            ply:Give("weapon_ttt_duel_revolver_randomat")
            ply:SelectWeapon("weapon_ttt_duel_revolver_randomat")
        end)
    end)

    -- Fix being able to shoot a player that walks into a lead shot by the duel revolver
    self:AddHook("EntityTakeDamage", function(target, dmg)
        if not IsPlayer(target) then return end
        local attacker = dmg:GetAttacker()
        if not IsPlayer(attacker) then return end
        local inflictor = attacker:GetActiveWeapon()

        if IsValid(inflictor) and inflictor:GetClass() == "weapon_ttt_duel_revolver_randomat" then
            local duelAttacker = target:GetNWEntity("HighNoonDuellingPlayer")
            local duelTarget = attacker:GetNWEntity("HighNoonDuellingPlayer")
            if not (IsPlayer(duelAttacker) and IsPlayer(duelTarget) and attacker == duelAttacker and target == duelTarget) then return true end
            -- Play a bullet ricochet sound for everyone when someone is shot by the duel revolver
            BroadcastLua("surface.PlaySound(\"highnoon/ricochet" .. math.random(1, 8) .. ".mp3\")")
        end
    end)

    -- Stop a duel if a player dies in the middle of it
    self:AddHook("PostPlayerDeath", function(deadPly)
        deadPly:SetNWEntity("HighNoonDuellingPlayer", NULL)

        for _, ply in ipairs(player.GetAll()) do
            if IsPlayer(ply:GetNWEntity("HighNoonDuellingPlayer")) and ply:GetNWEntity("HighNoonDuellingPlayer") == deadPly then
                ply:SetNWEntity("HighNoonDuellingPlayer", NULL)
            end
        end
    end)
end

function EVENT:End()
    if eventTriggered then
        eventTriggered = false

        -- Remove all duel revolvers from players and the ground
        for _, ent in ipairs(ents.FindByClass("weapon_ttt_duel_revolver_randomat")) do
            ent:Remove()
        end

        net.Start("HighnoonEndEvent")
        net.Broadcast()
    end
end

function EVENT:GetConVars()
    local checkboxes = {}

    for _, v in pairs({"music"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checkboxes, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return {}, checkboxes
end

Randomat:register(EVENT)