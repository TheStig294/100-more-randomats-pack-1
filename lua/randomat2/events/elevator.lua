local EVENT = {}
EVENT.Title = "Instant Elevator"
EVENT.Description = "Teleport up and down flat walls and obstacles by walking into or off them!"
EVENT.id = "elevator"

EVENT.Categories = {"moderateimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetPlayers()) do
        timer.Simple(0.1, function()
            -- Really what this randomat is doing is dramatically increasing everyone's step size
            -- Which is the maximum height off the ground a player can 'walk up on' like a staircase step
            ply:SetStepSize(1000)
        end)
    end

    -- Move the player's camera up a bit when they teleport a big distance,
    -- so their camera instantly updates to their new position,
    -- rather than awkwardly going through a wall
    self:AddHook("PlayerPostThink", function(ply)
        local posZ = ply:GetPos().z

        if ply.ElevatorRandomatLastZPos and math.abs(ply.ElevatorRandomatLastZPos - posZ) > 100 then
            local currentOffset = ply:GetCurrentViewOffset()
            currentOffset.z = currentOffset.z + 20
            ply:SetCurrentViewOffset(currentOffset)
        end

        ply.ElevatorRandomatLastZPos = posZ
    end)
end

function EVENT:End()
    for i, ply in pairs(self:GetPlayers()) do
        ply:SetStepSize(20)
    end
end

Randomat:register(EVENT)