local EVENT = {}
EVENT.Title = "I'm The Captain Now."
EVENT.Description = "The 1st time a detective RDMs, they die instead, and the victim becomes a detective"
EVENT.id = "captain"
EVENT.Type = EVENT_TYPE_RESPAWN

EVENT.Categories = {"biased_innocent", "biased", "rolechange", "deathtrigger", "smallimpact"}

-- Used in removecorpse.
local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

-- Remove corpse, used on the player the detective kills.
local function removecorpse(corpse)
    CORPSE.SetFound(corpse, false)

    if string.find(corpse:GetModel(), "zm_", 6, true) or corpse.player_ragdoll then
        player.GetByUniqueID(corpse.uqid):SetNWBool("body_found", false)
        corpse:Remove()
    end
end

function EVENT:Begin()
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        -- Only proceed if the player didn't suicide, and the attacker is another player.
        -- If the attacker was a detective and the victim was any kind of innocent,
        if attacker.IsPlayer() and attacker ~= victim and Randomat:IsGoodDetectiveLike(attacker) and Randomat:IsInnocentTeam(victim, false) then
            self:RemoveHook("PlayerDeath")
            local role = attacker:GetRole()
            local credits = attacker:GetCredits()
            local attackerWeapons = {}

            for _, weapon in ipairs(attacker:GetWeapons()) do
                table.insert(attackerWeapons, weapon:GetClass())
            end

            attacker:StripWeapons()
            attacker:SetCredits(0)
            attacker:Kill() -- Kill the detective,
            attacker:PrintMessage(HUD_PRINTCENTER, "You RDMed!")
            attacker:PrintMessage(HUD_PRINTTALK, "'" .. self.Title .. "' is active!\n" .. self.Description)

            --Repeatedly try to respawn the victim
            timer.Create("respawndelay", 0.1, 0, function()
                local corpse = findcorpse(victim) -- run the normal respawn code now
                -- Respawn the new detective elsewhere
                victim:SpawnForRound(true)
                victim:SetRole(role)
                victim:SetHealth(100)

                -- Remove his corpse
                if corpse then
                    victim:SetPos(corpse:GetPos())
                    removecorpse(corpse)
                end

                SendFullStateUpdate()

                --Stop trying to spawn the victim once they are alive
                if victim:Alive() then
                    timer.Remove("respawndelay")
                    victim:StripWeapons()

                    for _, weapon in ipairs(attackerWeapons) do
                        victim:Give(weapon)
                    end

                    victim:SetCredits(credits)
                    victim:PrintMessage(HUD_PRINTCENTER, "You were killed by a detective!")
                    victim:PrintMessage(HUD_PRINTTALK, "'" .. self.Title .. "' is active!\n" .. self.Description)

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

function EVENT:Condition()
    for i, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsGoodDetectiveLike(ply) then return true end
    end

    return false
end

Randomat:register(EVENT)