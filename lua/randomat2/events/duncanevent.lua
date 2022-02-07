--[[
-- Randomat Addon that changes everyone's model to a random player's.
-- When activated, the Randomat:
-- 1. Selects a random player
-- 2. Loops through every player
-- 3. Checks if they're alive and not in spectator
-- 4. Sets their viewmodel height (if it's different from normal viewmodel heights)
-- 5. Changes their model to the selected player's model
-- 6. Sets everyone to be disguised (thus removing their names) making everything more confusing! 
--    (hovering over people does not show their names because of the TTT disguise tool)
--
--    Note: Traitors can still see disguised people's names, because that's
--	  how the disguiser works as a traitor.
--
-- When the Randomat is deactivated, the Randomat:
-- 1. Resets cl_playermodel_selector_force to 1, since it makes people's skins stay
--    after the round is over.
--
-- The Randomat does not (?) need to store the previous models anywhere
-- This is because cl_playermodel stores the player-chosen skin, 
-- and upon respawning / dying the player's skin resets to cl_playermodel MODELNAME (thanks TTT / Enhanced Playermodel Selector)
-- Since we don't change cl_playermodel, we don't permanently change their skin, and it automatically resets
--
-- Coded by Legendahkiin (https://steamcommunity.com/id/Legendahkiin/)
--
--]]
-- the normal viewmodel offsets a playermodel's view is
local standardHeightVector = Vector(0, 0, 64)
local standardCrouchedHeightVector = Vector(0, 0, 28)
local playerModels = {}
local EVENT = {}
util.AddNetworkString("DuncanEventRandomatHideNames")
util.AddNetworkString("DuncanEventRandomatEnd")

CreateConVar("randomat_duncanevent_disguise", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Hide player names")

EVENT.Title = ""
EVENT.id = "duncanevent"
EVENT.Description = "Everyone has the same playermodel!"
EVENT.AltTitle = "It's ..."

function EVENT:Begin()
    if GetConVar("randomat_duncanevent_disguise"):GetBool() then
        self.Description = self.Description .. " Names are hidden"
    end

    -- We chose a random player out of all players (thanks google)
    local randomPly = table.Random(self:GetPlayers(true))
    -- Now we save that player's model like this...
    local chosenModel = randomPly:GetModel()
    -- and we use this to write "It's PLAYERNAME" (taken from suspicion.lua)
    Randomat:EventNotifySilent("It's " .. randomPly:Nick() .. "!")

    -- Gets all players...
    for k, v in pairs(self:GetPlayers()) do
        -- if they're alive and not in spectator mode
        if v:Alive() and not v:IsSpec() then
            -- and not a bot (bots do not have the following command, so it's unnecessary)
            if (not v:IsBot()) then
                -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                v:ConCommand("cl_playermodel_selector_force 0")
            end

            -- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
            timer.Simple(1, function()
                -- if the player's viewoffset is different than the standard, then...
                if not (v:GetViewOffset() == standardHeightVector) then
                    -- So we set their new heights to the default values (which the Duncan model uses)
                    v:SetViewOffset(standardHeightVector)
                    v:SetViewOffsetDucked(standardCrouchedHeightVector)
                end

                -- Set player number K (in the table) to their respective model
                playerModels[k] = v:GetModel()
                -- Sets their model to chosenModel
                v:SetModel(chosenModel)

                -- if name disguising is enabled...
                if not CR_VERSION and GetConVar("randomat_duncanevent_disguise"):GetBool() then
                    -- Remove their names! Traitors still see names though!				
                    v:SetNWBool("disguised", true)
                end
            end)
        end
    end

    if CR_VERSION and GetConVar("randomat_duncanevent_disguise"):GetBool() then
        net.Start("DuncanEventRandomatHideNames")
        net.Broadcast()
    end

    -- Sets someone's playermodel again when respawning, as force playermodel is off
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            ply:SetModel(chosenModel)

            if not CR_VERSION and GetConVar("randomat_duncanevent_disguise"):GetBool() then
                ply:SetNWBool("disguised", true)
            end
        end)
    end)
end

-- when the event ends, reset every player's model
function EVENT:End()
    -- loop through all players
    for k, v in pairs(self:GetPlayers()) do
        -- if the index k in the table playermodels has a model, then...
        if (playerModels[k] ~= nil) then
            -- we set the player v to the playermodel with index k in the table
            -- this should invoke the viewheight script from the models and fix viewoffsets (e.g. Zoey's model) 
            -- this does however first reset their viewmodel in the preparing phase (when they respawn)
            -- might be glitchy with pointshop items that allow you to get a viewoffset
            v:SetModel(playerModels[k])
        end

        -- we reset the cl_playermodel_selector_force to 1, otherwise TTT will reset their playermodels on a new round start (to default models!)
        v:ConCommand("cl_playermodel_selector_force 1")
        -- clear the model table to avoid setting wrong models (e.g. disconnected players)
        table.Empty(playerModels)
    end

    if CR_VERSION then
        net.Start("DuncanEventRandomatEnd")
        net.Broadcast()
    end
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

-- register the event in the randomat!
Randomat:register(EVENT)