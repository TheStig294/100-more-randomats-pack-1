local EVENT = {}
CreateConVar("randomat_oncemore_last_randomat", "", FCVAR_ARCHIVE, "The last auto-randomat that was activated, (don't touch), used for the 'Once more with feeling!' randomat")
EVENT.Title = "Once more, with feeling!"
EVENT.Description = "Repeats the last randomat"
EVENT.id = "oncemore"

hook.Add("TTTRandomatTriggered", "OnceMoreRandomatGetRandomatID", function(id, owner)
    -- If this event is not enabled, or this event is the one that is triggering, we don't need to bother with this hook
    if not GetConVar("ttt_randomat_oncemore"):GetBool() or id == "oncemore" then return end
    local autoRandomat = GetConVar("ttt_randomat_auto"):GetBool()
    local autoChoose = GetConVar("ttt_randomat_auto_choose"):GetBool()

    if autoRandomat and not autoChoose then
        GetConVar("randomat_oncemore_last_randomat"):SetString(id)
    elseif autoRandomat and autoChoose then
        if id == "choose" then
            return
        else
            GetConVar("randomat_oncemore_last_randomat"):SetString(id)
        end
    end
end)

function EVENT:Begin()
    -- Trigger the last randomat stored in the convar
    timer.Simple(5, function()
        Randomat:TriggerEvent(GetConVar("randomat_oncemore_last_randomat"):GetString(), self.owner)
    end)
end

-- Don't trigger if the previous randomat hasn't been recorded
function EVENT:Condition()
    return GetConVar("randomat_oncemore_last_randomat"):GetString() ~= ""
end

Randomat:register(EVENT)