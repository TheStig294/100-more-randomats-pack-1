local EVENT = {}
EVENT.Title = "Bullets, my only weakness!"
EVENT.Description = "Bullet damage only"
EVENT.id = "bullets"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:Begin()
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        --If an entity takes damage that isn't bullet damage, negate it.
        if IsValid(ent) and ent:IsPlayer() and dmginfo:IsBulletDamage() == false then return true end
    end)
end

Randomat:register(EVENT)