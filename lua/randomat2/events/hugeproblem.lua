local EVENT = {}
EVENT.Title = "Huge Problem"
EVENT.Description = "Infinite ammo huge!"
EVENT.id = "hugeproblem"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"item", "largeimpact", "biased_traitor", "biased"}

function EVENT:Begin()
    -- Remove all auto-spawned weapons, but not grenades
    for _, ent in pairs(ents.GetAll()) do
        if (ent.Base == "weapon_tttbase" or ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY) and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    -- Giving everyone a huge
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            for _, wep in pairs(ply:GetWeapons()) do
                if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
                    ply:StripWeapon(wep:GetClass())
                end
            end

            ply:SetFOV(0, 0.2)
            local wep1 = ply:Give("weapon_zm_sledge")
            ply:SelectWeapon(wep1)
            wep1.AllowDrop = false
        end)
    end

    -- 1 second delay to give the infinite ammo hook a chance to see players are now holding the huge
    timer.Simple(1, function()
        self:AddHook("Think", function()
            for _, v in pairs(self:GetAlivePlayers()) do
                if IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() == "weapon_zm_sledge" then
                    -- Refill their weapon's ammo clip
                    v:GetActiveWeapon():SetClip1(v:GetActiveWeapon().Primary.ClipSize)
                end
            end
        end)

        -- Gives players that respawn a H.U.G.E. again
        self:AddHook("PlayerSpawn", function(ply)
            ply:Give("weapon_zm_sledge")
            ply:SelectWeapon("weapon_zm_sledge")
        end)
    end)
end

Randomat:register(EVENT)