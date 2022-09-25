local EVENT = {}
EVENT.Title = "Combo: Lightning round!"
EVENT.Description = "Short round time + you can see everyone through walls"
EVENT.id = "cblightning"

EVENT.Categories = {"eventtrigger", "largeimpact"}

local event1 = "speedrun"
local event2 = "wallhack"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)