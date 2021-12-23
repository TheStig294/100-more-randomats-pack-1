local EVENT = {}
EVENT.Title = "Don't RDM..."
EVENT.Description = "The 1st person to RDM dies instead"
EVENT.id = "dontrdm"

-- Used in removecorpse.
local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

-- Remove corpse, used on the player who got RDM'd
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

local function respawnandkill(victim, attacker)
    -- Only proceed if the player didn't suicide, and the attacker is another player.
    if attacker:IsPlayer() and attacker ~= victim and IsSameTeam(attacker, victim) then
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
                attacker:Kill() -- Kill the attacker
                timer.Remove("respawndelaydontrdm")

                return
            end
        end)
    end
end

function EVENT:Begin()
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        respawnandkill(victim, attacker)
        self:RemoveHook("PlayerDeath")
    end)
end

Randomat:register(EVENT)