local EVENT = {}
EVENT.Title = "Trigger happy"
EVENT.Description = "When someone shoots, everyone else does too"
EVENT.id = "triggerhappy"

EVENT.Categories = {"largeimpact"}

util.AddNetworkString("TriggerHappyRandomat")
util.AddNetworkString("TriggerHappyRandomatAttack")
util.AddNetworkString("TriggerHappyRandomatEnd")

function EVENT:Begin()
    net.Start("TriggerHappyRandomat")
    net.Broadcast()

    net.Receive("TriggerHappyRandomatAttack", function(len, msgPly)
        for _, ply in ipairs(self:GetAlivePlayers()) do
            if ply == msgPly then continue end
            ply:ConCommand("+attack")

            timer.Simple(0.1, function()
                ply:ConCommand("-attack")
            end)
        end
    end)
end

function EVENT:End()
    net.Start("TriggerHappyRandomatEnd")
    net.Broadcast()
end

function EVENT:Condition()
    return #self:GetAlivePlayers() <= 8
end

Randomat:register(EVENT)