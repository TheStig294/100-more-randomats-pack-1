local EVENT = {}
EVENT.Title = "Wasted"
EVENT.Description = "Everything goes slow-mo when someone dies, and they see a 'Wasted' screen"
EVENT.id = "wasted"

EVENT.Categories = {"deathtrigger", "biased_innocent", "biased", "smallimpact"}

util.AddNetworkString("WastedRandomatDeath")

function EVENT:Begin()
    local slowdownTimescale = 0.3

    self:AddHook("PostPlayerDeath", function(ply)
        -- Slow down everything when someone dies
        game.SetTimeScale(slowdownTimescale)
        -- Force them to spectate their body in 3rd-person
        local body = ply:GetObserverTarget()
        ply:UnSpectate()
        ply:Spectate(OBS_MODE_CHASE)
        ply:SpectateEntity(body)
        -- Show them the "Wasted" screen
        net.Start("WastedRandomatDeath")
        net.Send(ply)

        -- Create a timer that can be overridden on purpose so someone else dying resets it
        timer.Create("WastedRandomatResetTimeScale", 7 * slowdownTimescale, 1, function()
            game.SetTimeScale(1)
        end)
    end)
end

Randomat:register(EVENT)