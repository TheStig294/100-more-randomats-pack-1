local EVENT = {}
EVENT.Title = "Heads Up Dismay"
EVENT.Description = "Hides the HUD"
EVENT.id = "hud"
util.AddNetworkString("HUDRandomat")
util.AddNetworkString("HUDRandomatHint")
util.AddNetworkString("HUDRandomatEnd")

function EVENT:Begin()
    -- Hides the start-of-round role hint
    net.Start("HUDRandomatHint")
    net.Broadcast()

    -- Hides the rest of the HUD, including the scoreboard
    timer.Simple(5, function()
        net.Start("HUDRandomat")
        net.Broadcast()
    end)
end

function EVENT:End()
    -- Removes the client-side HUD-hiding hooks for all players
    net.Start("HUDRandomatEnd")
    net.Broadcast()
end

Randomat:register(EVENT)