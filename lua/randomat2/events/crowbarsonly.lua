local EVENT = {}
EVENT.Title = "Crowbars Only!"
EVENT.Description = "Can only use, or be damaged by, a buffed crowbar"
EVENT.id = "crowbarsonly"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
local crowbarPushForce

function EVENT:Begin()
    -- Remove all non-buyable weapons
    for _, ent in pairs(ents.GetAll()) do
        if (ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE) and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    -- If someone takes damage from something that's not a crowbar, negate it
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        -- If we make people immune to damage from the barnacle, the last players alive could get stuck, so also let barnacle damage through
        if IsPlayer(ent) and not dmginfo:IsDamageType(DMG_CLUB) and IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() ~= "npc_barnacle" then return true end
    end)

    -- For all alive players,
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:SetFOV(0, 0.2)

            -- If someone is a killer, give them the killer's special crowbar
            if ply:GetRole() == ROLE_KILLER then
                ply:Give("weapon_kil_crowbar")
                ply:SelectWeapon("weapon_kil_crowbar")
            else
                -- Else, give a normal crowbar
                ply:Give("weapon_zm_improvised")
                ply:SelectWeapon("weapon_zm_improvised")
            end
        end)
    end

    -- Buff the crowbar
    crowbarPushForce = GetConVar("ttt_crowbar_pushforce"):GetFloat()
    RunConsoleCommand("ttt_crowbar_pushforce", 20 * GetConVar("ttt_crowbar_pushforce"):GetFloat())

    for i, ply in ipairs(player.GetAll()) do
        local crowbar = ply:GetWeapon("weapon_zm_improvised")

        if IsValid(crowbar) == false then
            crowbar = ply:GetWeapon("weapon_kil_crowbar")
        end

        if IsValid(crowbar) then
            crowbar.Primary.Damage = crowbar.Primary.Damage * 2.5
        end
    end
end

function EVENT:End()
    if crowbarPushForce then
        RunConsoleCommand("ttt_crowbar_pushforce", crowbarPushForce)
    end
end

Randomat:register(EVENT)