local EVENT = {}
EVENT.Title = "I'm Mary Poppins Y'all!"
EVENT.Description = "Float/teleport up and down walls, automatically walk over most obstacles"
EVENT.id = "marypoppins"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            -- Really what this randomat is doing is dramatically increasing everyone's step size
            -- Which is the maximum height off the ground a player can 'walk up on' like a staircase step
            ply:SetStepSize(1000)
        end)
    end
end

function EVENT:End()
    for i, ply in pairs(self:GetPlayers()) do
        timer.Simple(0.1, function()
            ply:SetStepSize(20)
        end)
    end
end

Randomat:register(EVENT)