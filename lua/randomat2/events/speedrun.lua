local EVENT = {}

CreateConVar("randomat_speedrun_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Time in seconds the round will last", 30, 120)

EVENT.Title = "Speedrun!"
EVENT.Description = GetConVar("randomat_speedrun_time"):GetInt() .. " second round"
EVENT.id = "speedrun"
local speedrunRandomat = false
local hasteMode = false
local hasteMinutes = 0.5
local standardHeightVector = Vector(0, 0, 64)
local standardCrouchedHeightVector = Vector(0, 0, 28)
local playerModels = {}
local modelExists = util.IsValidModel("models/vinrax/player/mgs_solid_snake.mdl")

function EVENT:Begin()
    speedrunRandomat = true
    hasteMode = GetConVar("ttt_haste"):GetBool()
    hasteMinutes = GetConVar("ttt_haste_minutes_per_death"):GetFloat()
    local time = GetConVar("randomat_speedrun_time"):GetInt()
    self.Description = time .. " second round"

    -- This global float controls the time the round will end, part of base TTT
    if hasteMode then
        GetConVar("ttt_haste"):SetBool(false)
        GetConVar("ttt_haste_minutes_per_death"):SetFloat(0)
        SetGlobalFloat("ttt_haste_end", CurTime() + time)
        SetGlobalFloat("ttt_round_end", CurTime() + time)
    else
        SetGlobalFloat("ttt_round_end", CurTime() + time)
    end

    if modelExists then
        for i, ply in ipairs(self:GetAlivePlayers()) do
            if ply:GetModel() == "models/bna/michiru.mdl" or ply:Nick() == "boba" then
                if (not ply:IsBot()) then
                    -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                    ply:ConCommand("cl_playermodel_selector_force 0")
                end

                -- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
                timer.Simple(1, function()
                    -- if the player's viewoffset is different than the standard, then...
                    if ply:GetViewOffset() ~= standardHeightVector then
                        -- So we set their new heights to the default values (which the Duncan model uses)
                        ply:SetViewOffset(standardHeightVector)
                        ply:SetViewOffsetDucked(standardCrouchedHeightVector)
                    end

                    playerModels[ply] = ply:GetModel()
                    -- Sets their model to chosenModel
                    ply:SetModel("models/vinrax/player/mgs_solid_snake.mdl")
                    ply:ChatPrint("You share the same name or playermodel as a world-famous speedrunner.\nYour playermodel has changed for this round...")
                end)
            end
        end
    end
end

function EVENT:End()
    if speedrunRandomat then
        if hasteMode then
            GetConVar("ttt_haste"):SetBool(true)
            GetConVar("ttt_haste_minutes_per_death"):SetFloat(hasteMinutes)
        end

        -- And prevent the end function from being run until this randomat triggers again
        speedrunRandomat = false

        if modelExists then
            -- loop through all players
            for k, ply in pairs(player.GetAll()) do
                -- if the index k in the table playermodels has a model, then...
                if (playerModels[ply] ~= nil) then
                    -- we set the player ply to the playermodel with index k in the table
                    -- this should invoke the viewheight script from the models and fix viewoffsets (e.g. Zoey's model) 
                    -- this does however first reset their viewmodel in the preparing phase (when they respawn)
                    -- might be glitchy with pointshop items that allow you to get a viewoffset
                    ply:SetModel(playerModels[ply])
                end

                -- we reset the cl_playermodel_selector_force to 1, otherwise TTT will reset their playermodels on a new round start (to default models!)
                ply:ConCommand("cl_playermodel_selector_force 1")
                -- clear the model table to avoid setting wrong models (e.g. disconnected players)
                table.Empty(playerModels)
            end
        end
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"time"}) do
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