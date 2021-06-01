AddCSLuaFile()
local EVENT = {}
EVENT.Title = "BAWK!"
EVENT.Description = "Transforms everyone into chickens"
EVENT.id = "chickens"

CreateConVar("randomat_chickens_hp", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Changes the set HP for the event \"BAWK!\"", 1, 100)

local playerModels = {}
local offsets = {}
local offsets_ducked = {}

local sndTabIdle = {"chickens/idle1.wav", "chickens/idle2.wav", "chickens/idle3.wav", "chickens/alert.wav"}

local sndTabPain = {"chickens/pain1.wav", "chickens/pain2.wav", "chickens/pain3.wav"}

function EVENT:Begin()
    for _, ply in pairs(self:GetAlivePlayers()) do
        if not offsets[ply:SteamID64()] then
            offsets[ply:SteamID64()] = ply:GetViewOffset()
        end

        if not offsets_ducked[ply:SteamID64()] then
            offsets_ducked[ply:SteamID64()] = ply:GetViewOffsetDucked()
        end
    end

    playerModels = {}
    local hp = GetConVar("randomat_chickens_hp"):GetFloat()
    local sc = 0.25 --scale factor

    -- Gets all players...
    for k, ply in pairs(player.GetAll()) do
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
                -- Sets their model to chosenModel
                ply:SetModel("models/xtra_randos/chicken/chicken3.mdl")
            end)
        end
    end

    hook.Add("Think", "RdmtChickenThink", function()
        for k, ply in pairs(player.GetAll()) do
            ply:SetStepSize(18 * sc)
            ply:SetModelScale(1 * sc, 0)
            ply:SetViewOffset(Vector(0, 0, 64) * sc)
            ply:SetViewOffsetDucked(Vector(0, 0, 32) * sc)
            ply:SetHull(Vector(-16, -16, 0) * sc, Vector(16, 16, 72) * sc)
            ply:SetHullDuck(Vector(-16, -16, 0) * sc, Vector(16, 16, 36) * sc)
        end
    end)

    for k, ply in pairs(player.GetAll()) do
        local oldmax = ply:GetMaxHealth()
        ply:SetMaxHealth(hp)
        ply:SetHealth(math.Clamp(hp * ply:Health() / oldmax, 1, hp))
        hook.Add("TTTPlayerSpeed", "RdmtChickenMoveSpeed", function() return math.Clamp(ply:GetStepSize() / 9, 0.25, 1) end)
    end

    -- destroy corpse on death
    hook.Add("TTTOnCorpseCreated", "RdmtChickenCorpse", function(corpse)
        corpse:Remove()
    end)

    -- Replace sounds with chicken sounds
    hook.Add("DoPlayerDeath", "RdmtChickenDeathSound", function(ply, attacker, dmginfo)
        dmginfo:SetDamageType(DMG_SLASH) -- slashing damage causes no death sound
        sound.Play("chickens/bkawk.wav", ply:GetShootPos(), 90, 100, 1)
    end)

    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if IsValid(ent) and ent:IsPlayer() then
            ent:EmitSound(sndTabPain[math.random(1, #sndTabPain)], 100, 100)
        end
    end)

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
    for k, ply in pairs(player.GetAll()) do
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

    -- clean up
    hook.Remove("TTTPlayerSpeed", "RdmtChickenMoveSpeed")
    hook.Remove("DoPlayerDeath", "RdmtChickenDeathSound")
    hook.Remove("TTTOnCorpseCreated", "RdmtChickenCorpse")
    hook.Remove("Think", "RdmtChickenThink")
    timer.Remove("RdmtChickenIdleSounds")

    -- resize at the beginning of next round, rather than the end of current
    hook.Add("TTTPrepareRound", "RdmtChickenFix", function()
        for k, ply in pairs(player.GetAll()) do
            local offset = nil

            if offsets[ply:SteamID64()] then
                offset = offsets[ply:SteamID64()]
                offsets[ply:SteamID64()] = nil
            end

            if offset or not ply.ec_ViewChanged then
                ply:SetViewOffset(offset or Vector(0, 0, 64))
            end

            local offset_ducked = nil

            if offsets_ducked[ply:SteamID64()] then
                offset_ducked = offsets_ducked[ply:SteamID64()]
                offsets_ducked[ply:SteamID64()] = nil
            end

            if offset_ducked or not ply.ec_ViewChanged then
                ply:SetViewOffsetDucked(offset_ducked or Vector(0, 0, 28))
            end

            ply:SetModelScale(1, 0)
            ply:ResetHull()
            ply:SetStepSize(18)
        end

        hook.Remove("TTTPrepareRound", "RdmtChickenFix")
    end)
end

function EVENT:GetConVars()
    local sliders = {}
    local convar = GetConVar("randomat_chickens_hp")

    table.insert(sliders, {
        cmd = "hp",
        dsc = convar:GetHelpText(),
        min = convar:GetMin(),
        max = convar:GetMax(),
        dcm = 0
    })

    return sliders, {}, {}
end

if Randomat then
    Randomat:register(EVENT)
end