--[[
-- Randomat Addon that changes everyone's model to a random player's.
-- If the disguise names convar is active:
-- 1. Checks Custom Roles for TTT is installed and sends a net message to just hide player names on the client if so
-- 2. Else, sets everyone to be disguised (thus removing their names), if the convar is enabled, making everything more confusing! 
--    (hovering over people does not show their names because of the TTT disguise tool)
--
--    Note: Traitors can still see disguised people's names, because that's
--	  how the disguiser works as a traitor.
--
-- This event itself used to handle all the playermodel storing, but this conflicts with other playermodel
-- changing randomats that trigger on the same round.
-- It now uses my own function, which also bypasses the need for networking and the awkward timing that involves
--
-- Originally coded by Legendahkiin (https://steamcommunity.com/id/Legendahkiin/)
-- Overhauled and maintained by The Stig
--
--]]
util.AddNetworkString("DuncanEventRandomatHideNames")
util.AddNetworkString("DuncanEventRandomatEnd")

CreateConVar("randomat_duncanevent_disguise", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Hide player names")

local function GetDescription()
    local description = "Everyone has the same playermodel"

    if GetConVar("randomat_duncanevent_disguise"):GetBool() then
        description = description .. ", names are hidden"
    end

    description = description .. "!"

    return description
end

local EVENT = {}
EVENT.Title = ""
EVENT.id = "duncanevent"
EVENT.Description = GetDescription()
EVENT.AltTitle = "It's ..."

EVENT.Categories = {"largeimpact"}

function EVENT:Begin()
    self.Description = GetDescription()
    local chosenPly = table.Random(self:GetAlivePlayers())
    local chosenModel = chosenPly:GetModel()
    local chosenViewOffset = chosenPly:GetViewOffset()
    local chosenViewOffsetDucked = chosenPly:GetViewOffsetDucked()
    local chosenPlayerColour = chosenPly:GetPlayerColor()
    local chosenSkin = chosenPly:GetSkin()
    local chosenBodyGroups = chosenPly:GetBodyGroups()
    local chosenBodyGroupValues = {}

    for _, value in ipairs(chosenBodyGroups) do
        chosenBodyGroupValues[value] = chosenPly:GetBodygroup(value.id)
    end

    for k, ply in pairs(self:GetAlivePlayers()) do
        ForceSetPlayermodel(ply, chosenModel, chosenViewOffset, chosenViewOffsetDucked, chosenPlayerColour, chosenSkin, chosenBodyGroups, chosenBodyGroupValues)

        -- if name disguising is enabled...
        if not CR_VERSION and GetConVar("randomat_duncanevent_disguise"):GetBool() then
            -- Remove their names! Traitors still see names though!				
            ply:SetNWBool("disguised", true)
        end
    end

    Randomat:EventNotifySilent("It's " .. chosenPly:Nick() .. "!")

    if CR_VERSION and GetConVar("randomat_duncanevent_disguise"):GetBool() then
        net.Start("DuncanEventRandomatHideNames")
        net.Broadcast()
    end

    -- Sets someone's playermodel again when respawning
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            ForceSetPlayermodel(ply, chosenModel, chosenViewOffset, chosenViewOffsetDucked, chosenPlayerColour, chosenSkin, chosenBodyGroup, chosenPly)

            if not CR_VERSION and GetConVar("randomat_duncanevent_disguise"):GetBool() then
                ply:SetNWBool("disguised", true)
            end
        end)
    end)
end

function EVENT:End()
    if CR_VERSION then
        net.Start("DuncanEventRandomatEnd")
        net.Broadcast()
    end

    ForceResetAllPlayermodels()
end

function EVENT:GetConVars()
    local checks = {}

    for _, v in pairs({"disguise"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return {}, checks
end

Randomat:register(EVENT)