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

local disguiseCvar = CreateConVar("randomat_duncanevent_disguise", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Hide player names")

local announceCvar = CreateConVar("randomat_duncanevent_announce_player", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Announce player's model being used")

local function GetDescription()
    local description = "Everyone has the same playermodel"

    if disguiseCvar:GetBool() then
        description = description .. ", names are hidden"
    end

    description = description .. "!"

    return description
end

local function GetTitle()
    local title = ""

    if not announceCvar:GetBool() then
        title = "It's Duncan!"
    end

    return title
end

local EVENT = {}
EVENT.Title = GetTitle()
EVENT.id = "duncanevent"
EVENT.Description = GetDescription()
EVENT.AltTitle = "It's ..."

EVENT.Categories = {"modelchange", "largeimpact"}

function EVENT:Begin()
    self.Description = GetDescription()
    self.Title = GetTitle()
    local alivePlys = self:GetAlivePlayers(true)
    local chosenPly = alivePlys[1]
    local chosenPlyModelData = Randomat:GetPlayerModelData(chosenPly)
    local disguise = disguiseCvar:GetBool()

    for k, ply in pairs(alivePlys) do
        Randomat:ForceSetPlayermodel(ply, chosenPlyModelData)

        if not CR_VERSION and disguise then
            -- If CR is not installed, use the fallback method of hiding names by using TTT's in-built disguiser functionality
            -- Unfortunately, this will mean that traitors can still see everyone's names, as that's how the disguiser works
            ply:SetNWBool("disguised", true)
        end
    end

    if announceCvar:GetBool() then
        Randomat:EventNotifySilent("It's " .. chosenPly:Nick() .. "!")
    end

    if CR_VERSION and disguise then
        net.Start("DuncanEventRandomatHideNames")
        net.WriteBool(disguise)
        net.Broadcast()
    end

    -- Sets someone's playermodel again when respawning
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            Randomat:ForceSetPlayermodel(ply, chosenPlyModelData)

            if not CR_VERSION and disguise then
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

    Randomat:ForceResetAllPlayermodels()
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