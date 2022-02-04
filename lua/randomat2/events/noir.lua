local standardHeightVector = Vector(0, 0, 64)
local standardCrouchedHeightVector = Vector(0, 0, 28)
local playerModels = {}
local modelExists = file.Exists("models/player/jenssons/kermit.mdl", "THIRDPARTY")
local eventnames = {}
table.insert(eventnames, "It was a case like any other...")
table.insert(eventnames, "Rain dripped down from the dark sky...")
table.insert(eventnames, "That's the thing about this city...")
table.insert(eventnames, "The dame was there under the streetlight...")
table.insert(eventnames, "I sat in the office, knowing those traitors were somewhere...")
table.insert(eventnames, "The case was growing cold...")
table.insert(eventnames, "The rain fell like dead bullets...")
table.insert(eventnames, "I sat in the hotel room, as I contemplated my next move...")
table.insert(eventnames, "I was there in the smoke-filled bar...")
table.insert(eventnames, "I saw him standing in the cold alleyway...")
local EVENT = {}
EVENT.Title = table.Random(eventnames)
EVENT.AltTitle = "Noir"
EVENT.id = "noir"
util.AddNetworkString("randomat_noir")
util.AddNetworkString("randomat_noir_end")

local noirMusic = {Sound("noir/deadly_roulette.mp3"), Sound("noir/walking_along.mp3"), Sound("noir/bass_walker.mp3")}

CreateConVar("randomat_noir_music", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Play music during this randomat", 0, 1)

function EVENT:Begin()
    noirRandomat = true

    -- Remove all weapons on players and the ground that take up the pistol slot
    for _, ent in pairs(ents.GetAll()) do
        if (ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY) and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    -- Give players a revolver
    for k, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:SetFOV(0, 0.2)
            ply:Give("weapon_ttt_revolver_randomat")
            ply:SelectWeapon("weapon_ttt_revolver_randomat")
        end)
    end

    local chosenMusic = noirMusic[math.random(1, #noirMusic)]
    -- Apply black-and-white filter and start music
    net.Start("randomat_noir")
    net.WriteBool(GetConVar("randomat_noir_music"):GetBool())
    net.WriteString(chosenMusic)
    net.Broadcast()

    if modelExists then
        for k, ply in pairs(player.GetAll()) do
            -- bots do not have the following command, so it's unnecessary
            if not ply:IsBot() then
                -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                ply:ConCommand("cl_playermodel_selector_force 0")
            end

            -- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
            timer.Simple(1, function()
                -- if the player's viewoffset is different than the standard, then...
                if ply:GetViewOffset() ~= standardHeightVector then
                    -- So we set their new heights to the default values
                    ply:SetViewOffset(standardHeightVector)
                    ply:SetViewOffsetDucked(standardCrouchedHeightVector)
                end

                -- Set player number K (in the table) to their respective model
                playerModels[k] = ply:GetModel()
                -- Sets their model to chosenModel
                ply:SetModel("models/player/jenssons/kermit.mdl")
            end)
        end
    end
end

function EVENT:End()
    -- Checking if the randomat has run before trying to remove the greyscale effect, else causes an error
    if noirRandomat then
        net.Start("randomat_noir_end")
        net.Broadcast()

        if modelExists then
            -- loop through all players
            for k, ply in pairs(player.GetAll()) do
                -- if the index k in the table playermodels has a model, then...
                if (playerModels[k] ~= nil) then
                    -- we set the player ply to the playermodel with index k in the table
                    -- this should invoke the viewheight script from the models and fix viewoffsets (e.g. Zoey's model) 
                    -- this does however first reset their viewmodel in the preparing phase (when they respawn)
                    -- might be glitchy with pointshop items that allow you to get a viewoffset
                    ply:SetModel(playerModels[k])
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
    local checkboxes = {}

    for _, v in pairs({"music"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checkboxes, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return nil, checkboxes
end

Randomat:register(EVENT)