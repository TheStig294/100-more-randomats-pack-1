local EVENT = {}
EVENT.Title = "Deathly Chaos"
EVENT.Description = "Triggers a randomat the first time someone dies"
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

function EVENT:Condition()
    return #self:GetAlivePlayers() < 9
end

Randomat:register(EVENT)