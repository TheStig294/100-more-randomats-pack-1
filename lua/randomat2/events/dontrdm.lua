local EVENT = {}
EVENT.Title = "Don't RDM..."
EVENT.Description = "If you kill someone on your side, you die instead"
EVENT.id = "dontrdm"

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
        if (attacker.IsPlayer() and attacker ~= victim) then
            if Randomat:IsInnocentTeam(attacker, false) and Randomat:IsInnocentTeam(victim, false) then
                attacker:Kill() -- Kill the attacker

                timer.Create("respawndelaydontrdm", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the victim elsewhere
                    victim:SpawnForRound(true)
                    victim:SetHealth(100)

                    -- Remove the victim's corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    if victim:Alive() then
                        timer.Remove("respawndelaydontrdm")

                        return
                    end
                end)
            elseif Randomat:IsTraitorTeam(attacker) and Randomat:IsTraitorTeam(victim) then
                attacker:Kill() -- Kill the attacker

                timer.Create("respawndelaydontrdm", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the victim elsewhere
                    victim:SpawnForRound(true)
                    victim:SetHealth(100)

                    -- Remove the victim's corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    if victim:Alive() then
                        timer.Remove("respawndelaydontrdm")

                        return
                    end
                end)
            elseif Randomat:IsMonsterTeam(attacker) and Randomat:IsMonsterTeam(victim) then
                attacker:Kill() -- Kill the attacker

                timer.Create("respawndelaydontrdm", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the victim elsewhere
                    victim:SpawnForRound(true)
                    victim:SetHealth(100)

                    -- Remove the victim's corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    if victim:Alive() then
                        timer.Remove("respawndelaydontrdm")

                        return
                    end
                end)
            end
        end
    end)

    self:AddHook("PlayerSilentDeath", function(victim, inflictor, attacker)
        -- Only proceed if the player didn't suicide, and the attacker is another player.
        if (attacker.IsPlayer() and attacker ~= victim) then
            if Randomat:IsInnocentTeam(attacker, false) and Randomat:IsInnocentTeam(victim, false) then
                attacker:Kill() -- Kill the attacker

                timer.Create("respawndelaydontrdm", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the victim elsewhere
                    victim:SpawnForRound(true)
                    victim:SetHealth(100)

                    -- Remove the victim's corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    if victim:Alive() then
                        timer.Remove("respawndelaydontrdm")

                        return
                    end
                end)
            elseif Randomat:IsTraitorTeam(attacker) and Randomat:IsTraitorTeam(victim) then
                attacker:Kill() -- Kill the attacker

                timer.Create("respawndelaydontrdm", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the victim elsewhere
                    victim:SpawnForRound(true)
                    victim:SetHealth(100)

                    -- Remove the victim's corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    if victim:Alive() then
                        timer.Remove("respawndelaydontrdm")

                        return
                    end
                end)
            elseif Randomat:IsMonsterTeam(attacker) and Randomat:IsMonsterTeam(victim) then
                attacker:Kill() -- Kill the attacker

                timer.Create("respawndelaydontrdm", 0.1, 0, function()
                    local corpse = findcorpse(victim) -- run the normal respawn code now
                    -- Respawn the victim elsewhere
                    victim:SpawnForRound(true)
                    victim:SetHealth(100)

                    -- Remove the victim's corpse
                    if corpse then
                        victim:SetPos(corpse:GetPos())
                        removecorpse(corpse)
                    end

                    if victim:Alive() then
                        timer.Remove("respawndelaydontrdm")

                        return
                    end
                end)
            end
        end
    end)
end

Randomat:register(EVENT)