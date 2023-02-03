local EVENT = {}

CreateConVar("randomat_chickens_hp", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Player max HP", 1, 100)

CreateConVar("randomat_chickens_sc", 0.25, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Multiplier players are shrunk by", 0.1, 1)

CreateConVar("randomat_chickens_sp", 0.75, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Player movement speed multiplier", 0.1, 1)

EVENT.Title = "BAWK!"
EVENT.Description = "Transforms everyone into chickens!"
EVENT.id = "chickens"

EVENT.Categories = {"fun", "largeimpact", "biased_traitor", "biased"}

local sndTabIdle = {"chickens/idle1.mp3", "chickens/idle2.mp3", "chickens/idle3.mp3", "chickens/alert.mp3"}

local sndTabPain = {"chickens/pain1.mp3", "chickens/pain2.mp3", "chickens/pain3.mp3"}

local maxHealth = {}

function EVENT:RemoveBodyDependentRole(ply)
    if IsBodyDependentRole(ply) then
        self:StripRoleWeapons(ply)
        SetToBasicRole(ply)
    end
end

function EVENT:Begin()
    local hp = GetConVar("randomat_chickens_hp"):GetInt()
    local sc = GetConVar("randomat_chickens_sc"):GetFloat()
    local sp = GetConVar("randomat_chickens_sp"):GetFloat()
    maxHealth = {}

    for k, ply in pairs(self:GetAlivePlayers()) do
        ForceSetPlayermodel(ply, "models/xtra_randos/chicken/chicken3.mdl")
        maxHealth[ply] = ply:GetMaxHealth()

        if hp < ply:Health() then
            ply:SetHealth(hp)
        end

        if hp < ply:GetMaxHealth() then
            ply:SetMaxHealth(hp)
        end

        self:RemoveBodyDependentRole(ply)

        timer.Simple(2, function()
            self:RemoveBodyDependentRole(ply)
        end)
    end

    SendFullStateUpdate()

    self:AddHook("Think", function()
        for k, ply in pairs(self:GetAlivePlayers()) do
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

    -- Scales the player speed on clients
    for k, ply in pairs(player.GetAll()) do
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
        sound.Play("chickens/bkawk.mp3", ply:GetShootPos(), 90, 100, 1)
    end)

    -- Plays random idle chicken sounds
    timer.Create("RdmtChickenIdleSounds", 5, 0, function()
        for i, ply in pairs(self:GetAlivePlayers()) do
            timer.Simple(math.random(1, 4), function()
                ply:EmitSound(sndTabIdle[math.random(1, #sndTabIdle)], 100, 100)
            end)
        end
    end)

    -- Sets a player's model to a chicken and set health if they respawn
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            ForceSetPlayermodel(ply, "models/xtra_randos/chicken/chicken3.mdl")

            if hp < ply:Health() then
                ply:SetHealth(hp)
            end

            if hp < ply:GetMaxHealth() then
                ply:SetMaxHealth(hp)
            end
        end)
    end)
end

function EVENT:End()
    ForceResetAllPlayermodels()
    timer.Remove("RdmtChickenIdleSounds")
    timer.Remove("RdmtChickenHp")
    -- Reset the player speed on the client
    net.Start("RdmtRemoveSpeedMultiplier")
    net.WriteString("RdmtChickensSpeed")
    net.Broadcast()

    -- Reset all players
    for k, ply in pairs(player.GetAll()) do
        -- Resetting player size, hitbox, and ability to climb stairs...
        ply:SetModelScale(1, 0)
        ply:ResetHull()
        ply:SetStepSize(18)

        if maxHealth[ply] then
            ply:SetMaxHealth(maxHealth[ply])
            ply:SetHealth(maxHealth[ply])
        end
    end
end

-- Checking if someone is a body dependent role and if it isn't at the start of the round, prevent the event from running
function EVENT:Condition()
    local bodyDependentRoleExists = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if IsBodyDependentRole(ply) then
            bodyDependentRoleExists = true
            break
        end
    end

    return Randomat:GetRoundCompletePercent() < 5 or not bodyDependentRoleExists
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