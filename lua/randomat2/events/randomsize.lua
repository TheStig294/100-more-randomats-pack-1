local EVENT = {}
CreateConVar("randomat_randomsize_min", 25, FCVAR_NONE, "Minimum possible size", 10, 100)
CreateConVar("randomat_randomsize_max", 100, FCVAR_NONE, "Maximum possible size", 10, 100)
EVENT.Title = "Random sizes for everyone!"
EVENT.ExtDescription = "Everyone is shrunk down to a random unique size"
EVENT.id = "randomsize"

EVENT.Categories = {"fun", "moderateimpact"}

local offsets = {}
local offsets_ducked = {}

function EVENT:SetPlayerSize(randomSize, ply)
    ply:SetModelScale(1 * randomSize, 1)
    ply:SetViewOffset(Vector(0, 0, 64 * randomSize))
    ply:SetViewOffsetDucked(Vector(0, 0, 28 * randomSize))
    local a, b = ply:GetHull()
    ply:SetHull(a * randomSize, b * randomSize)
    a, b = ply:GetHullDuck()
    ply:SetHullDuck(a * randomSize, b * randomSize)
    ply:SetHealth(ply:Health() * randomSize)
    ply:SetMaxHealth(ply:GetMaxHealth() * randomSize)
    ply:SetStepSize(ply:GetStepSize() * randomSize)
    -- Reduce the player speed on the client
    local speed_factor = math.Clamp(ply:GetStepSize() / 9, 0.25, 1)
    net.Start("RdmtSetSpeedMultiplier")
    net.WriteFloat(speed_factor)
    net.WriteString("RdmtRandomSizeSpeed")
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

    -- Reset their model size, ability to jump, hitbox and step size
    ply:ResetHull()
    ply:SetModelScale(1, 1)
    ply:SetStepSize(18)
    ply:SetHealth(100)
    -- Reset the player speed on the client
    net.Start("RdmtRemoveSpeedMultiplier")
    net.WriteString("RdmtRandomSizeSpeed")
    net.Send(ply)
end

function EVENT:Begin()
    -- Getting the set minimum and maximum size set by the convars
    local sizeMin = GetConVar("randomat_randomsize_min"):GetInt() / 100
    local sizeMax = GetConVar("randomat_randomsize_max"):GetInt() / 100

    -- For all alive players,
    for i, ply in pairs(self:GetAlivePlayers()) do
        -- Get their view height and view height while crouching,
        if not offsets[ply:SteamID64()] then
            offsets[ply:SteamID64()] = ply:GetViewOffset()
        end

        if not offsets_ducked[ply:SteamID64()] then
            offsets_ducked[ply:SteamID64()] = ply:GetViewOffsetDucked()
        end

        -- Randomly scale their model size, view heights, health and how high they jump
        local randomSize = math.Rand(sizeMin, sizeMax)
        self:SetPlayerSize(randomSize, ply)
    end

    self:AddHook("PlayerSpawn", function(ply)
        self:ResetPlayerSize(ply)
    end)
end

function EVENT:End()
    for i, ply in pairs(self:GetPlayers()) do
        self:ResetPlayerSize(ply)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"min", "max"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)