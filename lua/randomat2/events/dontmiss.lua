local EVENT = {}
CreateConVar("randomat_dontmiss_damage", 5, FCVAR_NONE, "Damage from missing", 1, 100)
CreateConVar("randomat_dontmiss_heal", 5, FCVAR_NONE, "Healing from hitting", 1, 100)
EVENT.Title = "Don't Miss..."
EVENT.Description = "Take damage for missing shots, gain health for hitting"
EVENT.id = "dontmiss"

EVENT.Categories = {"moderateimpact"}

function EVENT:Begin()
    -- Create variables to keep track of whether the player has shot a
    -- bullet, and whether they have hit a player. This is used between
    -- both hooks with a slight delay to determine whether it was a hit
    -- or not, and whether health should be added or taken away.
    for i, ply in pairs(self:GetPlayers()) do
        ply.shotBullet = false
        ply.hitShotBullet = false
    end

    -- Allow all players to have more health.
    for i, ply in pairs(self:GetPlayers()) do
        ply:SetMaxHealth(ply:GetMaxHealth() + 100)
    end

    self:AddHook("PlayerSpawn", function(ply, transition)
        timer.Simple(0.1, function()
            ply:SetMaxHealth(ply:Health() + 100)
        end)
    end)

    -- Add hook for when a player fires.
    self:AddHook("EntityFireBullets", function(ent, data)
        ent.shotBullet = true

        -- Start timer to check if the bullet hit.
        timer.Simple(0.1, function()
            if ent.hitShotBullet then
                ent.hitShotBullet = false

                -- They hit
                if (ent:Health() + 5) <= ent:GetMaxHealth() then
                    ent:SetHealth(ent:Health() + 5)
                end
            else
                -- They missed
                ent:TakeDamage(5)
            end
        end)
    end)

    self:AddHook("PostEntityTakeDamage", function(ent, damage, took)
        -- Entity Hit
        if took then
            damage:GetAttacker().hitShotBullet = true
            damage:GetAttacker().shotBullet = false
        end
    end)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"damage", "heal"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText(), -- The description of the ConVar
                min = convar:GetMin(), -- The minimum value for this slider-based ConVar
                max = convar:GetMax(), -- The maximum value for this slider-based ConVar
                dcm = 0 -- The number of decimal points to support in this slider-based ConVar
                
            })
        end
    end

    local checks = {}

    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText() -- The description of the ConVar
                
            })
        end
    end

    local textboxes = {}

    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(textboxes, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText() -- The description of the ConVar
                
            })
        end
    end

    return sliders, checks, textboxes
end

Randomat:register(EVENT)