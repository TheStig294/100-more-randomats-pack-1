local EVENT = {}
EVENT.Title = "Nice"
EVENT.Description = "Adds a new hitmarker sound"
EVENT.id = "nice"

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("RandomatNiceBegin")
util.AddNetworkString("RandomatNiceEnd")

function EVENT:Begin()
    net.Start("RandomatNiceBegin")
    net.Broadcast()

    self:AddHook("EntityTakeDamage", function(target, dmg)
        local attacker = dmg:GetAttacker()

        if IsPlayer(attacker) and IsPlayer(target) then
            attacker:SendLua("surface.PlaySound(\"nice/nice.mp3\")")
            attacker:SendLua("surface.PlaySound(\"nice/nice.mp3\")")
        end
    end)
end

function EVENT:End()
    net.Start("RandomatNiceEnd")
    net.Broadcast()
end

Randomat:register(EVENT)