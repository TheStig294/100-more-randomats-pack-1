local EVENT = {}
EVENT.Title = "I'm The Captain Now."
EVENT.Description = "When a detective kills an innocent, the innocent becomes the detective, and the old detective dies."
EVENT.id = "captain"

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

function EVENT:Begin()
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        -- Only proceed if the player didn't suicide, and the attacker is another player.
        if attacker.IsPlayer() and attacker ~= victim then
            -- If the attacker was a detective and the victim was any kind of innocent,
            if attacker:GetRole() == ROLE_DETECTIVE and Randomat:IsInnocentTeam(victim, false) then
                attacker:Kill() -- Kill the detective,

                --Repeatedly try to respawn the victim
                timer.Create("respawndelay", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the new detective elsewhere
                    victim:SpawnForRound(true)
                    victim:SetRole(ROLE_DETECTIVE)
                    victim:SetHealth(100)

                    --Give the new detective the default amount of detective credits
                    timer.Simple(0.5, function()
                        victim:SetDefaultCredits()
                    end)

                    -- Remove his corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    SendFullStateUpdate()

                    --Stop trying to spawn the victim once they are alive
                    if victim:Alive() then
                        timer.Remove("respawndelay")

                        return
                    end
                end)
            end
        end
    end)

    --Also apply to headshots, else the detective could still freely RDM if they headshot
    self:AddHook("PlayerSilentDeath", function(victim, inflictor, attacker)
        -- Only proceed if the player didn't suicide, and the attacker is another player.
        if attacker.IsPlayer() and attacker ~= victim then
            -- If the attacker was a detective and the victim was any kind of innocent,
            if attacker:GetRole() == ROLE_DETECTIVE and Randomat:IsInnocentTeam(victim, false) then
                attacker:Kill() -- Kill the detective,

                --Repeatedly try to respawn the victim
                timer.Create("respawndelay", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the new detective elsewhere
                    victim:SpawnForRound(true)
                    victim:SetRole(ROLE_DETECTIVE)
                    victim:SetHealth(100)

                    --Give the new detective the default amount of detective credits
                    timer.Simple(0.5, function()
                        victim:SetDefaultCredits()
                    end)

                    -- Remove his corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    SendFullStateUpdate()

                    --Stop trying to spawn the victim once they are alive
                    if victim:Alive() then
                        timer.Remove("respawndelay")

                        return
                    end
                end)
            end
        end
    end)
end

Randomat:register(EVENT)