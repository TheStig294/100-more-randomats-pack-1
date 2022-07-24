local eventnames = {}
table.insert(eventnames, "It's high noon...")
table.insert(eventnames, "The innocent, the traitors, and the ugly")
table.insert(eventnames, "This town ain't big enough for both of us...")
table.insert(eventnames, "Go ahead... make my day")
table.insert(eventnames, "They say he's the fastest draw in the west...")
table.insert(eventnames, "The quick, and the dead")
local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Western"
EVENT.ExtDescription = "Makes the game look like a western film! Gives everyone a 'Duel Revolver'"
EVENT.id = "western"

EVENT.Type = {EVENT_TYPE_WEAPON_OVERRIDE, EVENT_TYPE_MUSIC}

EVENT.Categories = {"largeimpact", "item", "rolechange"}

util.AddNetworkString("WesternBeginEvent")
util.AddNetworkString("WesternEndEvent")

local musicConvar = CreateConVar("randomat_western_music", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Play music during this event", 0, 1)

local eventTriggered

function EVENT:Begin()
    eventTriggered = true
    -- Picking a random name
    self.Title = table.Random(eventnames)
    Randomat:EventNotifySilent(self.Title)

    -- Remove all weapons on players and the ground that take up the pistol slot
    timer.Simple(0.1, function()
        for _, ent in pairs(ents.GetAll()) do
            if (ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY) and ent.AutoSpawnable then
                ent:Remove()
            end
        end
    end)

    for _, ply in ipairs(self:GetAlivePlayers()) do
        -- Transform all jesters/independents to innocents so we know there can only be an innocent or traitor win
        if Randomat:IsJesterTeam(ply) or Randomat:IsIndependentTeam(ply) then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
        end

        timer.Simple(1, function()
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

    net.Start("WesternBeginEvent")
    net.WriteBool(GetConVar("randomat_western_music"):GetBool())
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
            local duelAttacker = target:GetNWEntity("WesternDuellingPlayer")
            local duelTarget = attacker:GetNWEntity("WesternDuellingPlayer")
            if not (IsPlayer(duelAttacker) and IsPlayer(duelTarget) and attacker == duelAttacker and target == duelTarget) then return true end
            -- Play a bullet ricochet sound for everyone when someone is shot by the duel revolver
            BroadcastLua("surface.PlaySound(\"western/ricochet" .. math.random(1, 6) .. ".mp3\")")
        end
    end)

    -- Stop a duel if a player dies in the middle of it
    self:AddHook("PostPlayerDeath", function(deadPly)
        deadPly:SetNWEntity("WesternDuellingPlayer", NULL)
        deadPly.DuelOpponent = nil

        for _, ply in ipairs(player.GetAll()) do
            if IsPlayer(ply:GetNWEntity("WesternDuellingPlayer")) and ply:GetNWEntity("WesternDuellingPlayer") == deadPly then
                ply:SetNWEntity("WesternDuellingPlayer", NULL)
                ply.DuelOpponent = nil
            end
        end

        -- Remove the duel halo when a player dies
        net.Start("DuelRevolverRemoveHalo")
        net.Send(deadPly)
    end)

    -- Force players to holster if the have the holstered weapon, and they are frozen, being about to duel
    self:AddHook("PlayerPostThink", function(ply)
        if ply:IsFrozen() and ply:HasWeapon("weapon_ttt_unarmed") then
            ply:SelectWeapon("weapon_ttt_unarmed")
        end
    end)
end

function EVENT:End()
    if eventTriggered then
        eventTriggered = false
        EVENT.Title = ""

        -- Remove all duel revolvers from players and the ground
        for _, ent in ipairs(ents.FindByClass("weapon_ttt_duel_revolver_randomat")) do
            ent:Remove()
        end

        net.Start("WesternEndEvent")
        net.Broadcast()
        net.Start("DuelRevolverRemoveHalo")
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