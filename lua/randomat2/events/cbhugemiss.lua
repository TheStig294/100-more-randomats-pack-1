local EVENT = {}
EVENT.Title = "Combo: Easy to miss..."
EVENT.Description = "Missing shots damages you, hitting shots heal + H.U.G.E. only!"
EVENT.id = "cbhugemiss"

EVENT.Categories = {"eventtrigger", "largeimpact"}

local event1 = "hugeproblem"
local event2 = "dontmiss"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1, true) and Randomat:CanEventRun(event2, true)
end

Randomat:register(EVENT)