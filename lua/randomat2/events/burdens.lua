local EVENT = {}

CreateConVar("randomat_burdens_speed_multiplier", 0.75, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "% of speed changed when dropping/picking up weapons", 0.01, 1)

EVENT.Title = "I'm sworn to carry your burdens"
EVENT.Description = "Less weapons, move faster. More weapons, move slower."
EVENT.id = "burdens"

function EVENT:Begin()
    --Remove all grenades from players and the floor as speed multipliers don't apply correctly to them
    for _, ent in pairs(ents.GetAll()) do
        if ent.Kind == WEAPON_NADE and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    self:AddHook("WeaponEquip", function(weapon, owner)
        --Slows players that pick up weapons
        owner:SetLaggedMovementValue(owner:GetLaggedMovementValue() * GetConVar("randomat_burdens_speed_multiplier"):GetFloat())
    end)

    self:AddHook("PlayerDroppedWeapon", function(owner, wep)
        --Speed up players that drop weapons
        owner:SetLaggedMovementValue(owner:GetLaggedMovementValue() * 1 / GetConVar("randomat_burdens_speed_multiplier"):GetFloat())
    end)

    self:AddHook("PlayerSpawn", function(ply, transition)
        -- Resets the speed of players that respawn, after a delay of 2 seconds
        timer.Simple(2, function()
            ply:SetLaggedMovementValue(1)
        end)
    end)
end

function EVENT:End()
    --Reset all players back to default speed
    for i, ply in pairs(self:GetPlayers()) do
        ply:SetLaggedMovementValue(1)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"speed_multiplier"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 2
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)