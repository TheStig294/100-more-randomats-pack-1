local EVENT = {}
EVENT.Title = "Contagious Morality"
EVENT.Description = "Killing others respawns them with your role"
EVENT.id = "contagiousmorality"

-- Used in removecorpse
local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

-- Used to remove the corpse of someone killed by another player
local function removecorpse(corpse)
    CORPSE.SetFound(corpse, false)

    if string.find(corpse:GetModel(), "zm_", 6, true) then
        player.GetByUniqueID(corpse.uqid):SetNWBool("body_found", false)
        corpse:Remove()
        SendFullStateUpdate()
    elseif corpse.player_ragdoll then
        player.GetByUniqueID(corpse.uqid):SetNWBool("body_found", false)
        corpse:Remove()
        SendFullStateUpdate()
    end
end

function EVENT:Begin()
    -- Prevent karma from being taken while this randomat is active
    self:AddHook("TTTKarmaGivePenalty", function(ply, penalty, victim) return true end)

    -- Replace all Jesters with Innocents
    for i, v in ipairs(self:GetPlayers()) do
        if Randomat:IsJesterTeam(v) then
            Randomat:SetRole(v, ROLE_INNOCENT)
        end
    end

    -- Let the end-of-round scoreboard know roles have changed (Else, old roles will be displayed)
    SendFullStateUpdate()

    -- When a player dies,
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        -- If the player didn't suicide, and was killed by another player
        if (attacker.IsPlayer() and attacker ~= ply) then
            -- Respawn player as new role
            ply:ConCommand("ttt_spectator_mode 0")

            timer.Create("respawndelay", 0.1, 0, function()
                local corpse = findcorpse(ply) -- run the normal respawn code now
                ply:SpawnForRound(true)
                ply:SetRole(attacker:GetRole()) -- Give player role of their attacker
                ply:SetHealth(100) -- Return to full health

                -- Give/take credits if needed
                timer.Simple(0.5, function()
                    ply:SetDefaultCredits()
                end)

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

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({}) do
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

    for _, v in pairs({"textbox"}) do
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