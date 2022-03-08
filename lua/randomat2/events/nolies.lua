local EVENT = {}
EVENT.Title = "Dead Men Tell No Lies"
EVENT.Description = "Reveals a player's role on death"
EVENT.id = "nolies"

EVENT.Categories = {"deathtrigger", "biased_innocent", "biased", "largeimpact"}

function EVENT:Begin()
    self:AddHook("PostPlayerDeath", function(ply)
        self:SmallNotify(self:GetRoleName(ply) .. " has died")
    end)
end

Randomat:register(EVENT)