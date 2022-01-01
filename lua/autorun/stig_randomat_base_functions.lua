--Disabling fg addon's chat message to clear up chat box for randomat alerts (if installed)
RunConsoleCommand("ttt_fgaddons_textmessage", "0")
local randomatRandomSeed = GetGlobalBool("RandomatRandomisationSeeding", true)

--Seeding random numbers in Garry's Mod to help with the same randomats being picked over and over, running only once
if randomatRandomSeed then
    math.randomseed(os.time())

    -- Pre-emptively calculating unused random numbers to improve the randomness when math.random() is actually used
    for i = 1, 2000 do
        math.random()
    end

    -- Now disabling math.randomseed for everyone else so the good randomness just built up isn't reset
    function math.randomseed(seed)
    end

    randomatRandomSeed = false
end

--Renaming print names of weapons the same way as 'TTT Total Statistics' for compatibility
local function RenameWeps(name)
    if name == "sipistol_name" then
        return "Silenced Pistol"
    elseif name == "knife_name" then
        return "Knife"
    elseif name == "newton_name" then
        return "Newton Launcher"
    elseif name == "tele_name" then
        return "Teleporter"
    elseif name == "hstation_name" then
        return "Health Station"
    elseif name == "flare_name" then
        return "Flare Gun"
    elseif name == "decoy_name" then
        return "Decoy"
    elseif name == "radio_name" then
        return "Radio"
    elseif name == "polter_name" then
        return "Poltergeist"
    elseif name == "vis_name" then
        return "Visualizer"
    elseif name == "defuser_name" then
        return "Defuser"
    elseif name == "stungun_name" then
        return "UMP Prototype"
    elseif name == "binoc_name" then
        return "Binoculars"
    elseif name == "item_radar" then
        return "Radar"
    elseif name == "item_armor" then
        return "Body Armor"
    elseif name == "dragon_elites_name" then
        return "Dragon Elites"
    elseif name == "silenced_m4a1_name" then
        return "Silenced M4A1"
    elseif name == "slam_name" then
        return "M4 SLAM"
    elseif name == "jihad_bomb_name" then
        return "Jihad Bomb"
    elseif name == "item_slashercloak" then
        --custom mods friends and I made ;)
        return "Slasher Cloak"
    elseif name == "heartbeat_monitor_name" then
        return "Heartbeat Monitor"
    else
        return name
    end
end

--Net messages for the randomats relying on 'TTT Total Statistics'
if SERVER then
    util.AddNetworkString("RandomatDetectiveWeaponsList")
    util.AddNetworkString("RandomatTraitorWeaponsList")
    util.AddNetworkString("Randomat_SendDetectiveEquipmentName")
    util.AddNetworkString("Randomat_SendTraitorEquipmentName")
end

if SERVER then
    firstBegin = true
    detectiveBuyable = {}
    traitorBuyable = {}

    --At the start of the first round of a map, ask the first connected client for the printnames of all detective and traitor weapons
    --Used by randomats that use 'TTT Total Statistics'
    --Needed since 'TTT Total Statistics' stores weapon stats identifying weapons by printnames, not classnames
    hook.Add("TTTBeginRound", "RandomatGetBuyMenuLists", function()
        if firstBegin then
            net.Start("RandomatDetectiveWeaponsList")
            net.Send(Entity(1))
            net.Start("RandomatTraitorWeaponsList")
            net.Send(Entity(1))
            firstBegin = false
        end
    end)

    net.Receive("Randomat_SendDetectiveEquipmentName", function(len, ply)
        tbl = string.Split(net.ReadString(), ",")
        local name = RenameWeps(tbl[1])
        local error = net.ReadBool()

        if error then
            print("Failed to find equipment (" .. name .. ") for 'Gotta Buy 'em all!' randomat")
        else
            detectiveBuyable[tbl[2]] = name
        end
    end)

    net.Receive("Randomat_SendTraitorEquipmentName", function(len, ply)
        tbl = string.Split(net.ReadString(), ",")
        local name = RenameWeps(tbl[1])
        local error = net.ReadBool()

        if error then
            print("Failed to find equipment (" .. name .. ") for 'Gotta Buy 'em all!' randomat")
        else
            traitorBuyable[tbl[2]] = name
        end
    end)

    function GetDetectiveBuyable()
        return detectiveBuyable
    end

    function GetTraitorBuyable()
        return traitorBuyable
    end
