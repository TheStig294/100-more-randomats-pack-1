local EVENT = {}
EVENT.Title = "Contagious Morality"
EVENT.Description = "Killing others respawns them with your role"
EVENT.id = "contagiousmorality"

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

-- Used in removecorpse
local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

-- Used to remove the corpse of someone killed aby another player.
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
    hook.Add("TTTKarmaGivePenalty", "ContagiousMoralityKarma", function(ply, penalty, victim) return true end)

    -- Replace all Jesters with Innocents
    for i, v in ipairs(player.GetAll()) do
        if v:GetRole() == ROLE_JESTER then
            Randomat:SetRole(v, ROLE_INNOCENT)
        end
    end

    SendFullStateUpdate()

    -- Player Death
    hook.Add("DoPlayerDeath", "RandomatContagiousMorality", function(ply, attacker, dmg)
        -- If the player didn't suicide, and was killed by another player
        if (attacker.IsPlayer() and attacker ~= ply) then
            -- Respawn player as new role
            ply:ConCommand("ttt_spectator_mode 0")

            timer.Create("respawndelay", 0.1, 0, function()
                local corpse = findcorpse(ply) -- run the normal respawn code now
                ply:SpawnForRound(true)
                ply:SetRole(attacker:GetRole()) -- Give player role of their attacker
                ply:SetHealth(100) -- Return to full health

                timer.Simple(0.5, function()
                    ply:SetDefaultCredits()
                end)

                -- Remove ther corpse
                if corpse then
                    ply:SetPos(corpse:GetPos())
                    removecorpse(corpse)
                end

                SendFullStateUpdate()

                if ply:Alive() then
                    timer.Destroy("respawndelay")

                    return
                end
            end)
        end
    end)
end

function EVENT:End()
    -- Clean up hooks
    hook.Remove("DoPlayerDeath", "RandomatContagiousMorality")
    hook.Remove("TTTKarmaGivePenalty", "ContagiousMoralityKarma")
end

Randomat:register(EVENT)