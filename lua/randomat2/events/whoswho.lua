AddCSLuaFile()
local EVENT = {}
EVENT.Title = "Who's Who?"
EVENT.Description = "Everyone swaps playermodels"
EVENT.id = "whoswho"
---- Define Randomat ULX Table Entries --------------------------------------------
-- This follows the randomatULX table formula
-- If you cant figure out how it should be layed out you probably shouldnt be here...
local events = {}
events["whoswho"] = {}
events["whoswho"].name = "whoswho"
events["whoswho"].sdr = {}
slider = events["whoswho"].sdr
slider[1] = {}
slider[1].cmd = "min"
slider[1].dsc = "Min time before whoswho runs (def. 15)"
slider[1].min = "1"
slider[1].max = "120"
slider[2] = {}
slider[2].cmd = "max"
slider[2].dsc = "Max time before whoswho runs (def. 30)"
slider[2].min = "10"
slider[2].max = "240"
events["whoswho"].chk = {}
check = events["whoswho"].chk
check[1] = {}
check[1].cmd = "repetition"
check[1].dsc = "Should we stop the playermodel repeating (def 1))"
events["whoswho"].chk = {}
check = events["whoswho"].chk
check[2] = {}
check[2].cmd = "disguised"
check[2].dsc = "Should we disguise the player to hide names (def. 1)"

---- Commands to add to Randomat ULX command table --------------------------------
--These must be created for all convars that
--the above sliders or checkboxs want to change
-- New section to allow for transfer of commands easily
events["whoswho"].commands = {"ttt_randomat_whoswho", "randomat_whoswho_min", "randomat_whoswho_max", "randomat_whoswho_repetition", "randomat_whoswho_disguised",}

local eventJSON = util.TableToJSON(events) -- Converts Table to string for sending
---- Check for Data File and our event --------------------------------------------
eventJSON = eventJSON .. "\n" -- Add the line end or shit breaks
local data = file.Read("randomataddons.txt", "DATA") -- Check for file, if it doesnt exist create it.

-- We do this here to check if we are the first addon
if not data then
    file.Write("randomataddons.txt", eventJSON) -- This also allows for easy deleting/refreshing of file
    print("[RANDOMAT] [WHOS WHO] No randomataddons file found, creating one")
end

data = file.Read("randomataddons.txt", "DATA") -- File still doesnt exist, must be an issue...
if not data then return end
print("[RANDOMAT] [WHOS WHO] Found randomataddons.txt")
local alreadyExists = false
local tabdata = string.Split(data, "\n") -- Store Table in JSON format to file for reading by randomatULX

-- However we need to check if our addon already exists in file
for _, line in ipairs(tabdata) do
    if line .. "\n" == eventJSON then
        print("[RANDOMAT] [WHOS WHO] Event found in randomataddons list")
        alreadyExists = true
    end
end

-- JSON Table not found in file, writing to file
if (not alreadyExists) then
    print("[RANDOMAT] [WHOS WHO] Did not find event in list, adding") -- PLS NOTE, if the table is altered it will add the entry again
    file.Append("randomataddons.txt", eventJSON)
end

----------------------------------------------------------------------
local swapModels = {}
local playerModels = {}
local remainingModels = {}

function EVENT:Begin()
    -- Gets all players...
    for k, v in pairs(player.GetAll()) do
        -- if they're alive and not in spectator mode
        if v:Alive() and not v:IsSpec() then
            -- and not a bot (bots do not have the following command, so it's unnecessary)
            if (not v:IsBot()) then
                -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                v:ConCommand("cl_playermodel_selector_force 0")
            end

            -- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
            timer.Simple(1, function()
                -- Set player number K (in the table) to their respective model
                playerModels[k] = v:GetModel()
            end)
        end
    end

    timer.Simple(2, function()
        table.Add(remainingModels, playerModels)

        for k, v in pairs(player.GetAll()) do
            local chosenModel = table.Random(remainingModels)
            swapModels[v] = chosenModel
            v:SetModel(chosenModel)
            table.RemoveByValue(remainingModels, chosenModel)
        end
    end)

    self:AddHook("PlayerSetModel", function(ply)
        timer.Simple(0.1, function()
            ply:SetModel(swapModels[ply])
        end)
    end)
end

function EVENT:End()
    table.Empty(swapModels)
    table.Empty(remainingModels)

    -- loop through all players
    for k, v in pairs(player.GetAll()) do
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
end

Randomat:register(EVENT)