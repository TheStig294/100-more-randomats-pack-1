Randomat = Randomat or {}

-- Displaying a message if an incompatible randomat mod is installed
if engine.ActiveGamemode() == "terrortown" and file.Exists("sound/weapons/randomat_revolver.wav", "GAME") and file.Exists("randomat2/randomat_shared.lua", "lsv") then
    local roundCount = 0

    hook.Add("TTTBeginRound", "StigDemRandomatInstallMessage", function()
        roundCount = roundCount + 1

        if (roundCount == 1) or (roundCount == 2) then
            timer.Simple(4, function()
                PrintMessage(HUD_PRINTTALK, "Server has 2 incompatible randomat mods installed!\nPRESS 'Y', TYPE /2randomat AND ONLY INSTALL ONE OR THE OTHER\nor see the workshop pages for 'Randomat 2.0',\nand 'Randomat 2.0 for Custom Roles for TTT'.")
            end)
        end
    end)

    hook.Add("PlayerSay", "StigDemRandomatInstallCommand", function(ply, text)
        if string.lower(text) == "/2randomat" then
            ply:SendLua("steamworks.ViewFile(\"1406495040\")")

            return ""
        end
    end)
end

local traitorBuyable = {}
local detectiveBuyable = {}
local traitorDetectiveBuyable = {}

hook.Add("TTTPrepareRound", "RandomatPrepareRoundRunOnce", function()
    -- Disabling all events that are disabled by default once (So they can be turned back on if you still want them)
    if not file.Exists("randomat/disabled_events.txt", "DATA") then
        file.Write("randomat/disabled_events.txt")
    end

    local readFile = file.Read("randomat/disabled_events.txt", "DATA")
    local disabledEvents = string.Explode("\n", readFile)
    local eventsToDisable = {}

    for id, event in pairs(Randomat.Events) do
        if event.IsEnabled == false then
            table.insert(eventsToDisable, id)

            if not table.HasValue(disabledEvents, id) then
                RunConsoleCommand("ttt_randomat_" .. id, "0")
                table.insert(disabledEvents, id)
            end
        end
    end

    file.Write("randomat/disabled_events.txt", table.concat(disabledEvents, "\n"))

    -- Getting the lists of all buyable equipment by detectives and traitors
    -- First check if its on the SWEP list
    for _, SWEP in ipairs(weapons.GetList()) do
        if Randomat:IsBuyableItem(ROLE_TRAITOR, SWEP) then
            traitorBuyable[SWEP.ClassName] = true
        elseif Randomat:IsBuyableItem(ROLE_DETECTIVE, SWEP) then
            detectiveBuyable[SWEP.ClassName] = true
        end
    end

    -- If its not on the SWEP list, then check the equipment items table
    for _, item in pairs(EquipmentItems[ROLE_TRAITOR]) do
        if Randomat:IsBuyableItem(ROLE_TRAITOR, item) then
            -- Use name and not ID because we need a unique identifier
            -- If equipment items are uninstalled from the server, old equipment could start using IDs previously held by other equipment
            -- And thus stats could become mixed with another equipment's stats
            traitorBuyable[item.name] = true
        end
    end

    for _, item in pairs(EquipmentItems[ROLE_DETECTIVE]) do
        if Randomat:IsBuyableItem(ROLE_DETECTIVE, item) then
            detectiveBuyable[item.name] = true
        end
    end

    -- Create the detective and traitor buyable table
    traitorDetectiveBuyable = table.Copy(traitorBuyable)
    table.Merge(traitorDetectiveBuyable, detectiveBuyable)
    hook.Remove("TTTPrepareRound", "RandomatPrepareRoundRunOnce")
end)

-- If the buyable items for traitor or detective change then update the tables!
hook.Add("TTTRoleWeaponUpdated", "RandomatBuyableEquipmentUpdate", function(role, weapon, inc, exc, noRandom)
    if role == ROLE_TRAITOR then
        if inc then
            traitorBuyable[weapon] = true
        elseif exc then
            traitorBuyable[weapon] = nil
        end
    elseif role == ROLE_DETECTIVE then
        if inc then
            detectiveBuyable[weapon] = true
        elseif exc then
            detectiveBuyable[weapon] = nil
        end
    end

    if not traitorBuyable[weapon] and not detectiveBuyable[weapon] then
        traitorDetectiveBuyable[weapon] = nil
    else
        traitorDetectiveBuyable[weapon] = true
    end
end)

function Randomat:GetTraitorDetectiveBuyable()
    return traitorDetectiveBuyable
end

-- Choosing an arbitrary weapon kind so all weapons get given regardless of weapon slots
local wepKind = 103

