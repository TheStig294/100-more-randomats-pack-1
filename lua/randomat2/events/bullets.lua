local EVENT = {}
EVENT.Title = "Bullets, my only weakness!"
EVENT.Description = "Bullet damage only"
EVENT.id = "bullets"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"biased_innocent", "biased", "rolechange", "moderateimpact"}

function EVENT:Begin()
    local _, _, new_traitors = Randomat:BalanceTeams()
    -- Send message to the traitor team if new traitors joined
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)

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

Randomat:register(EVENT)