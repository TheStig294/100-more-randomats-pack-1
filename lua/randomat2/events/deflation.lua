local EVENT = {}
EVENT.Title = "Deflation"
EVENT.Description = "Players shrink as they take damage!"
EVENT.id = "deflation"

EVENT.Categories = {"moderateimpact"}

local offsets = {}
local offsets_ducked = {}

function EVENT:SetPlayerSize(size, ply)
    -- Makes player size scale from 1 to 0.3 rather than 1 to 0, so they aren't impossible to hit when on low health
    size = 0.7 * size + 0.3
    ply:SetModelScale(size, 0.2)
    ply:SetViewOffset(Vector(0, 0, 64 * size))
    ply:SetViewOffsetDucked(Vector(0, 0, 28 * size))
    ply:SetStepSize(ply:GetStepSize() * size)
    -- Reduce the player speed on the client
    local speed_factor = math.Clamp(ply:GetStepSize() / 9, 0.25, 1)
    net.Start("RdmtSetSpeedMultiplier")
    net.WriteFloat(speed_factor)
    net.WriteString("RdmtDeflationSpeed")
    net.Send(ply)
end

function EVENT:ResetPlayerSize(ply)
    local offset = nil

    -- Check to see if they had their view height changed
    if offsets[ply:SteamID64()] then
        -- If so, grab it and clear it from the table
        offset = offsets[ply:SteamID64()]
        offsets[ply:SteamID64()] = nil
    end

    -- Reset their view height if it was changed
    if offset or not ply.ec_ViewChanged then
        ply:SetViewOffset(offset or Vector(0, 0, 64))
    end

    -- And same with their view height while crouched
    local offset_ducked = nil

    if offsets_ducked[ply:SteamID64()] then
        offset_ducked = offsets_ducked[ply:SteamID64()]
        offsets_ducked[ply:SteamID64()] = nil
    end

    if offset_ducked or not ply.ec_ViewChanged then
        ply:SetViewOffsetDucked(offset_ducked or Vector(0, 0, 28))
    end

    -- Reset their model size and step size
    ply:SetModelScale(1, 1)
    ply:SetStepSize(18)
    -- Reset the player speed on the client
    net.Start("RdmtRemoveSpeedMultiplier")
    net.WriteString("RdmtRandomSizeSpeed")
    net.Send(ply)
end

function EVENT:Begin()
    for _, ply in ipairs(self:GetAlivePlayers()) do
        timer.Create("DeflationRandomatTimer" .. ply:SteamID64(), 0.1, 0, function()
            self:SetPlayerSize(ply:Health() / ply:GetMaxHealth(), ply)
        end)
    end

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        timer.Remove("DeflationRandomatTimer" .. ply:SteamID64())
    end)

    self:AddHook("PlayerSpawn", function(ply)
        timer.Create("DeflationRandomatTimer" .. ply:SteamID64(), 0.1, 0, function()
            self:SetPlayerSize(ply:Health() / ply:GetMaxHealth(), ply)
        end)
    end)
end

function EVENT:End()
    for _, ply in ipairs(player.GetAll()) do
        timer.Remove("DeflationRandomatTimer" .. ply:SteamID64())
        self:ResetPlayerSize(ply)
    end
end

Randomat:register(EVENT)