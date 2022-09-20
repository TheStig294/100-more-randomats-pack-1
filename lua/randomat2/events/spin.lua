local EVENT = {}
EVENT.Title = "You spin me right round baby..."
EVENT.Description = "Taking damage rotates you"
EVENT.id = "spin"

EVENT.Categories = {"largeimpact"}

function EVENT:Begin()
    self:AddHook("PostEntityTakeDamage", function(ent, dmg, took)
        if not took or not IsPlayer(ent) then return end
        ent:SetEyeAngles(ent:EyeAngles() + Angle(0, 20, 0))
    end)
end

Randomat:register(EVENT)