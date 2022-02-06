local EVENT = {}
EVENT.Title = "Bullets, my only weakness!"
EVENT.Description = "Bullet damage only"
EVENT.id = "bullets"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:Begin()
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        -- If we make people immune to damage from the barnacle, the last players alive could get stuck, so also let barnacle damage through
        if IsPlayer(ent) and dmginfo:IsBulletDamage() == false and IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() ~= "npc_barnacle" then return true end
    end)
end

Randomat:register(EVENT)