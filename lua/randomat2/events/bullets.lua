local EVENT = {}
EVENT.Title = "Bullets, my only weakness!"
EVENT.Description = "Bullet damage only"
EVENT.id = "bullets"
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"biased_innocent", "biased", "rolechange", "moderateimpact"}

function EVENT:Begin()
    local new_traitors = {}

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsMeleeDamageRole(ply) then
            self:StripRoleWeapons(ply)
            local isTraitor = Randomat:SetToBasicRole(ply, "Traitor")

            if isTraitor then
                table.insert(new_traitors, ply)
            end
        end
    end

    -- Send message to the traitor team if new traitors joined
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)
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
    return Randomat:CheckForIncompatibleRole(Randomat.IsMeleeDamageRole, true)
end

Randomat:register(EVENT)