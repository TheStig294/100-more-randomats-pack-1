local EVENT = {}
EVENT.Title = "Contagious Morality"
EVENT.Description = "Killing someone respawns them with your role!"
EVENT.id = "contagiousmorality"
EVENT.Type = EVENT_TYPE_RESPAWN

EVENT.Categories = {"gamemode", "largeimpact", "deathtrigger"}

-- Used in removecorpse
local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

-- Used to remove the corpse of someone killed by another player
local function removecorpse(corpse)
    CORPSE.SetFound(corpse, false)

    if string.find(corpse:GetModel(), "zm_", 6, true) or corpse.player_ragdoll then
        player.GetByUniqueID(corpse.uqid):SetNWBool("body_found", false)
        corpse:Remove()
    end
end

function EVENT:Begin()
    -- Prevent karma from being taken while this randomat is active
    self:AddHook("TTTKarmaGivePenalty", function(ply, penalty, victim) return true end)

    -- Replace all Jesters with Innocents
    for i, v in ipairs(self:GetPlayers()) do
        v.ContagiousRespawnCount = 0

        if Randomat:IsJesterTeam(v) then
            self:StripRoleWeapons(v)
            Randomat:SetRole(v, ROLE_INNOCENT)
        end
    end

    -- Let clients know roles have changed (Else, old roles will be displayed)
    SendFullStateUpdate()

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        -- Cap the number of times players can respawn to 10, to prevent infinite loops with other randomat events and whatnot
        if ply.ContagiousRespawnCount and ply.ContagiousRespawnCount >= 10 then return end

        -- If the player didn't suicide, and was killed by another player
        if (attacker.IsPlayer() and attacker ~= ply) then
            -- Respawn player as new role
            ply:ConCommand("ttt_spectator_mode 0")

            timer.Create("respawndelay", 0.1, 0, function()
                -- Run the normal respawn code now
                local corpse = findcorpse(ply)
                ply:SpawnForRound(true)
                ply:SetRole(attacker:GetRole())
                self:StripRoleWeapons(ply)
                ply:SetHealth(100)

                if ply.ContagiousRespawnCount then
                    ply.ContagiousRespawnCount = ply.ContagiousRespawnCount + 1
                else
                    ply.ContagiousRespawnCount = 1
                end

                -- Remove their corpse
                if corpse then
                    ply:SetPos(corpse:GetPos())
                    removecorpse(corpse)
                end

                SendFullStateUpdate()

                -- Once the player is alive, stop running this respawn code
                if ply:Alive() then
                    timer.Remove("respawndelay")

                    return
                end
            end)
        end
    end)
end

-- Prevent this event from triggering at the same time as events that
-- require 1 player to be alive for the round to end or cause repeated deaths
function EVENT:Condition()
    return not (Randomat:IsEventActive("battleroyale") or Randomat:IsEventActive("pistols") or Randomat:IsEventActive("mayhem"))
end

Randomat:register(EVENT)