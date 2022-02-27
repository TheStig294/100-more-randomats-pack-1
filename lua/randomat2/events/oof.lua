local EVENT = {}
EVENT.Title = "Oof"
EVENT.Description = "Whenever you are hurt, you hear an 'oof' sound"
EVENT.id = "oof"
util.AddNetworkString("OofRandomatSound")

function EVENT:Begin()
    self:AddHook("PostEntityTakeDamage", function(ent, dmginfo, took)
        if IsPlayer(ent) and took then
            net.Start("OofRandomatSound")
            net.Send(ent)
        end
    end)
end

Randomat:register(EVENT)