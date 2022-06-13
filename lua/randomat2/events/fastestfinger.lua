local EVENT = {}
EVENT.Title = "Fastest Finger"
EVENT.Description = "1st person to type a randomat's name in chat triggers it!"
EVENT.id = "fastestfinger"

EVENT.Categories = {"eventtrigger", "largeimpact"}

function EVENT:Begin()
    -- Grab the names of every randomat that has a name
    local randomatNames = {}

    for id, event in pairs(Randomat.Events) do
        local title = Randomat:GetEventTitle(event)
        if title == "" then continue end
        title = string.lower(title)
        randomatNames[event.id] = title
    end

    -- Shuffle the order of the event names so bad short queries end up with random events triggered
    -- Rather than potentially always having an easily-triggered, large impact event
    table.Shuffle(randomatNames)

    self:AddHook("PlayerSay", function(ply, text)
        -- Have to type at least 5 letters to prevent remembering only a couple letters to trigger certain randomats
        if string.len(text) < 5 then return end
        text = string.lower(text)

        for id, title in pairs(randomatNames) do
            -- True argument ignores event history so players can trigger recently triggered events if they want
            if string.find(title, text) and Randomat:CanEventRun(id, true) then
                Randomat:SafeTriggerEvent(id)
                -- This will prevent this event from being typed in over and over
                -- Using this randomat to trigger itself is equivalent to it never triggering in the first place
                self:RemoveHook("PlayerSay")
                PrintMessage(HUD_PRINTTALK, ply:Nick() .. " had the fastest finger!")

                return ""
            end
        end
    end)
end

Randomat:register(EVENT)