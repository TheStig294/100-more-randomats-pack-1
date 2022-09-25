local EVENT = {}
EVENT.Title = "Combo: Ice Skating"
EVENT.Description = "Zero friction + shooting pushes you backwards"
EVENT.id = "cbskating"

EVENT.Categories = {"eventtrigger", "largeimpact"}

local event1 = "friction"
local event2 = "recoil"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)