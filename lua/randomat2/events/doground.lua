local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Fetch me their souls..."
EVENT.id = "doground"

EVENT.Categories = {"biased_traitor", "biased", "entityspawn", "largeimpact"}

EVENT.ZombieSpawns = {}
EVENT.PlayerPositions = {}
EVENT.ChosenSpawns = 0
EVENT.SpawnCap = 0

local fogDist = CreateConVar("randomat_doground_fogdist", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Fog distance multiplier", 0.2, 5)

util.AddNetworkString("DogRoundRandomatBegin")
util.AddNetworkString("DogRoundRandomatPlaySound")
util.AddNetworkString("DogRoundRandomatRemoveFog")
util.AddNetworkString("DogRoundRandomatEnd")

function EVENT:ConsiderEntityAsSpawnPoint(ent)
    if self.ChosenSpawns >= self.SpawnCap then return end
    local pos = ent:GetPos()

    if not IsValid(ent:GetParent()) then
        local tooClose = false

        for _, plyPos in ipairs(self.PlayerPositions) do
            -- 100 * 100 = 10,000, so any zombies closer than 100 source units to the player are too close to be placed
            if math.DistanceSqr(pos.x, pos.y, plyPos.x, plyPos.y) < 10000 then
                tooClose = true
                break
            end
        end

        if not tooClose then
            table.insert(self.ZombieSpawns, pos)
            self.ChosenSpawns = self.ChosenSpawns + 1
        end
    end
end

function EVENT:GetEntitySpawnPoints()
    -- First search through all info_player_* ents, which tend to give spots with enough room as they are player spawn points
    for _, ent in RandomPairs(ents.FindByClass("info_player_*")) do
        self:ConsiderEntityAsSpawnPoint(ent)
        if self.ChosenSpawns >= self.SpawnCap then return end
    end

    -- Next try to search through all info_* ents, which still tend to give better spots that weapons/ammo
    for _, ent in RandomPairs(ents.FindByClass("info_*")) do
        self:ConsiderEntityAsSpawnPoint(ent)
        if self.ChosenSpawns >= self.SpawnCap then return end
    end

    -- Last resort, choose the positions of weapons/ammo
    for _, ent in RandomPairs(ents.FindByClass("weapon_*")) do
        self:ConsiderEntityAsSpawnPoint(ent)
        if self.ChosenSpawns >= self.SpawnCap then return end
    end

    for _, ent in RandomPairs(ents.FindByClass("item_*")) do
        self:ConsiderEntityAsSpawnPoint(ent)
        if self.ChosenSpawns >= self.SpawnCap then return end
    end
end

function EVENT:SpawnZombie(spawnIndex)
    -- Plays the lightning sound effect on all clients
    net.Start("DogRoundRandomatPlaySound")
    net.WriteString("doground/spawn.mp3")
    net.Broadcast()

    -- Spawns the zombie in time with the sound effect
    timer.Simple(1.577, function()
        if self.ZombieSpawns[spawnIndex] then
            local pos = self.ZombieSpawns[spawnIndex] + Vector(0, 10, 0)
            local lightningEffect = EffectData()
            lightningEffect:SetOrigin(pos)
            lightningEffect:SetMagnitude(20)
            lightningEffect:SetScale(2)
            lightningEffect:SetRadius(10)
            util.Effect("Sparks", lightningEffect, true, true)
            util.ScreenShake(self.ZombieSpawns[spawnIndex], 30, 100, 0.5, 5000)

            -- Actually spawn the zombie a split-second after the lightning effect so the zombie isn't seen before the effect
            timer.Simple(0.2, function()
                local zombie = ents.Create("npc_fastzombie")
                zombie:SetPos(pos)
                zombie:Spawn()
                zombie:PhysWake()
            end)
        end
    end)
end

function EVENT:EndDogRound()
    -- Plays the ending sound effect on all clients
    net.Start("DogRoundRandomatPlaySound")
    net.WriteString("doground/doground_end.mp3")
    net.Broadcast()

    timer.Simple(5, function()
        Randomat:EventNotifySilent("Max Ammo!")

        if Randomat:CanEventRun("ammo") then
            Randomat:SilentTriggerEvent("ammo")
        end
    end)

    timer.Simple(10, function()
        net.Start("DogRoundRandomatRemoveFog")
        net.Broadcast()
    end)
end

function EVENT:Begin()
    net.Start("DogRoundRandomatBegin")
    net.WriteFloat(fogDist:GetFloat())
    net.Broadcast()

    -- Displays the title of this event without playing the usual randomat start sound, after a delay
    timer.Create("DogRoundRandomatAlert", 4.2, 1, function()
        Randomat:EventNotifySilent(self.AltTitle)
    end)

    local zombieSpawnCount = 0

    -- Adds a delay before zombies start spawning
    timer.Create("DogRoundRandomatStartSpawning", 9, 1, function()
        self.PlayerPositions = {}

        for _, ply in ipairs(self:GetAlivePlayers()) do
            table.insert(self.PlayerPositions, ply:GetPos())
        end

        -- Spawn as many zombies as players
        self.SpawnCap = #self:GetAlivePlayers()
        self.ChosenSpawns = 0
        -- And so the grand search for spawn points for the zombies begins...
        self:GetEntitySpawnPoints()
        -- Spawns as many zombies as living players
        -- -1 from the timer as we're spawning one outside the timer manually
        local spawnIndex = 1
        zombieSpawnCount = #self.ZombieSpawns
        -- There's guaranteed at least one spawn in a map as TTT generates a player spawn point when a map doesn't have any
        self:SpawnZombie(spawnIndex)

        timer.Create("DogRoundRandomatSpawnDog", 4, math.max(zombieSpawnCount - 1, 0), function()
            spawnIndex = spawnIndex + 1
            self:SpawnZombie(spawnIndex)
        end)
    end)

    local killedZombies = 0

    -- Creates an explosion effect and sound when a zombie dies
    self:AddHook("PostEntityTakeDamage", function(ent, dmg, took)
        if IsValid(ent) and ent:GetClass() == "npc_fastzombie" and ent:Health() <= 0 then
            local effect = EffectData()
            effect:SetOrigin(ent:GetPos())
            util.Effect("HelicopterMegaBomb", effect, true, true)
            ent:Remove()
            net.Start("DogRoundRandomatPlaySound")
            net.WriteString("doground/death" .. math.random(1, 3) .. ".mp3")
            net.Broadcast()
            -- Keep track of the number of zombies killed to trigger the "max ammo" reward when all are killed
            killedZombies = killedZombies + 1

            if killedZombies == zombieSpawnCount then
                self:EndDogRound()
            end
        end
    end)
end

function EVENT:End()
    net.Start("DogRoundRandomatEnd")
    net.Broadcast()
    table.Empty(self.ZombieSpawns)
    timer.Remove("DogRoundRandomatAlert")
    timer.Remove("DogRoundRandomatStartSpawning")
    timer.Remove("DogRoundRandomatSpawnDog")
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"fogdist"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 1
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)