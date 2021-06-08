local EVENT = {}
EVENT.Title = "Once more, with feeling!"
EVENT.Description = "Repeats the last randomat"
EVENT.id = "oncemore"
CreateConVar("randomat_oncemore_last_randomat", "", FCVAR_ARCHIVE, "The last auto-randomat that was activated, (don't touch), used for the 'Once more with feeling!' randomat")

-- At the start of each round,
hook.Add("TTTBeginRound", "OnceMoreRandomatGetRandomatID", function()
    -- If auto-randomat, and this event is enabled
    if GetConVar("ttt_randomat_auto"):GetBool() and GetConVar("randomat_oncemore"):GetBool() then
        -- Wait a second,
        timer.Simple(1, function()
            -- Grab the ID of the auto-randomat that triggered
            local activeEventId = Randomat.ActiveEvents[1].Id

            -- And store it in the convar, so long as the randomat being stored isn't this one
            if activeEventId ~= nil and activeEventId ~= "oncemore" then
                GetConVar("randomat_oncemore_last_randomat"):SetString(activeEventId)
            end
        end)
    end
end)

function EVENT:Begin()
    -- Grab the number of randomat currently active in the round (including this one)
    local activeEventsNo = #Randomat.ActiveEvents

    -- If this randomat activated after another in the same round,
    if activeEventsNo > 1 then
        -- Grab the ID of the last randomat that triggered, 
        local lastEventID = Randomat.ActiveEvents[activeEventsNo - 1].Id

        -- And after 5 seconds, trigger that randomat
        timer.Simple(5, function()
            Randomat:TriggerEvent(lastEventID, self.owner)
        end)
    else
        -- If this is the first randomat in the round, and the last randomat wasn't this one,
        if (GetConVar("randomat_oncemore_last_randomat"):GetString() ~= nil) and GetConVar("randomat_oncemore_last_randomat"):GetString() ~= "oncemore" then
            -- Trigger the last randomat stored in the convar
            timer.Simple(5, function()
                Randomat:TriggerEvent(GetConVar("randomat_oncemore_last_randomat"):GetString(), self.owner)
            end)
        end
    end
end

-- Doesn't trigger if the convar is empty or auto-randomat is turned off
function EVENT:Condition()
    if GetConVar("randomat_oncemore_last_randomat"):GetString() == "" then return false end

    return GetConVar("ttt_randomat_auto"):GetBool()
end

Randomat:register(EVENT)