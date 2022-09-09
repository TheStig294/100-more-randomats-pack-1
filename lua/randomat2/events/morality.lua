local EVENT = {}

CreateConVar("randomat_morality_lives", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Number of lives players have", 1, 15)

EVENT.Title = "Contagious Morality"
EVENT.Description = "Killing someone respawns them with your role," .. " you get " .. GetConVar("randomat_morality_lives"):GetInt() .. " lives!"
EVENT.id = "morality"
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
    local lives = GetConVar("randomat_morality_lives"):GetInt()

    if lives == 1 then
        self.Description = "Killing someone respawns them with your role, you get 1 life!"
    else
        self.Description = "Killing someone respawns them with your role, you get " .. lives .. " lives!"
    end

    -- Prevent karma from being taken while this randomat is active
    self:AddHook("TTTKarmaGivePenalty", function(ply, penalty, victim) return true end)

    -- Replace all Jesters with Innocents
    for i, v in ipairs(self:GetPlayers()) do
        v.MoralityRespawnCount = 0

        if Randomat:IsJesterTeam(v) then
            self:StripRoleWeapons(v)
            Randomat:SetRole(v, ROLE_INNOCENT)
        end
    end

    -- Let clients know roles have changed (Else, old roles will be displayed)
    SendFullStateUpdate()

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        -- Cap the number of times players can respawn, to prevent infinite loops with other randomat events and whatnot
        if ply.MoralityRespawnCount and ply.MoralityRespawnCount >= GetConVar("randomat_morality_lives"):GetInt() then
            ply:PrintMessage(HUD_PRINTCENTER, "Out of lives!")

            return
        end

        -- If the player didn't suicide, and was killed by another player
        if (attacker.IsPlayer() and attacker ~= ply) then
            -- Respawn player as new role
            ply:ConCommand("ttt_spectator_mode 0")

            timer.Create("RandomatMoralityRespawnDelay", 0.1, 0, function()
                -- Run the normal respawn code now
                ply:SpawnForRound(true)
                ply:SetRole(attacker:GetRole())
                self:StripRoleWeapons(ply)
                ply:SetHealth(100)

                if ply.MoralityRespawnCount then
                    ply.MoralityRespawnCount = ply.MoralityRespawnCount + 1
                else
                    ply.MoralityRespawnCount = 1
                end

                local livesLeft = GetConVar("randomat_morality_lives"):GetInt() - ply.MoralityRespawnCount

                if livesLeft == 1 then
                    ply:PrintMessage(HUD_PRINTCENTER, "You have 1 life left!")
                elseif livesLeft == 0 then
                    ply:PrintMessage(HUD_PRINTCENTER, "You have no lives left!!")
                else
                    ply:PrintMessage(HUD_PRINTCENTER, "You have " .. livesLeft .. " lives left!")
                end

                -- Remove their corpse
                local corpse = findcorpse(ply)

                if corpse then
                    ply:SetPos(corpse:GetPos())
                    removecorpse(corpse)
                end

                SendFullStateUpdate()

                -- Once the player is alive, stop running this respawn code
                if ply:Alive() then
                    timer.Remove("RandomatMoralityRespawnDelay")

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

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"lives"}) do
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