local EVENT = {}

CreateConVar("randomat_battleroyale_radar_time", 120, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds before everyone is given a radar (Set to 0 to disable)", 0, 240)

CreateConVar("randomat_battleroyale_storm_zones", 4, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The number of zones until the storm covers the map (Set to 0 to disable)", 0, 10)
CreateConVar("randomat_battleroyale_storm_wait_time", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds after the next zone is announced before the storm moves", 0, 120)
CreateConVar("randomat_battleroyale_storm_move_time", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds it takes for the storm to move", 0, 120)

CreateConVar("randomat_battleroyale_music", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Play victory royale music when someone wins", 0, 1)

EVENT.Title = "LAST ONE STANDING WINS! BATTLE ROYALE!"
EVENT.Description = ""
EVENT.ExtDescription = "Everyone is turned into an innocent, and turns the game into a free-for-all!"
EVENT.id = "battleroyale"

EVENT.Categories = {"gamemode", "largeimpact"}

local alertSound = Sound("battleroyale/alert.mp3")
util.PrecacheSound("battleroyale/fortnite_victory_royale.mp3")
util.AddNetworkString("RandomatBattleRoyaleBegin")
util.AddNetworkString("RandomatBattleRoyaleEnd")
util.AddNetworkString("RandomatBattleRoyaleZone")
util.AddNetworkString("RandomatBattleRoyaleShrinkZone")

function EVENT:Begin()
    local fortniteToolExists = weapons.Get("weapon_ttt_fortnite_building") ~= nil

    if fortniteToolExists then
        EVENT.Description = "Press 'F' to change platform shape"
    end

    -- Plays the Fortnite alert sound as an extra warning this randomat has started
    for i, ply in pairs(self:GetPlayers()) do
        ply:EmitSound(alertSound)
    end

    -- Preventing the round from ending if more than 1 person is alive
    self:AddHook("TTTCheckForWin", function()
        if #self:GetAlivePlayers() > 1 then return WIN_NONE end
    end)

    -- After the set amount of time runs out, (default 2 minutes) everyone is given a radar to prevent camping
    local radarTimer = GetConVar("randomat_battleroyale_radar_time"):GetInt()
    if radarTimer > 0 then
        timer.Create("BattleRoyaleRandomatTimer", 1, radarTimer, function()
            if timer.RepsLeft("BattleRoyaleRandomatTimer") == 0 then
                self:SmallNotify("Radar activated!")

                for k, ply in pairs(self:GetPlayers()) do
                    ply:GiveEquipmentItem(tonumber(EQUIP_RADAR))
                    ply:ConCommand("ttt_radar_scan")
                    --Also plays the Fortnite alert sound again
                    ply:EmitSound(alertSound)
                end
            end
        end)
    end

    -- Disabling giving karma penalties
    self:AddHook("TTTKarmaGivePenalty", function(ply, penalty, victim) return true end)

    -- Giving everyone a Fortnite building tool, if one of its convars is found, and turning everyone into an innocent
    for i, ply in pairs(self:GetAlivePlayers()) do
        if fortniteToolExists then
            ply:Give("weapon_ttt_fortnite_building")
        end

        self:StripRoleWeapons(ply)
        Randomat:SetRole(ply, ROLE_INNOCENT)
    end

    SendFullStateUpdate()
    net.Start("RandomatBattleRoyaleBegin")
    net.WriteBool(CR_VERSION ~= nil)
    net.WriteBool(GetConVar("randomat_battleroyale_music"):GetBool())
    net.WriteBool(GetConVar("randomat_battleroyale_storm_zones"):GetInt() ~= 0)
    net.Broadcast()

    -- Disable round end sounds and 'Ending Flair' event so victory royale music can play
    if GetConVar("randomat_battleroyale_music"):GetBool() then
        self:DisableRoundEndSounds()
    end

    -- Storm functionality
    if GetConVar("randomat_battleroyale_storm_zones"):GetInt() > 0 then
        -- Calculate a suitable starting position and radius for the storm
        local averagePosition = Vector(0, 0, 0)
        local playerCount = 0
        local maxRadius = 0
        for i, ply in pairs(self:GetAlivePlayers()) do
            averagePosition:Add(ply:GetPos())
            playerCount = playerCount + 1
            for j, ply2 in pairs(self:GetAlivePlayers()) do
                local radius = ply:GetPos():Distance(ply2:GetPos())
                if radius > maxRadius then maxRadius = radius end
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

        local waitTime = GetConVar("randomat_battleroyale_storm_wait_time"):GetInt()
        local moveTime = GetConVar("randomat_battleroyale_storm_move_time"):GetInt()

        -- Wrapper function to send zone data to client
        local function BroadcastZoneData()
            net.Start("RandomatBattleRoyaleZone")
            net.WriteFloat(nextZoneX)
            net.WriteFloat(nextZoneY)
            net.WriteFloat(nextZoneR)
            net.Broadcast()
        end

        -- Wrapper function to shrink storm on the client
        local function BroadcastShrinkZone()
            net.Start("RandomatBattleRoyaleShrinkZone")
            net.WriteFloat(moveTime)
            net.Broadcast()
        end

        BroadcastZoneData()

        -- Create timer for next zone
        local zoneNumber = 0
        local function MoveZone(first)
            timer.Create("BattleRoyaleRandomatZoneTimer", first and 5 or waitTime, 1, function()
                self:SmallNotify("The storm is shrinking!")
                for i, ply in pairs(self:GetPlayers()) do
                    ply:EmitSound(alertSound)
                end
                BroadcastShrinkZone()
                local xIncrement = (nextZoneX - zoneX) / (moveTime * 10)
                local yIncrement = (nextZoneY - zoneY) / (moveTime * 10)
                local rIncrement = (nextZoneR - zoneR) / (moveTime * 10)
                timer.Create("BattleRoyaleRandomatZoneShrinkTimer", 0.1, moveTime * 10, function()
                    zoneX = zoneX + xIncrement
                    zoneY = zoneY + yIncrement
                    zoneR = zoneR + rIncrement
                end)
                timer.Create("BattleRoyaleRandomatZoneTimer", moveTime, 1, function()
                    zoneNumber = zoneNumber + 1
                    if zoneNumber >= GetConVar("randomat_battleroyale_storm_zones"):GetInt() then
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
                    if zoneNumber <= GetConVar("randomat_battleroyale_storm_zones"):GetInt() then
                        BroadcastZoneData()
                        self:SmallNotify("The storm will shrink in " .. moveTime .. " seconds.")
                        for i, ply in pairs(self:GetPlayers()) do
                            ply:EmitSound(alertSound)
                        end
                        MoveZone(false)
                    end
                end)
            end)
        end

        MoveZone(true)

        timer.Create("BattleRoyaleRandomatZoneDamageTimer", 0.5, 0, function()
            for i, ply in pairs(self:GetPlayers()) do
                if ply:Alive() then
                    local playerPos = ply:GetPos()
                    if math.sqrt((playerPos.x - zoneX)^2 + (playerPos.y - zoneY)^2) > zoneR or zoneR < 5 then
                        local hp = ply:Health()
                        if hp <= 1 then
                            ply:PrintMessage(HUD_PRINTTALK, "You died to the storm!")
                            ply:PrintMessage(HUD_PRINTCENTER, "You died to the storm!")
                            ply:Kill()
                        else
                            ply:SetHealth(hp - 1)
                        end
                    end
                end
            end
        end)
    end
end

function EVENT:End()
    -- Removing the radar timer, else everyone will be given a radar next round...
    timer.Remove("BattleRoyaleRandomatTimer")
    -- Removing the zone timer
    timer.Remove("BattleRoyaleRandomatZoneTimer")
    -- Removing the shrinking zone timer
    timer.Remove("BattleRoyaleRandomatZoneShrinkTimer")
    -- Removing the zone damage timer
    timer.Remove("BattleRoyaleRandomatZoneDamageTimer")
    -- Also remove the win title hook, else the win title will always be "[Player] WINS!"
    net.Start("RandomatBattleRoyaleEnd")
    net.Broadcast()
end

-- Prevent 'Contagious Morality' from triggering at the same time as events that
-- require 1 player to be alive for the round to end
function EVENT:Condition()
    return not Randomat:IsEventActive("contagiousmorality")
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"radar_time", "storm_zones", "storm_wait_time", "storm_move_time"}) do
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

    return sliders, checkboxes
end

Randomat:register(EVENT)