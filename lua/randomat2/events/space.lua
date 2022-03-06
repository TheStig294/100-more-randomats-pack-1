local EVENT = {}
EVENT.Title = "Hold Space To Slow Down"
EVENT.id = "space"

EVENT.Categories = {"smallimpact"}

function EVENT:Begin()
    -- When a player holds the spacebar,
    self:AddHook("PlayerButtonDown", function(ply, button)
        if button == KEY_SPACE then
            -- 1/2 the speed of all their movement
            ply:SetLaggedMovementValue(0.5)
            -- And set a flag to make them immune to fall damage
            ply:SetNWBool("SpaceFallImmune", true)
        end
    end)

    -- Undo this when they release the spacebar
    self:AddHook("PlayerButtonUp", function(ply, button)
        if button == KEY_SPACE then
            ply:SetLaggedMovementValue(1)
            ply:SetNWBool("SpaceFallImmune", false)
        end
    end)

    -- Make spacebar-holding players immune to fall damage
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if IsValid(ent) and ent:IsPlayer() and dmginfo:IsDamageType(DMG_FALL) and ent:GetNWBool("SpaceFallImmune") then return true end
    end)
end

function EVENT:End()
    -- Set all players to normal speed and remove their fall damage flag
    for i, ply in pairs(self:GetPlayers()) do
        ply:SetLaggedMovementValue(1)
        ply:SetNWBool("SpaceFallImmune", false)
    end
end

Randomat:register(EVENT)