local EVENT = {}
EVENT.Title = "Super Boing"
EVENT.Description = "Super jump, high gravity, no fall damage"
EVENT.id = "superboing"
local superBoingRandomat = false
local gravity

function EVENT:Begin()
    -- Let end function know randomat has triggered
    superBoingRandomat = true
    gravity = GetConVar("sv_gravity"):GetFloat()
    -- Set high gravity
    RunConsoleCommand("sv_gravity", 1800)

    -- Super jump
    for i, ply in pairs(self:GetAlivePlayers()) do
        ply:SetJumpPower(ply:GetJumpPower() + 800)
    end

    -- And no fall damage
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if IsValid(ent) and ent:IsPlayer() and dmginfo:IsFallDamage() then
            dmginfo:SetDamage(0)
        end
    end)
end

function EVENT:End()
    -- If randomat has triggered
    if superBoingRandomat then
        -- Reset gravity and jump power
        RunConsoleCommand("sv_gravity", gravity)

        for _, ply in pairs(self:GetPlayers()) do
            ply:SetJumpPower(200)
        end

        -- Prevent end function from running until randomat triggers again
        superBoingRandomat = false
    end
end

Randomat:register(EVENT)