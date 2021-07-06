local EVENT = {}
EVENT.Title = "Gun Game 2.0"
EVENT.Description = "Change weapons when someone dies"
EVENT.id = "gungame2"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:Begin()
    -- Remove all weapons from the ground, except grenades
    for _, ent in ipairs(ents.GetAll()) do
        if ent.AutoSpawnable and (ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_PISTOL) then
            ent:Remove()
        end
    end

    -- Add all floor weapons to a table to choose from
    local weps = {}

    for _, wep in ipairs(weapons.GetList()) do
        if wep.AutoSpawnable and (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) then
            table.insert(weps, wep)
        end
    end

    -- Give everyone their first weapon
    for _, v in ipairs(player.GetAll()) do
        -- See if they are currently holding a weapon that will be swapped
        local ac = false

        if v:GetActiveWeapon().Kind == WEAPON_HEAVY or v:GetActiveWeapon().Kind == WEAPON_PISTOL then
            ac = true
        end

        -- Remove their pistol and main gun
        for _, wep in ipairs(v:GetWeapons()) do
            if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
                v:StripWeapon(wep.ClassName)
            end
        end

        -- Give them a random weapon
        local wepGiven = table.Random(weps)
        v:Give(wepGiven.ClassName)
        -- Reset FOV to unscope
        v:SetFOV(0, 0.2)

        -- If they were holding a removed weapon, force them to select the new one
        if ac then
            v:SelectWeapon(wepGiven.ClassName)
        end
    end

    -- Give everyone a new weapon when someone dies
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        timer.Simple(0.1, function()
            for _, v in ipairs(player.GetAll()) do
                -- See if they are currently holding a weapon that will be swapped
                local ac = false

                if v:GetActiveWeapon().Kind == WEAPON_HEAVY or v:GetActiveWeapon().Kind == WEAPON_PISTOL then
                    ac = true
                end

                -- Remove their pistol and main gun
                for _, wep in ipairs(v:GetWeapons()) do
                    if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
                        v:StripWeapon(wep.ClassName)
                    end
                end

                -- Give them a random weapon
                local wepGiven = table.Random(weps)
                v:Give(wepGiven.ClassName)
                -- Reset FOV to unscope
                v:SetFOV(0, 0.2)

                -- If they were holding a removed weapon, force them to select the new one
                if ac then
                    v:SelectWeapon(wepGiven.ClassName)
                end
            end
        end)
    end)
end

Randomat:register(EVENT)