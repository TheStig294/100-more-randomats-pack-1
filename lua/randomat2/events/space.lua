local EVENT = {}
EVENT.Title = "Hold Space To Slow Down"
EVENT.Description = "When you hold space, you slow down"
EVENT.id = "space"

function EVENT:Begin()
    self:AddHook("PlayerButtonDown", function(ply, button)
        if button == KEY_SPACE then
            ply:SetLaggedMovementValue(0.5)
            ply:SetNWBool("SpaceFallImmune", true)
        end
    end)

    self:AddHook("PlayerButtonUp", function(ply, button)
        if button == KEY_SPACE then
            ply:SetLaggedMovementValue(1)
            ply:SetNWBool("SpaceFallImmune", false)
        end
    end)

    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if IsValid(ent) and ent:IsPlayer() and dmginfo:IsDamageType(DMG_FALL) and ent:GetNWBool("SpaceFallImmune") then return true end
    end)
end

function EVENT:End()
    for i, ply in pairs(self:GetPlayers()) do
        ply:SetLaggedMovementValue(1)
        ply:SetNWBool("SpaceFallImmune", false)
    end
end

Randomat:register(EVENT)