local EVENT = {}
EVENT.Title = "Blegh"
EVENT.Description = "Everyone hears a 'Blegh!' sound when someone dies"
local plushSharkModel = "models/bradyjharty/yogscast/sharky.mdl"

if util.IsValidModel(plushSharkModel) then
    EVENT.Description = "Make a 'Blegh!' sound when you die, everyone is a sharky!"
end

EVENT.id = "bleghsound"

EVENT.Categories = {"deathtrigger", "smallimpact", "biased_innocent", "biased"}

util.AddNetworkString("BleghRandomatSound")

function EVENT:Begin()
    -- Plays a randoman blegh sound whenever someone dies
    local bleghSounds = {"bleghsound/blegh1.mp3", "bleghsound/blegh2.mp3", "bleghsound/blegh3.mp3", "bleghsound/blegh4.mp3", "bleghsound/blegh5.mp3", "bleghsound/blegh6.mp3", "bleghsound/blegh7.mp3"}

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        -- Silence the usual death noise
        dmginfo:SetDamageType(DMG_SLASH)
        local deathSound = bleghSounds[math.random(1, #bleghSounds)]
        net.Start("BleghRandomatSound")
        net.WriteString(deathSound)
        net.Broadcast()
    end)

    if util.IsValidModel(plushSharkModel) then
        -- Gives everyone a random sharky playermodel, if installed
        local plushSharkOffset = Vector(0, 0, 40)
        local plushSharkOffsetDucked = Vector(0, 0, 28)
        local playerModelSets = {}

        local pirate = {
            model = plushSharkModel,
            viewOffset = plushSharkOffset,
            viewOffsetDucked = plushSharkOffsetDucked,
            skin = 1,
            playerColor = Color(255, 255, 255):ToVector(),
            bodygroupValues = {
                [0] = 3,
                [1] = 1,
                [2] = 5,
                [3] = 1,
                [4] = 0,
                [5] = 4,
                [6] = 0,
                [7] = 0,
                [8] = 0
            }
        }

        table.insert(playerModelSets, pirate)

        local executioner = {
            model = plushSharkModel,
            viewOffset = plushSharkOffset,
            viewOffsetDucked = plushSharkOffsetDucked,
            skin = 1,
            playerColor = Color(100, 100, 100):ToVector(),
            bodygroupValues = {
                [0] = 2,
                [1] = 0,
                [2] = 3,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 1,
                [7] = 1,
                [8] = 1
            }
        }

        table.insert(playerModelSets, executioner)

        local christmas = {
            model = plushSharkModel,
            viewOffset = plushSharkOffset,
            viewOffsetDucked = plushSharkOffsetDucked,
            playerColor = Color(255, 0, 0):ToVector(),
            skin = 1,
            bodygroupValues = {
                [0] = 4,
                [1] = 0,
                [2] = 1,
                [3] = 0,
                [4] = 3,
                [5] = 5,
                [6] = 0,
                [7] = 0,
                [8] = 0
            }
        }

        table.insert(playerModelSets, christmas)

        local original = {
            model = plushSharkModel,
            viewOffset = plushSharkOffset,
            viewOffsetDucked = plushSharkOffsetDucked,
            playerColor = Color(255, 255, 255):ToVector(),
            skin = 0,
            bodygroupValues = {
                [0] = 0,
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 4,
                [5] = 0,
                [6] = 0,
                [7] = 0,
                [8] = 0
            }
        }

        table.insert(playerModelSets, original)

        local zombie = {
            model = plushSharkModel,
            viewOffset = plushSharkOffset,
            viewOffsetDucked = plushSharkOffsetDucked,
            playerColor = Color(25, 100, 0):ToVector(),
            skin = 1,
            bodygroupValues = {
                [0] = 1,
                [1] = 1,
                [2] = 1,
                [3] = 1,
                [4] = 2,
                [5] = 5,
                [6] = 0,
                [7] = 0,
                [8] = 0
            }
        }

        table.insert(playerModelSets, zombie)

        local rainbow = {
            model = plushSharkModel,
            viewOffset = plushSharkOffset,
            viewOffsetDucked = plushSharkOffsetDucked,
            playerColor = Color(255, 0, 0):ToVector(),
            skin = 1,
            bodygroupValues = {
                [0] = 0,
                [1] = 2,
                [2] = 2,
                [3] = 0,
                [4] = 0,
                [5] = 5,
                [6] = 0,
                [7] = 0,
                [8] = 0
            }
        }

        table.insert(playerModelSets, rainbow)

        -- The original left shark playermodel can also be given, if it's installed as well
        if util.IsValidModel("models/freeman/player/left_shark.mdl") then
            local ogLeftShark = {
                model = "models/freeman/player/left_shark.mdl",
                skin = 1
            }

            table.insert(playerModelSets, ogLeftShark)
        end

        -- Randomly assign unique playermodels to everyone
        local remainingPlayermodels = {}
        local chosenPlayermodels = {}
        table.Add(remainingPlayermodels, playerModelSets)

        for _, ply in ipairs(self:GetAlivePlayers()) do
            -- But if all playermodels have been used, reset the pool of playermodels
            if table.IsEmpty(remainingPlayermodels) then
                table.Add(remainingPlayermodels, playerModelSets)
            end

            local modelData = table.Random(remainingPlayermodels)
            ForceSetPlayermodel(ply, modelData)
            -- Remove the selected model from the pool
            table.RemoveByValue(remainingPlayermodels, modelData)
            -- Keep track of who got what model so it can be set when they respawn
            chosenPlayermodels[ply] = modelData
        end

        -- Sets someone's playermodel again when respawning,
        -- if they weren't in the round when the event triggered, set their chosen model to a random one
        self:AddHook("PlayerSpawn", function(ply)
            if not chosenPlayermodels[ply] then
                chosenPlayermodels[ply] = table.Random(playerModelSets)
            end

            timer.Simple(1, function()
                ForceSetPlayermodel(ply, chosenPlayermodels[ply])
            end)
        end)

        -- Rainbow Sharky logic to change colours over time
        local rainbowPhase = 1

        self:AddHook("Think", function()
            for _, ply in ipairs(self:GetAlivePlayers()) do
                if chosenPlayermodels[ply] == rainbow then
                    local vector = ply:GetPlayerColor()

                    if rainbowPhase == 1 then
                        vector.z = vector.z + (1 / 128)

                        if vector.z + (1 / 128) > 1 then
                            vector.z = 1
                            rainbowPhase = rainbowPhase + 1
                        end
                    elseif rainbowPhase == 2 then
                        vector.x = vector.x - (1 / 128)

                        if vector.x - (1 / 128) < 0 then
                            vector.x = 0
                            rainbowPhase = rainbowPhase + 1
                        end
                    elseif rainbowPhase == 3 then
                        vector.y = vector.y + (1 / 128)

                        if vector.y + (1 / 128) > 1 then
                            vector.y = 1
                            rainbowPhase = rainbowPhase + 1
                        end
                    elseif rainbowPhase == 4 then
                        vector.z = vector.z - (1 / 128)

                        if vector.z - (1 / 128) < 0 then
                            vector.z = 0
                            rainbowPhase = rainbowPhase + 1
                        end
                    elseif rainbowPhase == 5 then
                        vector.x = vector.x + (1 / 128)

                        if vector.x + (1 / 128) > 1 then
                            vector.x = 1
                            rainbowPhase = rainbowPhase + 1
                        end
                    elseif rainbowPhase == 6 then
                        vector.y = vector.y - (1 / 128)

                        if vector.y - (1 / 128) < 0 then
                            vector.y = 0
                            rainbowPhase = 1
                        end
                    end

                    ply:SetPlayerColor(vector)
                end
            end
        end)
    end
end

function EVENT:End()
    ForceResetAllPlayermodels()
end

Randomat:register(EVENT)