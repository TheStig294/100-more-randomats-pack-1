local EVENT = {}
EVENT.Title = "I'm The Captain Now."
EVENT.Description = "When a detective kills an innocent, the innocent becomes the detective, and the old detective dies."
EVENT.id = "captain"

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

-- Used in removecorpse.
local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

-- Remove corpse, used on the player the detective kills.
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

local function checkTeam(ply)
    if Randomat:IsInnocentTeam(ply, false) then
        return ROLE_INNOCENT
    else
        return ROLE_TRAITOR
    end
end

function EVENT:Begin()
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        -- Only proceed if the player didn't suicide, and the attacker is another player.
        if (attacker.IsPlayer() and attacker ~= victim) then
            if attacker:GetRole() == ROLE_DETECTIVE and checkTeam(victim) == ROLE_INNOCENT then
                attacker:Kill() -- Kill the detective

                timer.Create("respawndelay", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the new detective elsewhere
                    victim:SpawnForRound(true)
                    victim:SetRole(ROLE_DETECTIVE)
                    victim:SetHealth(100)

                    timer.Simple(0.5, function()
                        attacker:SetDefaultCredits()
                        victim:SetDefaultCredits()
                    end)

                    -- Remove his corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    SendFullStateUpdate()

                    if victim:Alive() then
                        timer.Destroy("respawndelay")

                        return
                    end
                end)
            end
        end
    end)

    self:AddHook("PlayerSilentDeath", function(victim, inflictor, attacker)
        -- Only proceed if the player didn't suicide, and the attacker is another player.
        if (attacker.IsPlayer() and attacker ~= victim) then
            if attacker:GetRole() == ROLE_DETECTIVE and checkTeam(victim) == ROLE_INNOCENT then
                attacker:Kill() -- Kill the detective

                timer.Create("respawndelay", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the new detective elsewhere
                    victim:SpawnForRound(true)
                    victim:SetRole(ROLE_DETECTIVE)
                    victim:SetHealth(100)

                    timer.Simple(0.5, function()
                        attacker:SetDefaultCredits()
                        victim:SetDefaultCredits()
                    end)

                    -- Remove his corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    SendFullStateUpdate()

                    if victim:Alive() then
                        timer.Destroy("respawndelay")

                        return
                    end
                end)
            end
        end
    end)
end

function EVENT:End()
    hook.Remove("DoPlayerDeath", "RandomatCaptain")
end

Randomat:register(EVENT)