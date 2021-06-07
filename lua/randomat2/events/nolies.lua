local EVENT = {}
EVENT.Title = "Dead men tell no lies"
EVENT.Description = "Reveals a player's role on death"
EVENT.id = "nolies"

function EVENT:Begin()
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        -- GetRoleName() is a base randomat function, found in randomat_base_stig.lua
        self:SmallNotify(self:GetRoleName(victim) .. " Has Died")
    end)
end

Randomat:register(EVENT)