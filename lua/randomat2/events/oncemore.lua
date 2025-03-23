local EVENT = {}

if not file.Exists("randomat/oncemore.txt", "DATA") then
    file.CreateDir("randomat")
    file.Write("randomat/oncemore.txt", "")
end

EVENT.Title = "Once more, with feeling!"
EVENT.Description = "Repeats the last randomat"
EVENT.id = "oncemore"

EVENT.Categories = {"eventtrigger", "moderateimpact"}

hook.Add("TTTRandomatTriggered", "OnceMoreRandomatGetRandomatID", function(id, owner)
    -- If this event is not enabled, or this event is the one that is triggering, we don't need to bother with this hook
    if not GetConVar("ttt_randomat_" .. EVENT.id):GetBool() or id == EVENT.id then return end
    -- Also don't record the choose randomat while auto choose is on
    if id == "choose" and GetConVar("ttt_randomat_auto"):GetBool() and GetConVar("ttt_randomat_auto_choose"):GetBool() then return end
    -- Else store the triggered randomat in a convar
    file.Write("randomat/oncemore.txt", id)
end)

function EVENT:Begin()
    -- Trigger the last randomat stored in the convar
    timer.Simple(5, function()
        Randomat:TriggerEvent(file.Read("randomat/oncemore.txt", "DATA"), self.owner)
    end)
end

function EVENT:Condition()
    return Randomat:CanEventRun(file.Read("randomat/oncemore.txt", "DATA"), true)
end

-- Don't trigger if the previous randomat can't run
Randomat:register(EVENT)