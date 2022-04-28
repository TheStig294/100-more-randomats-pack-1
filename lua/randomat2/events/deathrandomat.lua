local EVENT = {}
EVENT.Title = "A randomat will trigger when someone dies!"
EVENT.id = "deathrandomat"

EVENT.Categories = {"eventtrigger", "deathtrigger", "largeimpact"}

function EVENT:Begin()
    self:AddHook("PostPlayerDeath", function(ply)
        local event = Randomat:GetRandomEvent(false, true)
        Randomat:TriggerEvent(event)
    end)
end

Randomat:register(EVENT)