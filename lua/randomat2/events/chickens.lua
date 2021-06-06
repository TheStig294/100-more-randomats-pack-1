local EVENT = {}
EVENT.Title = "BAWK!"
EVENT.Description = "Transforms everyone into chickens"
EVENT.id = "chickens"

CreateConVar("randomat_chickens_hp", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Player max HP", 1, 100)

CreateConVar("randomat_chickens_sc", 0.25, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Multiplier players are shrunk by", 0.1, 1)

CreateConVar("randomat_chickens_sp", 0.75, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Player movement speed multiplier", 0.1, 1)

local playerModels = {}
local offsets = {}
local offsets_ducked = {}

local sndTabIdle = {"chickens/idle1.wav", "chickens/idle2.wav", "chickens/idle3.wav", "chickens/alert.wav"}

local sndTabPain = {"chickens/pain1.wav", "chickens/pain2.wav", "chickens/pain3.wav"}

function EVENT:Begin()
    playerModels = {}
    local hp = GetConVar("randomat_chickens_hp"):GetInt() -- Player max health
    local sc = GetConVar("randomat_chickens_sc"):GetFloat() -- Player shrinking scale multiplier
    local sp = GetConVar("randomat_chickens_sp"):GetFloat() -- Player player movement speed multiplier

    -- For every living player,
    for _, ply in pairs(self:GetAlivePlayers()) do
        -- If the player's stored viewheight is null, store their viewheight
        if not offsets[ply:SteamID64()] then
            offsets[ply:SteamID64()] = ply:GetViewOffset()
        end

        -- If the player's crouched viewheight is null, store their crouched viewheight
        if not offsets_ducked[ply:SteamID64()] then
            offsets_ducked[ply:SteamID64()] = ply:GetViewOffsetDucked()
        end
    end

    -- Gets all players...
    for k, ply in pairs(self:GetPlayers()) do
        -- if they're alive and not in spectator mode
        if ply:Alive() and not ply:IsSpec() then
            -- and not a bot (bots do not have the following command, so it's unnecessary)
            if (not ply:IsBot()) then
                -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                ply:ConCommand("cl_playermodel_selector_force 0")
            end

            -- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
            timer.Simple(1, function()
                -- Set player number K (in the table) to their respective model
                playerModels[k] = ply:GetModel()
                -- Sets their model to a full-sized chicken playermodel
                -- The chicken playermodel is giant, and is shrunk down to chicken size below
                ply:SetModel("models/xtra_randos/chicken/chicken3.mdl")
            end)
        end
    end

    self:AddHook("Think", function()
        for k, ply in pairs(self:GetPlayers()) do
            -- Decrease height players can automatically step up (i.e. players can't climb stairs)
            ply:SetStepSize(18 * sc)
            -- Shrink playermodel size
            ply:SetModelScale(1 * sc, 0)
            -- Shrink player's camera/view
            ply:SetViewOffset(Vector(0, 0, 64) * sc)
            ply:SetViewOffsetDucked(Vector(0, 0, 32) * sc)
            -- Shrink player hitbox
            ply:SetHull(Vector(-16, -16, 0) * sc, Vector(16, 16, 72) * sc)
            ply:SetHullDuck(Vector(-16, -16, 0) * sc, Vector(16, 16, 36) * sc)
        end
    end)

    for k, ply in pairs(self:GetPlayers()) do
        -- Scale player health down, taking into account damage taken
        local oldmax = ply:GetMaxHealth()
        ply:SetMaxHealth(hp)
        ply:SetHealth(math.Clamp(hp * ply:Health() / oldmax, 1, hp))
        -- Scales the player speed on the client
        net.Start("RdmtSetSpeedMultiplier")
        net.WriteFloat(sp)
        net.WriteString("RdmtChickensSpeed")
        net.Send(ply)
    end

    -- Scales the player speed on the server
    self:AddHook("TTTSpeedMultiplier", function(ply, mults)
        if not ply:Alive() or ply:IsSpec() then return end
        table.insert(mults, sp)
    end)

    -- Destroy corpse on death
    self:AddHook("TTTOnCorpseCreated", function(corpse)
        corpse:Remove()
    end)

    -- Play a random chicken hurt sound when a player is hurt
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if IsValid(ent) and ent:IsPlayer() then
            ent:EmitSound(sndTabPain[math.random(1, #sndTabPain)], 100, 100)
        end
    end)

    -- Play a distinct chicken sound when a player dies
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        dmginfo:SetDamageType(DMG_SLASH) -- Slashing damage causes no death sound, and thus mutes the normal death sound
        sound.Play("chickens/bkawk.wav", ply:GetShootPos(), 90, 100, 1)
    end)

    -- Plays random idle chicken sounds
    timer.Create("RdmtChickenIdleSounds", 5, 0, function()
        for i, ply in pairs(self:GetAlivePlayers()) do
            timer.Simple(math.random(1, 4), function()
                ply:EmitSound(sndTabIdle[math.random(1, #sndTabIdle)], 100, 100)
            end)
        end
    end)
end

function EVENT:End()
    -- loop through all players
    for k, ply in pairs(self:GetPlayers()) do
        -- if the index k in the table playermodels has a model, then...
        if (playerModels[k] ~= nil) then
            -- we set the player v to the playermodel with index k in the table
            -- this should invoke the viewheight script from the models and fix viewoffsets (e.g. Zoey's model) 
            -- this does however first reset their viewmodel in the preparing phase (when they respawn)
            -- might be glitchy with pointshop items that allow you to get a viewoffset
            ply:SetModel(playerModels[k])
        end

        -- we reset the cl_playermodel_selector_force to 1, otherwise TTT will reset their playermodels on a new round start (to default models!)
        ply:ConCommand("cl_playermodel_selector_force 1")
        -- clear the model table to avoid setting wrong models (e.g. disconnected players)
        table.Empty(playerModels)
    end

    -- Remove chicken idle sounds
    timer.Remove("RdmtChickenIdleSounds")
    -- Reset the player speed on the client
    net.Start("RdmtRemoveSpeedMultiplier")
    net.WriteString("RdmtChickensSpeed")
    net.Broadcast()

    -- Resize at the beginning of next round, rather than the end of current round (For some reason, has no effect otherwise)
    for k, ply in pairs(self:GetPlayers()) do
        local offset = nil

        -- Clearing player offset table
        if offsets[ply:SteamID64()] then
            offset = offsets[ply:SteamID64()]
            offsets[ply:SteamID64()] = nil
        end

        -- Resetting player viewheight
        if offset or not ply.ec_ViewChanged then
            ply:SetViewOffset(offset or Vector(0, 0, 64))
        end

        local offset_ducked = nil

        -- Clearing player crouching offset table
        if offsets_ducked[ply:SteamID64()] then
            offset_ducked = offsets_ducked[ply:SteamID64()]
            offsets_ducked[ply:SteamID64()] = nil
        end

        -- Resetting player crouching viewheight
        if offset_ducked or not ply.ec_ViewChanged then
            ply:SetViewOffsetDucked(offset_ducked or Vector(0, 0, 28))
        end

        -- Resetting player size, hitbox, and ability to climb stairs...
        ply:SetModelScale(1, 0)
        ply:ResetHull()
        ply:SetStepSize(18)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"hp"}) do
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

    for _, v in pairs({"sc", "sp"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 2
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)