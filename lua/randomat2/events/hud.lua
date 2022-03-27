local EVENT = {}
EVENT.Title = "Heads Up Dismay"
EVENT.Description = "Hides the HUD"
EVENT.id = "hud"

EVENT.Categories = {"largeimpact"}

util.AddNetworkString("HUDRandomat")
util.AddNetworkString("HUDRandomatHint")
util.AddNetworkString("HUDRandomatEnd")

function EVENT:Begin()
    -- Hides the start-of-round role hint
    net.Start("HUDRandomatHint")
    net.Broadcast()

    -- Hides the rest of the HUD, including the scoreboard
    timer.Create("HUDRandomatStart", 5, 1, function()
        net.Start("HUDRandomat")
        net.Broadcast()

        self:AddHook("PostPlayerDeath", function(ply)
            net.Start("HUDRandomatEnd")
            net.Send(ply)
        end)

        self:AddHook("PlayerSpawn", function(ply, transition)
            net.Start("HUDRandomat")
            net.Send(ply)
        end)
    end)
end

function EVENT:End()
    timer.Remove("HUDRandomatStart")
    -- Removes the client-side HUD-hiding hooks for all players
    net.Start("HUDRandomatEnd")
    net.Broadcast()
end

Randomat:register(EVENT)