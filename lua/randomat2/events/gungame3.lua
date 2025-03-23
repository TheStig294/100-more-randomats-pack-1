local EVENT = {}
EVENT.Title = "Gun Game 3.0"
EVENT.Description = "Periodically gives players random buyable weapons"
EVENT.id = "gungame3"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"item", "largeimpact"}

CreateConVar("randomat_gungame3_timer", 5, FCVAR_NONE, "Seconds between weapon changes", 5, 60)

function EVENT:Begin()
    local weps = {}

    for _, ent in ipairs(ents.GetAll()) do
        if ent.AutoSpawnable then
            ent:Remove()
        end
    end

    -- Only gives out items with a damage value set
    for _, wep in ipairs(weapons.GetList()) do
        if wep.CanBuy and istable(wep.CanBuy) and not table.IsEmpty(wep.CanBuy) and (wep.Kind >= WEAPON_EQUIP) and wep.Primary and wep.Primary.Damage and wep.Primary.Damage > 0 then
            table.insert(weps, wep)
        end
    end

    timer.Create("GunGame3RandomatTimer", GetConVar("randomat_gungame3_timer"):GetInt(), 0, function()
        for _, ply in ipairs(player.GetAll()) do
            local activeWep = ply:GetActiveWeapon()
            local strippedActiveWep = false

            -- Only strip equipment items, but not role weapons
            if IsValid(activeWep) and activeWep.Kind >= WEAPON_EQUIP and activeWep.Kind ~= WEAPON_ROLE then
                strippedActiveWep = true
            end

            for _, wep in ipairs(ply:GetWeapons()) do
                if wep.Kind >= WEAPON_EQUIP and wep.Kind ~= WEAPON_ROLE then
                    ply:StripWeapon(wep.ClassName)
                end
            end

            local wepGiven = weps[math.random(#weps)]
            ply:Give(wepGiven.ClassName)
            -- Reset FOV to unscope
            ply:SetFOV(0, 0.2)

            if strippedActiveWep then
                ply:SelectWeapon(wepGiven.ClassName)
            end
        end
    end)
end

function EVENT:End()
    timer.Remove("GunGame3RandomatTimer")
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"timer"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)