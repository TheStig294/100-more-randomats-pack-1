local EVENT = {}
EVENT.Title = "Blegh"
EVENT.Description = "Everyone hears a 'Blegh!' sound when someone dies"
local plushSharkModel = "models/bradyjharty/yogscast/sharky.mdl"

if util.IsValidModel(plushSharkModel) then
    EVENT.Description = "Make a 'Blegh!' sound when you die, everyone is sharky!"
end

EVENT.id = "bleghsound"

EVENT.Categories = {"deathtrigger", "smallimpact", "biased_innocent", "biased"}

function EVENT:Begin()
    -- Plays a randoman blegh sound whenever someone dies
    util.AddNetworkString("RandomatBleghSound")

    local bleghSounds = {"bleghsound/blegh1.mp3", "bleghsound/blegh2.mp3", "bleghsound/blegh3.mp3", "bleghsound/blegh4.mp3", "bleghsound/blegh5.mp3", "bleghsound/blegh6.mp3", "bleghsound/blegh7.mp3"}

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        -- Silence the usual death noise
        dmginfo:SetDamageType(DMG_SLASH)
        local deathSound = bleghSounds[math.random(1, #bleghSounds)]
        net.Start("RandomatBleghSound")
        net.WriteString(deathSound)
        net.Broadcast()
    end)

    -- Gives everyone a random sharky playermodel, if installed
    local plushSharkOffset = Vector(0, 0, 40)
    local plushSharkOffsetDucked = Vector(0, 0, 28)
    local playermodelSets = {}

    if util.IsValidModel(plushSharkModel) then
        -- Space marine sharky
        local sharky1 = {}
        sharky1.model = plushSharkModel
        sharky1.viewOffset = plushSharkOffset
        sharky1.viewOffsetDucked = plushSharkOffsetDucked
        sharky1.skin = 3
        sharky1.bodygroupValues = {}
        sharky1.playerColor = Color(5, 64, 140):ToVector()
        sharky1.bodygroupValues[0] = 0
        sharky1.bodygroupValues[1] = 1
        sharky1.bodygroupValues[2] = 0
        sharky1.bodygroupValues[3] = 0
        sharky1.bodygroupValues[4] = 0
        sharky1.bodygroupValues[5] = 1
        sharky1.bodygroupValues[6] = 1
        table.insert(playermodelSets, sharky1)
        -- Christmas Sharky
        local sharky2 = {}
        sharky2.model = plushSharkModel
        sharky2.viewOffset = plushSharkOffset
        sharky2.viewOffsetDucked = plushSharkOffsetDucked
        sharky2.playerColor = Color(176, 33, 33):ToVector()
        sharky2.skin = 1
        sharky2.bodygroupValues = {}
        sharky2.bodygroupValues[0] = 0
        sharky2.bodygroupValues[1] = 4
        sharky2.bodygroupValues[2] = 2
        sharky2.bodygroupValues[3] = 1
        sharky2.bodygroupValues[4] = 0
        sharky2.bodygroupValues[5] = 0
        sharky2.bodygroupValues[6] = 0
        table.insert(playermodelSets, sharky2)
        -- Drunk lifevest sharky
        local sharky3 = {}
        sharky3.model = plushSharkModel
        sharky3.viewOffset = plushSharkOffset
        sharky3.viewOffsetDucked = plushSharkOffsetDucked
        sharky3.playerColor = Color(61, 87, 105):ToVector()
        sharky3.skin = 5
        sharky3.bodygroupValues = {}
        sharky3.bodygroupValues[0] = 0
        sharky3.bodygroupValues[1] = 2
        sharky3.bodygroupValues[2] = 0
        sharky3.bodygroupValues[3] = 1
        sharky3.bodygroupValues[4] = 0
        sharky3.bodygroupValues[5] = 0
        sharky3.bodygroupValues[6] = 0
        table.insert(playermodelSets, sharky3)
        -- Pirate Sharky
        local sharky4 = {}
        sharky4.model = plushSharkModel
        sharky4.viewOffset = plushSharkOffset
        sharky4.viewOffsetDucked = plushSharkOffsetDucked
        sharky4.playerColor = Color(109, 109, 109):ToVector()
        sharky4.skin = 3
        sharky4.bodygroupValues = {}
        sharky4.bodygroupValues[0] = 0
        sharky4.bodygroupValues[1] = 3
        sharky4.bodygroupValues[2] = 1
        sharky4.bodygroupValues[3] = 2
        sharky4.bodygroupValues[4] = 0
        sharky4.bodygroupValues[5] = 0
        sharky4.bodygroupValues[6] = 0
        table.insert(playermodelSets, sharky4)
        -- Ben in mouth
        local sharky5 = {}
        sharky5.model = plushSharkModel
        sharky5.viewOffset = plushSharkOffset
        sharky5.viewOffsetDucked = plushSharkOffsetDucked
        sharky5.skin = 0
        sharky5.bodygroupValues = {}
        sharky5.bodygroupValues[0] = 0
        sharky5.bodygroupValues[1] = 0
        sharky5.bodygroupValues[2] = 0
        sharky5.bodygroupValues[3] = 1
        sharky5.bodygroupValues[4] = 1
        sharky5.bodygroupValues[5] = 0
        sharky5.bodygroupValues[6] = 0
        table.insert(playermodelSets, sharky5)
        -- OG Plush Sharky
        local sharky6 = {}
        sharky6.model = plushSharkModel
        sharky6.viewOffset = plushSharkOffset
        sharky6.viewOffsetDucked = plushSharkOffsetDucked
        sharky6.skin = 0
        sharky6.bodygroupValues = {}
        sharky6.bodygroupValues[0] = 0
        sharky6.bodygroupValues[1] = 0
        sharky6.bodygroupValues[2] = 0
        sharky6.bodygroupValues[3] = 0
        sharky6.bodygroupValues[4] = 0
        sharky6.bodygroupValues[5] = 0
        sharky6.bodygroupValues[6] = 0
        table.insert(playermodelSets, sharky6)

        -- OG Left Shark
        if util.IsValidModel("models/freeman/player/left_shark.mdl") then
            local sharky7 = {}
            sharky7.model = "models/freeman/player/left_shark.mdl"
            sharky7.skin = 1
            table.insert(playermodelSets, sharky7)
        end

        local playermodelIDs = {}

        for _, ply in ipairs(self:GetAlivePlayers()) do
            local playermodelID = math.random(1, #playermodelSets)
            playermodelIDs[ply] = playermodelID
            ForceSetPlayermodel(ply, playermodelSets[playermodelID])
        end

        -- Sets someone's playermodel again when respawning
        self:AddHook("PlayerSpawn", function(ply)
            timer.Simple(1, function()
                ForceSetPlayermodel(ply, playermodelSets[playermodelIDs[ply]])
            end)
        end)
    end
end

function EVENT:End()
    ForceResetAllPlayermodels()
end

Randomat:register(EVENT)