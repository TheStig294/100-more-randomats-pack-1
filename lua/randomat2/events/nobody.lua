local EVENT = {}
EVENT.Title = "Nobody"
EVENT.Description = "Anyone killed doesn't leave behind a body"
EVENT.id = "nobody"

function EVENT:Begin()
    self:AddHook("TTTOnCorpseCreated", function(corpse)
        timer.Simple(0.1, function()
            corpse:Remove()
        end)
    end)

    if CR_VERSION then
        util.AddNetworkString("NobodyRandomatDeathConfetti")

        self:AddHook("DoPlayerDeath", function(ply)
            net.Start("NobodyRandomatDeathConfetti")
            net.WriteEntity(ply)
            net.Broadcast()
        end)
    end
end

Randomat:register(EVENT)