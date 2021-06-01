local EVENT = {}
EVENT.Title = "Dead men tell no lies"
EVENT.Description = "Reveals a player's role on death"
EVENT.id = "nolies"

function EVENT:Begin()
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        local role = self:GetRoleAsString(victim:GetRole())
        self:SmallNotify(role .. " Has Died")
    end)
end

function EVENT:GetRoleAsString(role)
    if role == ROLE_INNOCENT then
        return "An Innocent"
    elseif role == ROLE_ZOMBIE then
        return "A Zombie"
    elseif role == ROLE_DETECTIVE then
        return "The Detective"
    elseif role == ROLE_MERCENARY then
        return "A Mercenary"
    elseif role == ROLE_GLITCH then
        return "The Glitch"
    elseif role == ROLE_PHANTOM then
        return "The Phantom"
    elseif role == ROLE_TRAITOR then
        return "A Traitor"
    elseif role == ROLE_HYPNOTIST then
        return "The Hypnotist"
    elseif role == ROLE_ASSASSIN then
        return "The Assassin"
    elseif role == ROLE_VAMPIRE then
        return "The Vampire"
    elseif role == ROLE_KILLER then
        return "The Killer"
    elseif role == ROLE_SWAPPER then
        return "The Swapper"
    elseif role == ROLE_JESTER then
        return "The Jester"
    else
        return "A Mysterious Person"
    end
end

Randomat:register(EVENT)