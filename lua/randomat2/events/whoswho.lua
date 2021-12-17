local EVENT = {}
EVENT.Title = "Who's Who?"
EVENT.Description = "Everyone swaps playermodels"
EVENT.id = "whoswho"
local swapModels = {}
local playerModels = {}
local remainingModels = {}

function EVENT:Begin()
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
                -- Set player number K (in the table) to their respective model
                playerModels[k] = v:GetModel()
            end)
        end
    end

    timer.Simple(2, function()
        -- Initially add all player's models to the pool of models not yet picked
        table.Add(remainingModels, playerModels)

        -- For all alive players,
        for k, v in ipairs(self:GetPlayers()) do
            local ownModelRemoved = false
            local ownModel = playerModels[k]

            if table.HasValue(remainingModels, ownModel) then
                table.RemoveByValue(remainingModels, ownModel)
                ownModelRemoved = true
            end

            if table.IsEmpty(remainingModels) then
                for i, ply in ipairs(self:GetPlayers()) do
                    if v ~= ply then
                        local randomModel = ply:GetModel()
                        local lastPlayerModel = v:GetModel()
                        ply:SetModel(lastPlayerModel)
                        v:SetModel(randomModel)
                        break
                    end
                end
            else
                -- Randomly choose a playermodel that hasn't yet been chosen
                local chosenModel = table.Random(remainingModels)
                swapModels[v] = chosenModel
                -- Set them to that model
                v:SetModel(chosenModel)
                -- And remove that model from the pool of possible playermodels
                table.RemoveByValue(remainingModels, chosenModel)

                if ownModelRemoved then
                    table.insert(remainingModels, ownModel)
                end
            end
        end
    end)

    -- Whenever a player is respawned, set them to their swapped playermodel
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(0, function()
            if swapModels[ply] ~= nil then
                ply:SetModel(swapModels[ply])
            end
        end)
    end)
end

function EVENT:End()
    -- Clear the used tables for next time the randomat is triggered
    table.Empty(swapModels)
    table.Empty(remainingModels)

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
end

Randomat:register(EVENT)