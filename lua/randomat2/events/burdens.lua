local EVENT = {}

CreateConVar("randomat_burdens_speed_multiplier", 0.75, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "% of speed changed when dropping/picking up weapons", 0.01, 1)

EVENT.Title = "I'm sworn to carry your burdens"
EVENT.Description = "Less weapons, move faster. More weapons, move slower."
EVENT.id = "burdens"

function EVENT:Begin()
    -- Remove all grenades from players and the floor as speed multipliers don't apply correctly to them
    for _, ent in pairs(ents.GetAll()) do
        if ent.Kind == WEAPON_NADE and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    local starting_weapons = {}
    local speed_multiplier = GetConVar("randomat_burdens_speed_multiplier"):GetFloat()
    timer.Create("RdmtBurdensCheckTimer", 0.5, 0, function()
        for _, p in ipairs(player.GetAll()) do
            if p:Alive() and not p:IsSpec() then
                local count = #p:GetWeapons()
                local sid = p:SteamID64()
                if not starting_weapons[sid] then
                    starting_weapons[sid] = count
                end

                -- Adjust the player's movement based on the difference in weapon count from when the event started
                local value = 1
                if count > starting_weapons[sid] then
                    value = (count - starting_weapons[sid]) * speed_multiplier
                elseif count < starting_weapons[sid] then
                    value = (starting_weapons[sid] - count) * (1 / speed_multiplier)
                end

                p:SetLaggedMovementValue(value)
            else
                p:SetLaggedMovementValue(1)
            end
        end
    end)
end

function EVENT:End()
    timer.Remove("RdmtBurdensCheckTimer")
    -- Reset all players back to default speed
    for _, ply in pairs(self:GetPlayers()) do
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
