local EVENT = {}
EVENT.Title = "Heads Up Dismay"
EVENT.Description = "Hides the HUD"
EVENT.id = "hud"
util.AddNetworkString("HUDRandomat")
util.AddNetworkString("HUDRandomatHint")
util.AddNetworkString("HUDRandomatEnd")

function EVENT:Begin()
    net.Start("HUDRandomatHint")
    net.Broadcast()

    timer.Simple(5, function()
        net.Start("HUDRandomat")
        net.Broadcast()
    end)
end

function EVENT:End()
    net.Start("HUDRandomatEnd")
    net.Broadcast()
end

Randomat:register(EVENT)