local EVENT = {}
EVENT.Title = "Doomed!"
EVENT.Description = "You can only look side-to-side"
EVENT.id = "doomed"

EVENT.Categories = {"largeimpact"}

util.AddNetworkString("DoomedRandomatBegin")
util.AddNetworkString("DoomedRandomatEnd")

function EVENT:Begin()
    net.Start("DoomedRandomatBegin")
    net.Broadcast()

    for _, ply in ipairs(self:GetAlivePlayers()) do
        local angles = ply:EyeAngles()
        angles.pitch = 0
        ply:SetEyeAngles(angles)
    end

    -- Sets everyone looking forward in case someone's view becomes offset
    timer.Create("DoomedRandomatSetView", 1, 0, function()
        for _, ply in ipairs(self:GetAlivePlayers()) do
            local angles = ply:EyeAngles()
            angles.pitch = 0
            ply:SetEyeAngles(angles)
        end
    end)

    -- And when respawning
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            local angles = ply:EyeAngles()
            angles.pitch = 0
            ply:SetEyeAngles(angles)
        end)
    end)
end

function EVENT:End()
    net.Start("DoomedRandomatEnd")
    net.Broadcast()
    timer.Remove("DoomedRandomatSetView")
end

Randomat:register(EVENT)