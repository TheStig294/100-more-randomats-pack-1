local EVENT = {}
EVENT.Title = "Gun Game 2.0"
EVENT.Description = "Change weapons when someone dies"
EVENT.id = "gungame2"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

local function GiveNewWeapon(ply, weps)
    -- See if they are currently holding a weapon that will be swapped
    local holdingFloorWeapon = false

    if ply:GetActiveWeapon().Kind == WEAPON_HEAVY or ply:GetActiveWeapon().Kind == WEAPON_PISTOL then
        holdingFloorWeapon = true
    end

    -- Remove their pistol and main gun
    for _, wep in ipairs(ply:GetWeapons()) do
        if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
            ply:StripWeapon(wep.ClassName)
        end
    end

    -- Give them a random weapon
    local wepGiven = table.Random(weps)
    local wep = ply:Give(wepGiven.ClassName)
    wep.AllowDrop = false
    -- Reset FOV to unscope
    ply:SetFOV(0, 0.2)

    -- If they were holding a removed weapon, force them to select the new one
    if holdingFloorWeapon then
        ply:SelectWeapon(wepGiven.ClassName)
    end
end

function EVENT:Begin()
    -- Remove all weapons from the ground, except grenades
    for _, ent in ipairs(ents.GetAll()) do
        if ent.AutoSpawnable and (ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_PISTOL) then
            ent:Remove()
        end
    end

    -- Add all floor weapons to a table to choose from
    local weps = {}

    -- But don't add weapons like the rocket thruster that don't deal damage
    for _, wep in ipairs(weapons.GetList()) do
        if wep.AutoSpawnable and (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) and wep.Primary.Damage > 0 then
            table.insert(weps, wep)
        end
    end

    -- Give everyone their initial weapon
    for _, v in ipairs(self:GetAlivePlayers()) do
        GiveNewWeapon(v, weps)
    end

    -- Give everyone a new weapon when someone dies
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        timer.Simple(0.1, function()
            for _, v in ipairs(player.GetAll()) do
                GiveNewWeapon(v, weps)
            end
        end)
    end)

    -- Give a new weapon when someone respawns
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(0.1, function()
            GiveNewWeapon(ply, weps)
        end)
    end)
end

Randomat:register(EVENT)