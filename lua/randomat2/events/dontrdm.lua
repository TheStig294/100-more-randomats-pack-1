local EVENT = {}
EVENT.Title = "Don't RDM..."
EVENT.Description = "The 1st person to RDM dies instead"
EVENT.id = "dontrdm"

EVENT.Categories = {"biased_innocent", "biased", "deathtrigger", "moderateimpact"}

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

function EVENT:Begin()
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        -- Only proceed if the player didn't suicide, and the attacker is another player.
        if attacker:IsPlayer() and attacker ~= victim and IsSameTeam(attacker, victim) then
            self:RemoveHook("PlayerDeath")

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
                    attacker:PrintMessage(HUD_PRINTCENTER, "You RDMed!")
                    attacker:PrintMessage(HUD_PRINTTALK, "'" .. self.Title .. "' is active!\n" .. self.Description)

                    return
                end
            end)
        end
    end)

    -- Banning the defib from being used during this randomat
    local defibClassnames = {"weapon_detective_defib", "weapon_vadim_defib", "weapon_ttt_defib"}

    -- Removing held defibs
    for _, ply in ipairs(self:GetAlivePlayers()) do
        for _, classname in ipairs(defibClassnames) do
            if ply:HasWeapon(classname) then
                ply:StripWeapon(classname)
                ply:AddCredits(1)

                timer.Simple(1, function()
                    ply:ChatPrint("Defibrillators are disabled while '" .. Randomat:GetEventTitle(EVENT) .. "' is active!\nYour credit has been refunded.")
                end)
            end
        end
    end

    -- Preventing defibs from being bought
    self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
        if IsPlayer(ply) and Randomat:IsInnocentTeam(ply) and not is_item then
            for _, classname in ipairs(defibClassnames) do
                if id == classname then
                    timer.Simple(1, function()
                        ply:ChatPrint("Defibrillators are disabled while '" .. Randomat:GetEventTitle(EVENT) .. "' is active!")
                    end)

                    return false
                end
            end
        end
    end)
end

Randomat:register(EVENT)