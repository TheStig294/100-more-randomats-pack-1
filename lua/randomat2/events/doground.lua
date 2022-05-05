local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Fetch me their souls..."
EVENT.id = "doground"

EVENT.Categories = {"biased_traitor", "biased", "entityspawn", "largeimpact"}

local fogDist = CreateConVar("randomat_doground_fogdist", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The fog distance scale for non-traitors", 0.2, 5)

util.AddNetworkString("DogRoundRandomatBegin")
util.AddNetworkString("DogRoundRandomatPlaySound")
util.AddNetworkString("DogRoundRandomatEnd")
local zombieSpawns = {}

function EVENT:SpawnZombie(spawnCount)
    -- Plays the lightning sound effect on all clients
    net.Start("DogRoundRandomatPlaySound")
    net.WriteString("doground/spawn.mp3")
    net.Broadcast()

    timer.Simple(1.577, function()
        local pos = zombieSpawns[spawnCount] + Vector(0, 10, 0)
        local lightningEffect = EffectData()
        lightningEffect:SetOrigin(pos)
        util.Effect("ManhackSparks", lightningEffect, true, true)
        util.ScreenShake(zombieSpawns[spawnCount], 30, 100, 0.5, 5000)

        timer.Simple(0.2, function()
            local zombie = ents.Create("npc_fastzombie")
            zombie:SetPos(pos)
            zombie:Spawn()
            zombie:PhysWake()
        end)
    end)
end

function EVENT:Begin()
    net.Start("DogRoundRandomatBegin")
    net.WriteFloat(fogDist:GetFloat())
    net.Broadcast()

    timer.Create("DogRoundRandomatAlert", 4.2, 1, function()
        Randomat:EventNotifySilent(self.AltTitle)
    end)

    timer.Create("DogRoundRandomatStartSpawning", 9, 1, function()
        local playerPositions = {}

        for _, ply in ipairs(self:GetAlivePlayers()) do
            table.insert(playerPositions, ply:GetPos())
        end

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

        local spawnCount = 1
        self:SpawnZombie(spawnCount)

        timer.Create("DogRoundRandomatSpawnDog", 4, #zombieSpawns, function()
            self:SpawnZombie(spawnCount)
            spawnCount = spawnCount + 1
        end)
    end)

    self:AddHook("PostEntityTakeDamage", function(ent, dmg, took)
        if IsValid(ent) and ent:GetClass() == "npc_fastzombie" and ent:Health() <= 0 then
            local effect = EffectData()
            effect:SetOrigin(ent:GetPos())
            util.Effect("HelicopterMegaBomb", effect, true, true)
            ent:Remove()
            net.Start("DogRoundRandomatPlaySound")
            net.WriteString("doground/death" .. math.random(1, 3) .. ".mp3")
            net.Broadcast()
        end
    end)
end

function EVENT:End()
    net.Start("DogRoundRandomatEnd")
    net.Broadcast()
    timer.Remove("DogRoundRandomatAlert")
    table.Empty(zombieSpawns)
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