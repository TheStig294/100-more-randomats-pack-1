local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Fetch me their souls..."
EVENT.id = "doground"

EVENT.Categories = {"biased_traitor", "biased", "entityspawn", "largeimpact"}

EVENT.MaxAmmo = false

local fogDist = CreateConVar("randomat_doground_fogdist", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Fog distance multiplier", 0.2, 5)

util.AddNetworkString("DogRoundRandomatBegin")
util.AddNetworkString("DogRoundRandomatPlaySound")
util.AddNetworkString("DogRoundRandomatRemoveFog")
util.AddNetworkString("DogRoundRandomatEnd")
local zombieSpawns = {}

function EVENT:SpawnZombie(spawnIndex)
    -- Plays the lightning sound effect on all clients
    net.Start("DogRoundRandomatPlaySound")
    net.WriteString("doground/spawn.mp3")
    net.Broadcast()

    -- Spawns the zombie in time with the sound effect
    timer.Simple(1.577, function()
        if zombieSpawns[spawnIndex] then
            local pos = zombieSpawns[spawnIndex] + Vector(0, 10, 0)
            local lightningEffect = EffectData()
            lightningEffect:SetOrigin(pos)
            lightningEffect:SetMagnitude(20)
            lightningEffect:SetScale(2)
            lightningEffect:SetRadius(10)
            util.Effect("Sparks", lightningEffect, true, true)
            util.ScreenShake(zombieSpawns[spawnIndex], 30, 100, 0.5, 5000)

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
        self.MaxAmmo = true
        Randomat:EventNotifySilent("Max Ammo!")
    end)

    timer.Simple(10, function()
        net.Start("DogRoundRandomatRemoveFog")
        net.Broadcast()
    end)
end

function EVENT:Begin()
    self.MaxAmmo = false
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
        local playerPositions = {}

        for _, ply in ipairs(self:GetAlivePlayers()) do
            table.insert(playerPositions, ply:GetPos())
        end

        -- Spawn twice as many zombies as players
        local spawnCap = #self:GetAlivePlayers() * 2
        local chosenSpawns = 0

        for _, ent in ipairs(ents.GetAll()) do
            local classname = ent:GetClass()
            local pos = ent:GetPos()
            local infoEnt = string.StartWith(classname, "info_")

            -- Using the positions of weapon, ammo and player spawns
            if (string.StartWith(classname, "weapon_") or string.StartWith(classname, "item_") or infoEnt) and not IsValid(ent:GetParent()) and chosenSpawns < spawnCap then
                local tooClose = false

                for _, plyPos in ipairs(playerPositions) do
                    -- 100 * 100 = 10,000, so any zombies closer than 100 source units to the player are too close to be placed
                    if math.DistanceSqr(pos.x, pos.y, plyPos.x, plyPos.y) < 10000 then
                        tooClose = true
                        break
                    end
                end

                if not tooClose then
                    table.insert(zombieSpawns, pos)

                    -- Don't remove player spawn points
                    if not infoEnt then
                        ent:Remove()
                    end

                    chosenSpawns = chosenSpawns + 1
                end
            end
        end

        -- Spawns as many zombies as living players
        -- -1 from the timer as we're spawning one outside the timer manually
        local spawnIndex = 1
        zombieSpawnCount = #zombieSpawns
        self:SpawnZombie(spawnIndex)

        timer.Create("DogRoundRandomatSpawnDog", 4, math.max(zombieSpawnCount - 1, 0), function()
            self:SpawnZombie(spawnIndex)
            spawnIndex = spawnIndex + 1
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

    -- Grants all players infinite ammo when all zombies are killed
    -- Taken from Dem's "Infinite ammo" randomat event, from the original randomat 2.0 mod
    self:AddHook("Think", function()
        if self.MaxAmmo then
            for _, v in ipairs(self:GetAlivePlayers()) do
                local active_weapon = v:GetActiveWeapon()

                if IsValid(active_weapon) and active_weapon.AutoSpawnable and not active_weapon.CanBuy then
                    active_weapon:SetClip1(active_weapon.Primary.ClipSize)
                end
            end
        end
    end)
end

function EVENT:End()
    net.Start("DogRoundRandomatEnd")
    net.Broadcast()
    table.Empty(zombieSpawns)
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