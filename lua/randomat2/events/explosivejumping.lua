local EVENT = {}
EVENT.Title = "Explosive Jumping"
EVENT.Description = "Super jump, make an explosion where you land, which only damages others!"
EVENT.id = "explosivejumping"

EVENT.Categories = {"fun", "largeimpact"}

local explosiveJumpingRandomat = false
local gravity

function EVENT:Begin()
    -- Let end function know randomat has triggered
    explosiveJumpingRandomat = true
    gravity = GetConVar("sv_gravity"):GetFloat()
    -- Set high gravity
    RunConsoleCommand("sv_gravity", 1800)

    -- Super jump, and remove PHD flopper
    for i, ply in pairs(self:GetAlivePlayers()) do
        ply:SetJumpPower(ply:GetJumpPower() + 800)
        Randomat:RemovePhdFlopper(ply)
    end

    -- Instead of taking fall damage, players create an explosion around them
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if not IsPlayer(ent) then return end

        if dmginfo:IsFallDamage() then
            local explode = ents.Create("env_explosion")
            explode:SetPos(ent:GetPos())
            explode:SetOwner(ent)
            explode:Spawn()
            explode:SetKeyValue("iMagnitude", "100")
            explode:SetKeyValue("iRadiusOverride", "256")
            explode:Fire("Explode", 0, 0)
            explode:EmitSound("weapon_AWP.Single", 400, 400)

            return true
        elseif dmginfo:IsExplosionDamage() and IsPlayer(dmginfo:GetAttacker()) and dmginfo:GetAttacker() == ent then
            -- Make everyone immune to their own explosions
            return true
        end
    end)

    -- Prevent anyone from buying a new PHD flopper, (Taken from Malivli's 'Come on and Slam!' event)
    self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
        if not IsValid(ply) then return end

        if id == "hoff_perk_phd" or (is_item and is_item == EQUIP_PHD) then
            ply:ChatPrint("PHD Floppers are disabled while '" .. Randomat:GetEventTitle(EVENT) .. "' is active!")

            return false
        end
    end)
end

function EVENT:End()
    -- Prevent reset function from running until randomat triggers again
    if explosiveJumpingRandomat then
        RunConsoleCommand("sv_gravity", gravity)

        for _, ply in pairs(self:GetPlayers()) do
            ply:SetJumpPower(160)
        end

        explosiveJumpingRandomat = false
    end
end

Randomat:register(EVENT)