function Randomat:GivePassiveOrActiveItem(ply, equipment)
    local SWEP = weapons.Get(equipment)
    local givenItem
    local itemID

    if SWEP and SWEP.Kind then
        -- Bypass weapon slots by changing the given weapon's weapon kind to ensure the weapon is always given
        for _, wep in ipairs(ply:GetWeapons()) do
            if wep.Kind and wep.Kind == SWEP.Kind then
                wep.Kind = wepKind
                wepKind = wepKind + 1
            end
        end

        givenItem = ply:Give(equipment)
    else
        local traitorPassive = false
        local detectivePassive = false

        for _, equ in ipairs(EquipmentItems[ROLE_TRAITOR]) do
            if equ.name == equipment then
                traitorPassive = true
                itemID = equ.id
                givenItem = equ
                break
            end
        end

        if not traitorPassive then
            for _, equ in ipairs(EquipmentItems[ROLE_DETECTIVE]) do
                if equ.name == equipment then
                    detectivePassive = true
                    itemID = equ.id
                    givenItem = equ
                    break
                end
            end
        end

        if not itemID or (not detectivePassive and not traitorPassive) then return end
        itemID = math.floor(tonumber(itemID))
        ply:GiveEquipmentItem(itemID)
    end

    timer.Simple(1, function()
        -- Calls all expected shop hooks for things like greying out icons in the player's shop
        local equ = itemID or equipment
        Randomat:CallShopHooks(is_item, equ, ply)

        -- For some reason this just does not get called when the radar is given...
        -- So we're just going to call it here so the radar automatically starts scanning when given
        if equ == EQUIP_RADAR then
            ply:ConCommand("ttt_radar_scan")
        end
    end)

    return givenItem
end

function Randomat:SetToBasicRole(ply, noMessageRole, independentMonsterAsInnocent)
    local teamName
    local monsterIndependentRole = Randomat:IsMonsterTeam(ply) or Randomat:IsIndependentTeam(ply)
    local changeToTraitorTeam = monsterIndependentRole and not independentMonsterAsInnocent

    -- Independents, monsters and special traitors become traitors
    if ply:GetRole() ~= ROLE_TRAITOR and (Randomat:IsTraitorTeam(ply) or changeToTraitorTeam) then
        Randomat:SetRole(ply, ROLE_TRAITOR)
        teamName = "Traitor"
        -- Special detectives become normal detectives
    elseif ply:GetRole() ~= ROLE_DETECTIVE and Randomat:IsGoodDetectiveLike(ply) then
        Randomat:SetRole(ply, ROLE_DETECTIVE)
        teamName = "Detective"
    elseif ply:GetRole() ~= ROLE_INNOCENT and (Randomat:IsJesterTeam(ply) or Randomat:IsInnocentTeam(ply) or (monsterIndependentRole and independentMonsterAsInnocent)) then
        -- Jesters and special innocents become normal innocents
        Randomat:SetRole(ply, ROLE_INNOCENT)
        teamName = "Innocent"
    else
        return
    end

    -- Anyone already a basic role isn't affected
    -- Some roles don't have the basic weapons, give them now
    ply:Give("weapon_zm_improvised")
    ply:Give("weapon_zm_carry")
    ply:Give("weapon_ttt_unarmed")
    -- Notify the player why their role was changed
    local changedTeamMessage = "You have joined the " .. teamName .. " team"

    if teamName == "Detective" then
        changedTeamMessage = "You have become an ordinary detective"
    end

    local extendedChangedTeamMessage = changedTeamMessage .. " due to being a role incompatible with a running event"

    timer.Simple(0.1, function()
        if noMessageRole and noMessageRole == teamName then return end
        ply:PrintMessage(HUD_PRINTCENTER, changedTeamMessage)
        ply:PrintMessage(HUD_PRINTTALK, extendedChangedTeamMessage)
    end)

    return changeToTraitorTeam
end

function Randomat:IsBodyDependentRole(ply)
    local role = ply:GetRole()
    if role == ROLE_PARASITE and ConVarExists("ttt_parasite_respawn_mode") and GetConVar("ttt_parasite_respawn_mode"):GetInt() == 1 then return true end

    return role == ROLE_MADSCIENTIST or role == ROLE_ZOMBIE or role == ROLE_HYPNOTIST or role == ROLE_BODYSNATCHER or role == ROLE_PARAMEDIC or role == ROLE_PHANTOM or role == ROLE_TAXIDERMIST
end

function Randomat:SpectatorRandomatAlert(ply, EVENT)
    ply:PrintMessage(HUD_PRINTCENTER, "Spectator Randomat Active!")
    local title = EVENT.Title or EVENT.AltTitle or "A spectator randomat"
    local desc = EVENT.Description or EVENT.ExtDescription or ""
    ply:PrintMessage(HUD_PRINTTALK, "'" .. title .. "' is active!\n" .. desc)

    timer.Simple(2, function()
        ply:PrintMessage(HUD_PRINTCENTER, "Spectator Randomat Active!")

        timer.Create("SpectatorRandomatAlert" .. ply:SteamID64(), 2, 2, function()
            if desc ~= "" then
                ply:PrintMessage(HUD_PRINTCENTER, desc)
            else
                ply:PrintMessage(HUD_PRINTCENTER, title)
            end
        end)
    end)
