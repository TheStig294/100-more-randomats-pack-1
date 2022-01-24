local EVENT = {}
EVENT.Title = "Dead men tell no lies"
EVENT.Description = "Reveals a player's role on death"
EVENT.id = "nolies"

function EVENT:Begin()
    self:AddHook("PostPlayerDeath", function(ply)
        self:SmallNotify(self:GetRoleName(ply) .. " has died")
    end)
end

Randomat:register(EVENT)