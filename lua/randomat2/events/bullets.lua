local EVENT = {}
EVENT.Title = "Bullets, my only weakness!"
EVENT.Description = "Bullet damage only"
EVENT.id = "bullets"

function EVENT:Begin()
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        --If an entity takes damage that isn't bullet damage, negate it.
        if IsValid(ent) and ent:IsPlayer() and dmginfo:IsBulletDamage() == false then return true end
    end)
end

Randomat:register(EVENT)