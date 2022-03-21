local EVENT = {}
EVENT.Title = "Bullets, my only weakness!"
EVENT.Description = "Bullet damage only"
EVENT.id = "bullets"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"biased_innocent", "biased", "moderateimpact"}

function EVENT:Begin()
    for _, ply in ipairs(self:GetAlivePlayers()) do
        if IsMeleeDamageRole(ply) then
            self:StripRoleWeapons(ply)
            SetToBasicRole(ply)
        end
    end

    SendFullStateUpdate()

    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if IsPlayer(ent) and dmginfo:IsBulletDamage() == false then
            -- If we make people immune to damage from the barnacle, the last players alive could get stuck, so also let barnacle damage through
            if IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() == "npc_barnacle" then
                return
            else
                return true
            end
        end
    end)
end

-- Checking if someone is a melee damage role and if it isn't at the start of the round, prevent the event from running
function EVENT:Condition()
    local meleeDamageRoleExists = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if IsMeleeDamageRole(ply) then
            meleeDamageRoleExists = true
            break
        end
    end

    return Randomat:GetRoundCompletePercent() < 5 or not meleeDamageRoleExists
end

Randomat:register(EVENT)