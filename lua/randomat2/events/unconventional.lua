local EVENT = {}
EVENT.Title = "Unconventional Healing"
EVENT.Description = "Fire, explosion and fall damage heals!"
EVENT.id = "unconventional"

function EVENT:Begin()
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        -- Don't affect negative damage sources, else this hook will lower a player's health
        if IsPlayer(ent) and dmginfo:GetDamage() > 0 and (dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_FALL) or dmginfo:IsDamageType(DMG_BLAST)) then
            -- Heal a player by the damage they would take, don't set them above max health
            ent:SetHealth(math.min(ent:Health() + dmginfo:GetDamage(), ent:GetMaxHealth()))
            -- Negate the damage they would take

            return true
        end
    end)
end

Randomat:register(EVENT)