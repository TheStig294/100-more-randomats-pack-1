AddCSLuaFile()
local EVENT = {}

CreateConVar("randomat_resize_min", 50, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Minimum possible size", 10, 200)

CreateConVar("randomat_resize_max", 200, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Maximum possible size", 50, 400)

EVENT.Title = "Resize!"
EVENT.Description = "Everyone is larger or smaller, and has corresponding health"
EVENT.id = "resize"
---- Define Randomat ULX Table Entries --------------------------------------------
-- This follows the randomatULX table formula
local events = {}
events["resize"] = {}
events["resize"].name = "resize"
events["resize"].sdr = {}
slider = events["resize"].sdr
slider[1] = {}
slider[1].cmd = "min"
slider[1].dsc = "Smallest the player can become as % (def. 50%)"
slider[1].min = 0
slider[1].max = 1000
slider[2] = {}
slider[2].cmd = "max"
slider[2].dsc = "Biggest the player can become as % (def. 200%)"
slider[2].min = 0
slider[2].max = 1000

---- Commands to add to Randomat ULX command table --------------------------------
-- These must be created for all convars that the above sliders or checkboxs want to change
-- New section to allow for transfer of commands easily
events["resize"].commands = {"ttt_randomat_resize", "randomat_resize_min", "randomat_resize_max"}

local eventJSON = util.TableToJSON(events) -- Converts Table to string for sending
---- Check for Data File and our event --------------------------------------------
eventJSON = eventJSON .. "\n" -- Add the line end or shit breaks
local data = file.Read("randomataddons.txt", "DATA") -- Check for file, if it doesnt exist create it.

-- We do this here to check if we are the first addon
if not data then
    file.Write("randomataddons.txt", eventJSON) -- This also allows for easy deleting/refreshing of file
    print("[RANDOMAT] [RESIZE] No randomataddons file found, creating one")
end

data = file.Read("randomataddons.txt", "DATA") -- File still doesnt exist, must be an issue...
if not data then return end
print("[RANDOMAT] [RESIZE] Found randomataddons.txt")
local alreadyExists = false
local tabdata = string.Split(data, "\n") -- Store Table in JSON format to file for reading by randomatULX

-- However we need to check if our addon already exists in file
for _, line in ipairs(tabdata) do
    if line .. "\n" == eventJSON then
        print("[RANDOMAT] [RESIZE] Event found in randomataddons list")
        alreadyExists = true
    end
end

-- JSON Table not found in file, writing to file
if (not alreadyExists) then
    print("[RANDOMAT] [RESIZE] Did not find event in list, adding") -- PLS NOTE, if the table is altered it will add the entry again
    file.Append("randomataddons.txt", eventJSON)
end

----------------------------------------------------------------------
local offsets = {}
local offsets_ducked = {}

function EVENT:Begin()
    local sizeMin = tonumber(GetConVar("randomat_resize_min"):GetString()) / 100
    local sizeMax = tonumber(GetConVar("randomat_resize_max"):GetString()) / 100

    for i, ply in pairs(self:GetPlayers()) do
        if ply:IsValid() and ply:Alive() then
            if not offsets[ply:SteamID64()] then
                offsets[ply:SteamID64()] = ply:GetViewOffset()
            end

            if not offsets_ducked[ply:SteamID64()] then
                offsets_ducked[ply:SteamID64()] = ply:GetViewOffsetDucked()
            end

            local randomSize = math.Rand(sizeMin, sizeMax)
            ply:SetModelScale(1 * randomSize, 1)
            ply:SetViewOffset(Vector(0, 0, 64 * randomSize))
            ply:SetViewOffsetDucked(Vector(0, 0, 28 * randomSize))
            ply:SetHealth(ply:Health() * randomSize)
            ply:SetGravity(1 * randomSize)
        end
    end
end

function EVENT:End()
    for i, ply in pairs(self:GetPlayers()) do
        local offset = nil

        if offsets[ply:SteamID64()] then
            offset = offsets[ply:SteamID64()]
            offsets[ply:SteamID64()] = nil
        end

        if offset or not ply.ec_ViewChanged then
            ply:SetViewOffset(offset or Vector(0, 0, 64))
        end

        local offset_ducked = nil

        if offsets_ducked[ply:SteamID64()] then
            offset_ducked = offsets_ducked[ply:SteamID64()]
            offsets_ducked[ply:SteamID64()] = nil
        end

        if offset_ducked or not ply.ec_ViewChanged then
            ply:SetViewOffsetDucked(offset_ducked or Vector(0, 0, 28))
        end

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