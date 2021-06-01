local EVENT = {}
EVENT.Title = "Once more, with feeling!"
EVENT.Description = "Repeats the last randomat"
EVENT.id = "oncemore"
CreateConVar("ttt_randomat_oncemore_last_randomat", "", FCVAR_ARCHIVE, "The last randomat that was activated, (don't touch), used for the 'Once more with feeling!' randomat")

function EVENT:Begin()
    if (GetConVar("ttt_randomat_oncemore_last_randomat"):GetString() ~= nil) and GetConVar("ttt_randomat_oncemore_last_randomat"):GetString() ~= "oncemore" then
        timer.Simple(5, function()
            Randomat:TriggerEvent(GetConVar("ttt_randomat_oncemore_last_randomat"):GetString(), self.owner)
        end)
    end
end

Randomat:register(EVENT)

hook.Add("TTTBeginRound", "OnceMoreRandomatGetRandomatID", function()
    if GetConVar("ttt_randomat_auto"):GetBool() and GetConVar("ttt_randomat_oncemore"):GetBool() then
        timer.Simple(1, function()
            local activeEvents = Randomat.ActiveEvents
            local activeEventId = nil
            activeEventId = activeEvents[1].Id

            if (activeEventId ~= oncemore) and (activeEventId ~= nil) then
                GetConVar("ttt_randomat_oncemore_last_randomat"):SetString(activeEventId)
            end
        end)
    end
end)