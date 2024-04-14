local EVENT = {}

CreateConVar("randomat_circle_zones", 4, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The number of zones until the circle covers the map", 1, 10)

CreateConVar("randomat_circle_wait_time", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds after the next zone is announced before the circle moves", 0, 120)

CreateConVar("randomat_circle_move_time", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds it takes for the circle to move", 0, 120)

EVENT.Title = "The Circle"
EVENT.Description = "Stay inside the shrinking circle, or else you take damage!"
EVENT.id = "circle"

EVENT.Categories = {"largeimpact"}

util.AddNetworkString("RandomatCircleBegin")
util.AddNetworkString("RandomatCircleEnd")
util.AddNetworkString("RandomatCircleZone")
util.AddNetworkString("RandomatCircleShrinkZone")

function EVENT:Begin()
    net.Start("RandomatCircleBegin")
    net.Broadcast()
    -- Calculate a suitable starting position and radius for the circle
    local averagePosition = Vector(0, 0, 0)
    local playerCount = 0
    local maxRadius = 0

    for i, ply in pairs(self:GetAlivePlayers()) do
        averagePosition:Add(ply:GetPos())
        playerCount = playerCount + 1

        for j, ply2 in pairs(self:GetAlivePlayers()) do
            local radius = ply:GetPos():Distance(ply2:GetPos())

            if radius > maxRadius then
                maxRadius = radius
            end
        end
    end

    averagePosition:Div(playerCount)
    -- Next zone data
    local nextZoneX = averagePosition.x
    local nextZoneY = averagePosition.y
    local nextZoneR = maxRadius / 2
    -- Current zone data (start twice as big as we need to be so people have time to run if they spawned outsize the zone)
    local zoneX = nextZoneX
    local zoneY = nextZoneY
    local zoneR = maxRadius
    local waitTime = GetConVar("randomat_circle_wait_time"):GetInt()
    local moveTime = GetConVar("randomat_circle_move_time"):GetInt()

    -- Wrapper function to send zone data to client
    local function BroadcastZoneData()
        net.Start("RandomatCircleZone")
        net.WriteFloat(nextZoneX)
        net.WriteFloat(nextZoneY)
        net.WriteFloat(nextZoneR)
        net.Broadcast()
    end

    -- Wrapper function to shrink circle on the client
    local function BroadcastShrinkZone()
        net.Start("RandomatCircleShrinkZone")
        net.WriteFloat(moveTime)
        net.Broadcast()
    end

    BroadcastZoneData()
    -- Create timer for next zone
    local zoneNumber = 0

    local function MoveZone(first)
        timer.Create("CircleRandomatZoneTimer", first and 5 or waitTime, 1, function()
            self:SmallNotify("The circle is shrinking!")
            BroadcastShrinkZone()
            local xIncrement = (nextZoneX - zoneX) / (moveTime * 10)
            local yIncrement = (nextZoneY - zoneY) / (moveTime * 10)
            local rIncrement = (nextZoneR - zoneR) / (moveTime * 10)

            timer.Create("CircleRandomatZoneShrinkTimer", 0.1, moveTime * 10, function()
                zoneX = zoneX + xIncrement
                zoneY = zoneY + yIncrement
                zoneR = zoneR + rIncrement
            end)

            timer.Create("CircleRandomatZoneTimer", moveTime, 1, function()
                zoneNumber = zoneNumber + 1

                if zoneNumber >= GetConVar("randomat_circle_zones"):GetInt() then
                    -- If it is the last zone shrink it down entirely
                    nextZoneR = 0
                else
                    -- If isn't the last zone choose a new random centre within the current zone and half the radius
                    local randAngle = math.Rand(0, 2 * math.pi)
                    local randRadius = math.Rand(0, zoneR)
                    nextZoneX = zoneX + math.cos(randAngle) * randRadius
                    nextZoneY = zoneY + math.sin(randAngle) * randRadius
                    nextZoneR = zoneR / 2
                end

                if zoneNumber <= GetConVar("randomat_circle_zones"):GetInt() then
                    BroadcastZoneData()
                    self:SmallNotify("The circle will shrink in " .. moveTime .. " seconds.")
                    MoveZone(false)
                end
            end)
        end)
    end

    MoveZone(true)

    timer.Create("CircleRandomatZoneDamageTimer", 0.5, 0, function()
        for i, ply in pairs(self:GetPlayers()) do
            if ply:Alive() then
                local playerPos = ply:GetPos()

                if math.sqrt((playerPos.x - zoneX) ^ 2 + (playerPos.y - zoneY) ^ 2) > zoneR or zoneR < 5 then
                    local hp = ply:Health()

                    if hp <= 1 then
                        ply:PrintMessage(HUD_PRINTTALK, "You died to the circle!")
                        ply:PrintMessage(HUD_PRINTCENTER, "You died to the circle!")
                        ply:Kill()
                    else
                        ply:SetHealth(hp - 1)
                    end
                end
            end
        end
    end)
end

function EVENT:End()
    timer.Remove("CircleRandomatZoneTimer")
    timer.Remove("CircleRandomatZoneShrinkTimer")
    timer.Remove("CircleRandomatZoneDamageTimer")
    net.Start("RandomatCircleEnd")
    net.Broadcast()
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"zones", "wait_time", "move_time"}) do
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