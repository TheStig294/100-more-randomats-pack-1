-- Add the "Shh... It's a Secret!" event as it is effectively part of the randomat base from Malivil's randomat
if Randomat.Events.secret then return end
local EVENT = {}
EVENT.Title = "Shh... It's a Secret!"
EVENT.Description = "Silences all event notifications and triggers another random event"
EVENT.id = "secret"

EVENT.Categories = {"largeimpact"}

function EVENT:Begin(target_event)
    if target_event then
        Randomat:TriggerEvent(target_event, self.owner)
    else
        Randomat:TriggerRandomEvent(self.owner)
    end
end

Randomat:register(EVENT)