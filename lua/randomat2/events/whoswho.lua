local EVENT = {}
EVENT.Title = "Who's Who?"
EVENT.Description = "Everyone swaps playermodels"
EVENT.id = "whoswho"
local swapModels = {}
local playerModels = {}
local remainingModels = {}
local viewOffsets = {}
local viewOffsetsDucked = {}

function EVENT:Begin()
    for _, ply in pairs(self:GetAlivePlayers()) do
        playerModels[ply] = ply:GetModel()
        viewOffsets[ply:GetModel()] = ply:GetViewOffset()
        viewOffsetsDucked[ply:GetModel()] = ply:GetViewOffsetDucked()
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
                    local randomModel = rdmply:GetModel()
                    local randomViewOffset = rdmply:GetViewOffset()
                    local randomViewOffsetDucked = rdmply:GetViewOffsetDucked()
                    local lastPlayerModel = ply:GetModel()
                    local lastPlayerViewOffset = ply:GetViewOffset()
                    local lastPlayerViewOffsetDucked = ply:GetViewOffsetDucked()
                    ForceSetPlayermodel(rdmply, lastPlayerModel, lastPlayerViewOffset, lastPlayerViewOffsetDucked)
                    ForceSetPlayermodel(ply, randomModel, randomViewOffset, randomViewOffsetDucked)
                    break
                end
            end
        else
            -- Randomly choose a playermodel that hasn't yet been chosen
            local chosenModel = table.Random(remainingModels)
            -- Set them to that model
            ForceSetPlayermodel(ply, chosenModel, viewOffsets[chosenModel], viewOffsetsDucked[chosenModel])
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
                ForceSetPlayermodel(ply, swapModels[ply], viewOffsets[swapModels[ply]], viewOffsetsDucked[swapModels[ply]])
            end
        end)
    end)
end

function EVENT:End()
    -- Clear the used tables for next time the randomat is triggered
    table.Empty(swapModels)
    table.Empty(remainingModels)
    table.Empty(playerModels)
    table.Empty(viewOffsets)
    table.Empty(viewOffsetsDucked)
    ForceResetAllPlayermodels()
end

Randomat:register(EVENT)