end

--Used by randomats reading stats data from 'TTT Total Statistics', e.g. 'Everyone has their favourites'
--Gives a weapon by its print name, some passive items have hard-codded support, all held weapons installed on the first connected client are supported
function PrintToGive(name, ply)
    if name == "Body Armor" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_ARMOR).id))
        ply:ChatPrint("You have been given a Body Armor. You receive 30% less damage to body shots.")
    elseif name == "Radar" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_RADAR).id))
        ply:ConCommand("ttt_radar_scan")
        ply:ChatPrint("You have been given a Radar.")
    elseif name == "A Second Chance" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_ASC).id))
        ply.shouldasc = true

        if ply:GetRole() == ROLE_TRAITOR or ply:GetRole() == ROLE_JACKAL or ply:GetRole() == ROLE_SIDEKICK then
            ply.SecondChanceChance = math.random(15, 25)
        else
            ply.SecondChanceChance = math.random(20, 35)
        end

        net.Start("ASCBuyed")
        net.WriteInt(ply.SecondChanceChance, 8)
        net.Send(ply)
    elseif name == "Demonic Possession" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_DEMONIC_POSSESSION).id))
        ply.DemonicPossession = true
    elseif name == "Juggernog" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_JUGGERNOG).id))
        ply:Give("ttt_perk_juggernog")
    elseif name == "PHD Flopper Perk." then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_PHD).id))
        ply:Give("ttt_perk_phd")
    elseif name == "Stamin-Up" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_STAMINUP).id))
        ply:Give("ttt_perk_staminup")
    elseif name == "Bruh Bunker" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_BUNKER).id))
        ply:ChatPrint("You have been given a Bruh Bunker. Taking damage from a player will spawn a bunker around you. ")
        ply.cringealert = true
    elseif name == "Disguiser" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_TRAITOR, EQUIP_DISGUISE).id))
        ply:ChatPrint("You have been given a Disguiser. Press numpad enter to enable disguise.")
    elseif name == "Flesh Wound" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_TRAITOR, EQUIP_FLSHWND).id))

        if ply:HasEquipmentItem(EQUIP_FLSHWND) then
            if ply.flshwnd == false then
                ply:ChatPrint("You have been given a Flesh Wound. Upon reaching 1 HP you will survive for 5 seconds")
            end

            ply.flshwnd = true
            ply.flshwndtimer = true
        end
    elseif name == "DoubleTap Root Beer" then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_TRAITOR, EQUIP_DOUBLETAP).id))
        ply:Give("ttt_perk_doubletap")
    elseif name == "Speed Cola Perk." then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_TRAITOR, EQUIP_SPEED).id))
        ply:Give("ttt_perk_speed")
    elseif table.KeyFromValue(detectiveBuyable, name) ~= nil then
        ply:Give(table.KeyFromValue(detectiveBuyable, name))
    elseif table.KeyFromValue(traitorBuyable, name) ~= nil then
        ply:Give(table.KeyFromValue(traitorBuyable, name))
    else
        ply:ChatPrint("Weapon to give you was not found...")
    end
end

-- Returns whether or not the current map has a navmesh. Used for randomats that use ai-based weapons that need a navmesh to work, such as the guard dog or killer snail randomats
function MapHasAI()
    return file.Exists("maps/" .. game.GetMap() .. ".nav", "GAME")
end

-- Takes 2 players and checks if they are on the same team, checking one team at a time
function IsSameTeam(attacker, victim)
    if (Randomat:IsInnocentTeam(attacker, false) and Randomat:IsInnocentTeam(victim, false)) or (Randomat:IsTraitorTeam(attacker) and Randomat:IsTraitorTeam(victim)) or (Randomat:IsMonsterTeam(attacker) and Randomat:IsMonsterTeam(victim)) then
        return true
    else
        return false
    end
end