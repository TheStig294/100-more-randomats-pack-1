local EVENT = {}
EVENT.Title = "The Bucket"
EVENT.Description = "Spawns a bucket somewhere on the map that kills anyone it touches..."
EVENT.id = "bucket"
EVENT.SingleUse = false

EVENT.Categories = {"entityspawn", "moderateimpact"}

local possibleSpawns = {}

function EVENT:Begin()
    local ent = possibleSpawns[math.random(1, #possibleSpawns)]
    local pos = ent:GetPos()
    local bucket = ents.Create("ent_bucket_randomat")
    bucket:SetPos(pos + Vector(0, 0, 10))
    bucket:Spawn()
    bucket:PhysWake()
end

-- Get every player's position so the bucket isn't spawned too close to a player
function EVENT:Condition()
    possibleSpawns = {}
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
                table.insert(possibleSpawns, ent)
            end
        end
    end

    return not table.IsEmpty(possibleSpawns)
end

Randomat:register(EVENT)