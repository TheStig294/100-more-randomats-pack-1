local EVENT = {}
EVENT.Title = "Deflation"
EVENT.Description = "Players shrink as they take damage!"
EVENT.id = "deflation"

EVENT.Categories = {"moderateimpact"}

local stepSizes = {}

function EVENT:SetDeflationScale(ply, scaleOverride)
    if scaleOverride then
        Randomat:SetPlayerScale(ply, scaleOverride, self.id)
    else
        local size = (0.7 * (ply:Health() / ply:GetMaxHealth())) + 0.3
        local currentSize = ply:GetStepSize() / stepSizes[ply]
        Randomat:SetPlayerScale(ply, size / currentSize, self.id)
    end
end

function EVENT:Begin()
    -- Used for getting a player's current scale so scales aren't applied recursively
    -- E.g. take two 20 damage hits, first hit sets to 0.8, 2nd to 0.6. As opposed to first hit 0.8, 2nd to 0.8 * 0.6
    for _, ply in ipairs(player.GetAll()) do
        stepSizes[ply] = ply:GetStepSize()
    end

    -- Set everyone's initial scale
    for _, ply in ipairs(self:GetAlivePlayers()) do
        self:SetDeflationScale(ply)
    end

    -- Set player scales after taking damage
    self:AddHook("PostEntityTakeDamage", function(ent, dmginfo, took)
        if not took then return end
        if (not IsPlayer(ent)) or ent:IsSpec() or not ent:Alive() then return end
        self:SetDeflationScale(ent)
    end)

    -- Reset scales of respawned players
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(0.1, function()
            Randomat:ResetPlayerScale(ply, self.id)
        end)
    end)
end

function EVENT:End()
    self:ResetAllPlayerScales()
end

Randomat:register(EVENT)