local EVENT = {}
EVENT.Title = "Hot Pursuit"
EVENT.Description = "Move faster as more people die"
EVENT.id = "pursuit"

EVENT.Categories = {"deathtrigger", "largeimpact"}

CreateConVar("randomat_pursuit_mult", "1.5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Movement speed multiplier", 0.5, 3)

function EVENT:Begin()
    self:AddHook("Think", function()
        local alivePlayers = self:GetAlivePlayers()
        local alivePlayerCount = #alivePlayers
        local playerCount = player.GetCount()

        for _, ply in ipairs(alivePlayers) do
            -- Speed multiplier formula of the form: 1/x, used Desmos for visualisation
            ply:SetLaggedMovementValue(math.max(0.33, -(alivePlayerCount / playerCount) + 1.5 * (playerCount / alivePlayerCount)))
        end
    end)

    -- Resets the speed of players that die
    self:AddHook("PostPlayerDeath", function(ply)
        timer.Simple(0.1, function()
            ply:SetLaggedMovementValue(1)
        end)
    end)
end

-- Reset all players back to default speed when the round ends/randomat is cleared
function EVENT:End()
    for _, ply in pairs(player.GetAll()) do
        ply:SetLaggedMovementValue(1)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"mult"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 1
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)