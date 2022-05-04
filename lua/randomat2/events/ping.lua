local EVENT = {}
EVENT.Title = "Press E to ping"
EVENT.id = "ping"

EVENT.Categories = {"smallimpact"}

util.AddNetworkString("PingRandomatBegin")
util.AddNetworkString("PingRandomatPressedF")
util.AddNetworkString("PingRandomatEnd")

function EVENT:Begin()
    net.Start("PingRandomatBegin")
    net.Broadcast()

    self:AddHook("PlayerButtonDown", function(ply, button)
        if button == KEY_E and not ply:GetNWBool("PingRandomatCooldown") then
            local eyeTraceData = ply:GetEyeTrace()
            local pos = eyeTraceData.HitPos
            local ent = eyeTraceData.Entity
            net.Start("PingRandomatPressedF")
            net.WriteVector(pos)
            net.WriteEntity(ent)
            net.Broadcast()
            ply:SetNWBool("PingRandomatCooldown", true)

            timer.Simple(10, function()
                ply:SetNWBool("PingRandomatCooldown", false)
            end)
        end
    end)
end

function EVENT:End()
    net.Start("PingRandomatEnd")
    net.Broadcast()
end

Randomat:register(EVENT)