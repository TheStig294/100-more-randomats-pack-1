local EVENT = {}
EVENT.Title = "Deathly Chaos"
EVENT.Description = "The next time you die, a randomat triggers!"
EVENT.id = "deathlychaos"

EVENT.Categories = {"eventtrigger", "deathtrigger", "largeimpact"}

function EVENT:Begin()
    local deadPlayers = {}

    self:AddHook("PostPlayerDeath", function(ply)
        if not deadPlayers[ply] then
            deadPlayers[ply] = true
            Randomat:TriggerRandomEvent()
        end
    end)
end

Randomat:register(EVENT)