end

-- Battle Royale "Storm" functionality
util.AddNetworkString("RandomatStormBegin")
util.AddNetworkString("RandomatStormZone")
util.AddNetworkString("RandomatStormShrinkZone")
util.AddNetworkString("RandomatStormEnd")

function Randomat:BattleRoyaleStorm(zones, waitTime, moveTime)
    if zones <= 0 then return end
    net.Start("RandomatStormBegin")
    net.Broadcast()
    -- Calculate a suitable starting position and radius for the storm
    local averagePosition = Vector(0, 0, 0)
    local playerCount = 0
    local maxRadius = 0

    for _, ply in player.Iterator() do
        if not ply:Alive() or ply:IsSpec() then continue end
        averagePosition:Add(ply:GetPos())
        playerCount = playerCount + 1

        for _, ply2 in player.Iterator() do
            if not ply:Alive() or ply:IsSpec() then continue end
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
    local nextZoneRadius = maxRadius / 2
    -- Current zone data (start twice as big as we need to be so people have time to run if they spawned outsize the zone)
    local zoneX = nextZoneX
    local zoneY = nextZoneY
    local zoneRadius = maxRadius

    -- Wrapper function to send zone data to client
    local function BroadcastZoneData()
        net.Start("RandomatStormZone")
        net.WriteFloat(nextZoneX)
        net.WriteFloat(nextZoneY)
        net.WriteFloat(nextZoneRadius)
        net.Broadcast()
    end

    -- Wrapper function to shrink storm on the client
    local function BroadcastShrinkZone()
        net.Start("RandomatStormShrinkZone")
        net.WriteFloat(moveTime)
        net.Broadcast()
    end

    BroadcastZoneData()
    -- Create timer for next zone
    local zoneNumber = 0

    local function MoveZone(first)
        timer.Create("RandomatZoneTimer", first and 5 or waitTime, 1, function()
            Randomat:SmallNotify("The storm is shrinking!")
            BroadcastLua("surface.PlaySound(\"battleroyale/alert.mp3\")")
            BroadcastShrinkZone()
            local xIncrement = (nextZoneX - zoneX) / (moveTime * 10)
            local yIncrement = (nextZoneY - zoneY) / (moveTime * 10)
            local radiusIncrement = (nextZoneRadius - zoneRadius) / (moveTime * 10)

            timer.Create("RandomatZoneShrinkTimer", 0.1, moveTime * 10, function()
                zoneX = zoneX + xIncrement
                zoneY = zoneY + yIncrement
                zoneRadius = zoneRadius + radiusIncrement
            end)

            timer.Create("RandomatZoneTimer", moveTime, 1, function()
                zoneNumber = zoneNumber + 1

                if zoneNumber >= zones then
                    -- If it is the last zone shrink it down entirely
                    nextZoneRadius = 0
                else
                    -- If isn't the last zone choose a new random centre within the current zone and half the radius
                    local randAngle = math.Rand(0, math.tau)
                    local randRadius = math.Rand(0, zoneRadius)
                    nextZoneX = zoneX + math.cos(randAngle) * randRadius
                    nextZoneY = zoneY + math.sin(randAngle) * randRadius
                    nextZoneRadius = zoneRadius / 2
                end

                if zoneNumber <= zones then
                    BroadcastZoneData()
                    Randomat:SmallNotify("The storm will shrink in " .. moveTime .. " seconds.")
                    BroadcastLua("surface.PlaySound(\"battleroyale/alert.mp3\")")
                    MoveZone(false)
                end
            end)
        end)
    end

    MoveZone(true)

    timer.Create("RandomatZoneDamageTimer", 0.5, 0, function()
        for _, ply in player.Iterator() do
            if not ply:Alive() or ply:IsSpec() then continue end
            local playerPos = ply:GetPos()

            if math.sqrt((playerPos.x - zoneX) ^ 2 + (playerPos.y - zoneY) ^ 2) > zoneRadius or zoneRadius < 5 then
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
    end)

    -- Clean-up at the end of the round
    hook.Add("TTTPrepareRound", "RandomatStormReset", function()
        net.Start("RandomatStormEnd")
        net.Broadcast()
        timer.Remove("RandomatZoneTimer")
        timer.Remove("RandomatZoneShrinkTimer")
        timer.Remove("RandomatZoneDamageTimer")
        hook.Remove("TTTPrepareRound", "RandomatStormReset")
    end)
end