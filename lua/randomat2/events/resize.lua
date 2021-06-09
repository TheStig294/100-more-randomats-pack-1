local EVENT = {}

CreateConVar("randomat_resize_min", 50, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Minimum possible size", 10, 200)

CreateConVar("randomat_resize_max", 200, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Maximum possible size", 50, 400)

EVENT.Title = "Resize!"
EVENT.Description = "Everyone's bigger/smaller, and has corresponding health"
EVENT.id = "resize"
local offsets = {}
local offsets_ducked = {}

function EVENT:Begin()
    -- Getting the set minimum and maximum size set by the convars
    local sizeMin = GetConVar("randomat_resize_min"):GetInt() / 100
    local sizeMax = GetConVar("randomat_resize_max"):GetInt() / 100

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
        ply:SetModelScale(1 * randomSize, 1)
        ply:SetViewOffset(Vector(0, 0, 64 * randomSize))
        ply:SetViewOffsetDucked(Vector(0, 0, 28 * randomSize))
        ply:SetHealth(ply:Health() * randomSize)
        ply:SetGravity(1 * randomSize)
    end
end

function EVENT:End()
    -- For all players,
    for i, ply in pairs(self:GetPlayers()) do
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

        -- Reset their model size and ability to jump
        ply:SetModelScale(1, 1)
        ply:SetGravity(1)
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