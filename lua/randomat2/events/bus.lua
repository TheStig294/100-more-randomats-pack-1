local EVENT = {}
EVENT.Title = "The Bus"
EVENT.Description = "A mini school bus prop has spawned! It kills anyone it touches..."
EVENT.id = "bus"
EVENT.SingleUse = false

EVENT.Categories = {"entityspawn", "moderateimpact"}

util.AddNetworkString("BusRandomatOutline")
util.AddNetworkString("BusRandomatOutlineEnd")

function EVENT:Begin()
    local possibleSpawns = {}
    -- Get every player's position so the bus isn't spawned too close to a player
    local playerPositions = {}

    for _, ply in ipairs(self:GetAlivePlayers()) do
        table.insert(playerPositions, ply:GetPos())
    end

    for _, ent in ipairs(ents.GetAll()) do
        local classname = ent:GetClass()
        local pos = ent:GetPos()

        -- Using the positions of weapon, ammo and player spawns
        if (string.StartWith(classname, "info_")) and not IsValid(ent:GetParent()) then
            local tooClose = false

            for _, plyPos in ipairs(playerPositions) do
                -- 100 * 100 = 10,000, so any spot closer than 100 source units to the player is too close to be placed
                if math.DistanceSqr(pos.x, pos.y, plyPos.x, plyPos.y) < 10000 then
                    tooClose = true
                    break
                end
            end

            if not tooClose then
                table.insert(possibleSpawns, ent:GetPos())
            end
        end
    end

    if table.IsEmpty(possibleSpawns) or possibleSpawns == {} then
        possibleSpawns = playerPositions

        timer.Simple(5, function()
            self:SmallNotify("No possible bus spawns! Spawned on top of a player!")
        end)
    end

    local pos = possibleSpawns[math.random(1, #possibleSpawns)]
    local bus = ents.Create("ent_bus_randomat")
    bus:SetPos(pos + Vector(0, 0, 10))
    bus:Spawn()
    bus:PhysWake()

    -- Forces the area around the bus to load so it can always be seen through walls
    -- Copied some optimisations from the randomat base
    self:AddHook("SetupPlayerVisibility", function(ply, _)
        if not IsValid(bus) then return end
        if ply.ShouldBypassCulling and not ply:ShouldBypassCulling() then return end
        if ply:TestPVS(bus) then return end
        pos = bus:GetPos()

        if not ply.IsOnScreen or ply:IsOnScreen(pos) then
            AddOriginToPVS(pos)
        end
    end)

    timer.Simple(1, function()
        SetGlobalEntity("RandomatBusEnt", bus)
    end)

    timer.Create("BusRandomatOutlineDelay", 2, 1, function()
        net.Start("BusRandomatOutline")
        net.Broadcast()
    end)
end

function EVENT:End()
    timer.Remove("BusRandomatOutlineDelay")
    net.Start("BusRandomatOutlineEnd")
    net.Broadcast()
end

Randomat:register(EVENT)