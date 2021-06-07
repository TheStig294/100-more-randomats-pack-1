--Disabling fg addon's chat message to clear up chat box for randomat alerts (if installed)
RunConsoleCommand("ttt_fgaddons_textmessage", "0")
local randomatRandomSeed = true

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

--Hard-coded list of maps known to not have AI meshes, randomats that give out weapons using AI will not trigger on these maps
function MapHasAI()
    local maps = {"gm_artisanshome", "gm_michaelshouse", "gm_rayman2_fairyglade_a6", "dm_christmas_in_the_suburbs", "dm_overwatch", "animal_crossing", "thefirstmap_final", "rp_lordaeron", "ttt_fallingwater", "ttt_halloween", "ttt_ile", "ttt_islandstreets", "ttt_minecraft_b5-40", "ttt_starwars_final", "ttt_upstate", "ttt_riverside_b3", "ttt_silenthill", "ttt_waterworld_remastered_2020", "ttt_winter_project", "ttt_woodshop"}

    local mapHasAI = true

    for i = 1, #maps do
        if game.GetMap() == maps[i] then
            mapHasAI = false
        end
    end

    return mapHasAI
end

--Function which adds support to giving players a handful of different passive buy menu items, 
--which normally do not work properly if given just using TTT's default GiveEquipmentItem() function.
function ClassToGive(name, ply)
    if name == EQUIP_ARMOR then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_ARMOR).id))
        --Also adds chat messages to passive items that don't have an obvious effect when given
        ply:ChatPrint("You have been given a Body Armor. You receive 30% less damage to body shots.")
    elseif name == EQUIP_RADAR then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_RADAR).id))
        ply:ConCommand("ttt_radar_scan")
    elseif name == EQUIP_ASC then
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
    elseif name == EQUIP_DEMONIC_POSSESSION then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_DEMONIC_POSSESSION).id))
        ply.DemonicPossession = true
    elseif name == EQUIP_JUGGERNOG then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_JUGGERNOG).id))
        ply:Give("ttt_perk_juggernog")
    elseif name == EQUIP_PHD then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_PHD).id))
        ply:Give("ttt_perk_phd")
    elseif name == EQUIP_STAMINUP then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_STAMINUP).id))
        ply:Give("ttt_perk_staminup")
    elseif name == EQUIP_BUNKER then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_BUNKER).id))
        ply:ChatPrint("You have been given a Bruh Bunker. Taking damage from a player will spawn a bunker around you. ")
        ply.cringealert = true
    elseif name == EQUIP_DISGUISE then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_TRAITOR, EQUIP_DISGUISE).id))
        ply:ChatPrint("You have been given a Disguiser. Press numpad enter to enable disguise.")
    elseif name == EQUIP_FLSHWND then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_TRAITOR, EQUIP_FLSHWND).id))

        if ply:HasEquipmentItem(EQUIP_FLSHWND) then
            if ply.flshwnd == false then
                ply:ChatPrint("You have been given a Flesh Wound. Upon reaching 1 HP you will survive for 5 seconds")
            end

            ply.flshwnd = true
            ply.flshwndtimer = true
        end
    elseif name == EQUIP_DOUBLETAP then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_TRAITOR, EQUIP_DOUBLETAP).id))
        ply:Give("ttt_perk_doubletap")
    elseif name == EQUIP_SPEEDCOLA then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_ZOMBIE, EQUIP_SPEED).id))
        ply:Give("ttt_perk_speed")
    elseif name == EQUIP_SPEED then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_ZOMBIE, EQUIP_SPEED).id))
        ply:ChatPrint("You have been given the zombie movement speed boost.")
    elseif name == EQUIP_REGEN then
        ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_ZOMBIE, EQUIP_REGEN).id))
        ply:ChatPrint("You have been given the zombie health regeneration.")
    else
        ply:Give(name)
    end
end

--Used for the 'Let's mix it up!' and 'Future Proofing' randomats
function StripEquipment(ply, equipment, is_item)
    timer.Simple(0.1, function()
        if is_item then
            if equipment == EQUIP_JUGGERNOG then
                ply:StripWeapon("ttt_perk_juggernog")
            elseif equipment == EQUIP_PHD then
                ply:StripWeapon("ttt_perk_phd")
            elseif equipment == EQUIP_STAMINUP then
                ply:StripWeapon("ttt_perk_staminup")
            elseif equipment == EQUIP_DOUBLETAP then
                ply:StripWeapon("ttt_perk_doubletap")
            elseif equipment == EQUIP_SPEED then
                ply:StripWeapon("ttt_perk_speed")
            elseif equipment == EQUIP_ASC then
                ply:ChatPrint("\n \n \n \n \n \n \n \n \n \n \n \n")
                ply.SecondChanceChance = 0
                ply.shouldasc = false
            elseif equipment == EQUIP_DEMONIC_POSSESSION then
                ply.DemonicPossession = false
            elseif equipment == EQUIP_FLSHWND then
                ply:ChatPrint("\n \n \n \n \n \n \n \n \n \n \n \n")
                ply.flshwnd = false
                ply.flshwndtimer = false
            elseif equipment == EQUIP_BUNKER then
                ply.cringealert = false
            end

            ply:ResetEquipment()
        else
            ply:StripWeapon(equipment)
        end
    end)
end

-- Takes 2 players and checks if they are on the same team, checking one team at a time
function IsSameTeam(attacker, victim)
    if (Randomat:IsInnocentTeam(attacker, false) and Randomat:IsInnocentTeam(victim, false)) or (Randomat:IsTraitorTeam(attacker) and Randomat:IsTraitorTeam(victim)) or (Randomat:IsMonsterTeam(attacker) and Randomat:IsMonsterTeam(victim)) then
        return true
    else
        return false
    end
end