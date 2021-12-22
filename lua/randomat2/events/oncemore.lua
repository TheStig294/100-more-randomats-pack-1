local EVENT = {}
CreateConVar("randomat_oncemore_last_randomat", "", FCVAR_ARCHIVE, "The last auto-randomat that was activated, (don't touch), used for the 'Once more with feeling!' randomat")
EVENT.Title = "Once more, with feeling!"
EVENT.Description = "Repeats the last randomat"
EVENT.id = "oncemore"

hook.Add("TTTRandomatTriggered", "OnceMoreRandomatGetRandomatID", function(id, owner)
    -- If this event is not enabled, or this event is the one that is triggering, we don't need to bother with this hook
    if not GetConVar("ttt_randomat_" .. EVENT.id):GetBool() or id == EVENT.id then return end
    -- Also don't record the choose randomat while auto choose is on
    if id == "choose" and GetConVar("ttt_randomat_auto"):GetBool() and GetConVar("ttt_randomat_auto_choose"):GetBool() then return end
    -- Else store the triggered randomat in a convar
    GetConVar("randomat_oncemore_last_randomat"):SetString(id)
end)

function EVENT:Begin()
    -- Trigger the last randomat stored in the convar
    timer.Simple(5, function()
        Randomat:TriggerEvent(GetConVar("randomat_oncemore_last_randomat"):GetString(), self.owner)
    end)
end

function EVENT:Condition()
    -- Don't trigger if the previous randomat can't run
    return Randomat:CanEventRun(GetConVar("randomat_oncemore_last_randomat"):GetString(), true)
end

Randomat:register(EVENT)