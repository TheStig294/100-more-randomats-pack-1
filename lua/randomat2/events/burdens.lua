local EVENT = {}

CreateConVar("randomat_burdens_multiplier", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Multiply movement speed change by this number", 0.5, 2)

EVENT.Title = "I'm sworn to carry your burdens"
EVENT.Description = "Less weapons, move faster. More weapons, move slower."
EVENT.id = "burdens"

function EVENT:Begin()
    -- Players have default speed at 6 weapons, 1/3 speed at 8 weapons and x2 speed at 3 weapons
    self:AddHook("Think", function()
        for i, ply in ipairs(self:GetAlivePlayers()) do
            local numWeapons = #ply:GetWeapons()
            ply:SetLaggedMovementValue(math.max(0.33, -1 / 3 * (numWeapons - 9) * GetConVar("randomat_burdens_multiplier"):GetFloat()))
        end
    end)

    -- Resets the speed of players that die
    self:AddHook("PostPlayerDeath", function(ply)
        ply:SetLaggedMovementValue(1)
    end)
end

--Reset all players back to default speed when the round ends/randomat is cleared
function EVENT:End()
    for i, ply in pairs(self:GetPlayers()) do
        ply:SetLaggedMovementValue(1)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"multiplier"}) do
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