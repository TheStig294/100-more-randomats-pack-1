local EVENT = {}
EVENT.Title = "Gun Game 2.0"
EVENT.Description = "Change weapons when someone dies"
EVENT.id = "gungame2"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"deathtrigger", "biased_innocent", "biased", "largeimpact"}

local weps = {}

local function GiveNewWeapon(ply)
    -- See if they are currently holding a weapon that will be swapped
    local holdingFloorWeapon = false

    if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().Kind and (ply:GetActiveWeapon().Kind == WEAPON_HEAVY or ply:GetActiveWeapon().Kind == WEAPON_PISTOL) then
        holdingFloorWeapon = true
    end

    -- Reset FOV to unscope
    ply:SetFOV(0, 0.2)

    -- Remove their pistol and main gun
    for _, wep in ipairs(ply:GetWeapons()) do
        if IsValid(wep) and wep.Kind and (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) then
            local classname = WEPS.GetClass(wep)

            if classname then
                ply:StripWeapon(classname)
            end
        end
    end

    -- Give them a random weapon
    local wepGiven = weps[math.random(1, #weps)]
    local wep = ply:Give(wepGiven)
    wep.AllowDrop = false

    -- If they were holding a removed weapon, force them to select the new one
    if holdingFloorWeapon then
        ply:SelectWeapon(wepGiven)
    end
end

function EVENT:Begin()
    -- Add all floor weapons to a table to choose from
    -- But don't add weapons like the rocket thruster that don't deal damage
    for _, wep in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(wep)

        if wep.AutoSpawnable and (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) and wep.Primary.Damage > 0 and classname then
            table.insert(weps, classname)
        end
    end

    -- Give everyone a new weapon when someone dies
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        timer.Simple(0.1, function()
            -- Remove all weapons from the ground, except grenades
            for _, ent in ipairs(ents.GetAll()) do
                if ent.AutoSpawnable and (ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_PISTOL) then
                    ent:Remove()
                end
            end

            for _, v in ipairs(player.GetAll()) do
                GiveNewWeapon(v)
            end
        end)
    end)

    -- Give a new weapon when someone respawns
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(0.1, function()
            GiveNewWeapon(ply)
        end)
    end)
end

Randomat:register(EVENT)