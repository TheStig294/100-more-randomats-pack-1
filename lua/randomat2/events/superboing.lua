local EVENT = {}
EVENT.Title = "Super Boing"
EVENT.Description = "Super jump, high gravity, no fall damage"
EVENT.id = "superboing"

function EVENT:Begin()
    superBoingRandomat = true
    RunConsoleCommand("sv_gravity", 1800)

    for i, ply in pairs(self:GetAlivePlayers()) do
        ply:SetJumpPower(ply:GetJumpPower() + 800)
    end

    self:AddHook("TTTPlayerSpeed", function() return 1.5 end)

    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if IsValid(ent) and ent:IsPlayer() and dmginfo:IsFallDamage() then
            dmginfo:SetDamage(0)
        end
    end)
end

function EVENT:End()
    if superBoingRandomat then
        self:CleanUpHooks()
        RunConsoleCommand("sv_gravity", 600)

        for _, ply in pairs(player.GetAll()) do
            ply:SetJumpPower(200)
        end
    end
end

Randomat:register(EVENT)