local EVENT = {}
EVENT.Title = "Super Boing"
EVENT.Description = "Super jump, high gravity, no fall damage"
EVENT.id = "superboing"

EVENT.Categories = {"fun", "moderateimpact"}

local superBoingRandomat = false
local gravity

function EVENT:Begin()
    -- Let end function know randomat has triggered
    superBoingRandomat = true
    gravity = GetConVar("sv_gravity"):GetFloat()
    -- Set high gravity
    RunConsoleCommand("sv_gravity", 1800)

    -- Super jump, and remove PHD flopper
    for i, ply in pairs(self:GetAlivePlayers()) do
        ply:SetJumpPower(ply:GetJumpPower() + 800)
        -- Remove PHD Flopper if someone has it
        Randomat:RemovePhdFlopper(ply)
    end

    -- And no fall damage
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if IsPlayer(ent) and dmginfo:IsFallDamage() then
            dmginfo:SetDamage(0)
        end
    end)

    -- Prevent anyone from buying a new PHD flopper, (Taken from Malivli's 'Come on and Slam!' event)
    self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
        if not IsValid(ply) then return end

        if id == "hoff_perk_phd" or (is_item and is_item == EQUIP_PHD) then
            ply:ChatPrint("PHD Floppers are disabled while '" .. Randomat:GetEventTitle(EVENT) .. "' is active!\nTry during the other 'Boing' randomats instead.")

            return false
        end
    end)
end

function EVENT:End()
    -- If randomat has triggered
    if superBoingRandomat then
        -- Reset gravity and jump power
        RunConsoleCommand("sv_gravity", gravity)

        for _, ply in pairs(self:GetPlayers()) do
            ply:SetJumpPower(160)
        end

        -- Prevent end function from running until randomat triggers again
        superBoingRandomat = false
    end
end

Randomat:register(EVENT)