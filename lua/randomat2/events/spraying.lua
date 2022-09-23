local EVENT = {}
EVENT.Title = "Who has the best spray?"
EVENT.Description = "You automatically use your spray!"
EVENT.id = "spraying"

EVENT.Categories = {"smallimpact"}

function EVENT:Begin()
    timer.Create("SprayingRandomatTimer", 0.1, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            ply:ConCommand("impulse 201")
        end
    end)
end

function EVENT:End()
    timer.Remove("SprayingRandomatTimer")
end

Randomat:register(EVENT)