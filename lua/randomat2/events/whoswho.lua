local EVENT = {}
EVENT.Title = "Who's Who?"
EVENT.Description = "Everyone swaps playermodels"
EVENT.id = "whoswho"

EVENT.Categories = {"modelchange", "fun", "largeimpact"}

local swapModels = {}
local playerModels = {}
local remainingModels = {}
local playermodelData = {}

function EVENT:Begin()
    for _, ply in pairs(self:GetAlivePlayers()) do
        playerModels[ply] = ply:GetModel()
        playermodelData[ply:GetModel()] = Randomat:GetPlayerModelData(ply)
    end

    -- Initially add all player's models to the pool of models not yet picked
    table.Add(remainingModels, playerModels)

    for _, ply in ipairs(self:GetAlivePlayers()) do
        local ownModelRemoved = false
        local ownModel = playerModels[ply]

        if table.HasValue(remainingModels, ownModel) then
            table.RemoveByValue(remainingModels, ownModel)
            ownModelRemoved = true
        end

        -- If the last player to have a model selected has noone to swap with (odd no. of alive players)
        -- then swap their model with another random player's
        if table.IsEmpty(remainingModels) then
            for _, rdmply in ipairs(self:GetAlivePlayers(true)) do
                if ply ~= rdmply then
                    Randomat:ForceSetPlayermodel(rdmply, Randomat:GetPlayerModelData(ply))
                    Randomat:ForceSetPlayermodel(ply, Randomat:GetPlayerModelData(rdmply))
                    break
                end
            end
        else
            -- Randomly choose a playermodel that hasn't yet been chosen
            local chosenModel = table.Random(remainingModels)
            -- Set them to that model
            Randomat:ForceSetPlayermodel(ply, playermodelData[chosenModel])
            -- Keep track of who received that playermodel
            swapModels[ply] = chosenModel
            -- And remove that model from the pool of possible playermodels
            table.RemoveByValue(remainingModels, chosenModel)

            if ownModelRemoved then
                table.insert(remainingModels, ownModel)
            end
        end
    end

    -- Whenever a player is respawned, set them to their swapped playermodel
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            if swapModels[ply] ~= nil then
                Randomat:ForceSetPlayermodel(ply, playermodelData[swapModels[ply]])
            end
        end)
    end)
end

function EVENT:End()
    -- Clear the used tables for next time the randomat is triggered
    table.Empty(swapModels)
    table.Empty(remainingModels)
    table.Empty(playerModels)
    table.Empty(playermodelData)
    Randomat:ForceResetAllPlayermodels()
end

Randomat:register(EVENT)