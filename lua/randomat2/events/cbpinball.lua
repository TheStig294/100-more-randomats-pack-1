local EVENT = {}
EVENT.Title = "Combo: Pinball"
EVENT.Description = "Zero friction + get knocked away when you bump into someone"
EVENT.id = "cbpinball"

EVENT.Categories = {"eventtrigger", "largeimpact"}

local event1 = "pinball"
local event2 = "friction"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)