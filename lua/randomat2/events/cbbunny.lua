local EVENT = {}
EVENT.Title = "Combo: Bunny Hops"
EVENT.Description = "High jumps + bounce instead of fall damage!"
EVENT.id = "cbbunny"

EVENT.Categories = {"eventtrigger", "moderateimpact"}

local event1 = "boing"
local event2 = "bouncy"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)