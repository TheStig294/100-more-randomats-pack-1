local EVENT = {}
EVENT.Title = "The Bucket"
EVENT.Description = "Spawns a bucket somewhere on the map that kills anyone it touches..."
EVENT.id = "bucket"
EVENT.SingleUse = false

EVENT.Categories = {"entityspawn", "moderateimpact"}

util.AddNetworkString("BucketRandomatOutline")
util.AddNetworkString("BucketRandomatOutlineEnd")

function EVENT:Begin()
    local possibleSpawns = {}
    -- Get every player's position so the bucket isn't spawned too close to a player
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
            self:SmallNotify("No possible bucket spawns! Spawned on top of a player!")
        end)
    end

    local pos = possibleSpawns[math.random(1, #possibleSpawns)]
    local bucket = ents.Create("ent_bucket_randomat")
    bucket:SetPos(pos + Vector(0, 0, 10))
    bucket:Spawn()
    bucket:PhysWake()

    -- Forces the area around the bucket to load so it can always be seen through walls
    -- Copied some optimisations from the randomat base
    self:AddHook("SetupPlayerVisibility", function(ply, _)
        if not IsValid(bucket) then return end
        if ply.ShouldBypassCulling and not ply:ShouldBypassCulling() then return end
        if ply:TestPVS(bucket) then return end
        pos = bucket:GetPos()

        if not ply.IsOnScreen or ply:IsOnScreen(pos) then
            AddOriginToPVS(pos)
        end
    end)

    timer.Simple(1, function()
        SetGlobalEntity("RandomatBucketEnt", bucket)
    end)

    timer.Create("BucketRandomatOutlineDelay", 2, 1, function()
        net.Start("BucketRandomatOutline")
        net.Broadcast()
    end)
end

function EVENT:End()
    timer.Remove("BucketRandomatOutlineDelay")
    net.Start("BucketRandomatOutlineEnd")
    net.Broadcast()
end

Randomat:register(EVENT)