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
    detectiveBuyable = {}
    traitorBuyable = {}

    --At the start of the first round of a map, ask the first connected client for the printnames of all detective and traitor weapons
    --Used by randomats that use 'TTT Total Statistics'
    --Needed since 'TTT Total Statistics' stores weapon stats identifying weapons by printnames, not classnames
    hook.Add("TTTPrepareRound", "RandomatGetBuyMenuLists", function()
        net.Start("RandomatDetectiveWeaponsList")
        net.Send(Entity(1))
        net.Start("RandomatTraitorWeaponsList")
        net.Send(Entity(1))
        hook.Remove("TTTPrepareRound", "RandomatGetBuyMenuLists")
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

--Gives a weapon by its print name
--Only supports items installed on the first connected client, available to either the detective or traitor (for passive items they must also have a valid id)
--Used by randomats reading stats data from 'TTT Total Statistics', e.g. 'Everyone has their favourites'
function PrintToGive(name, ply)
    local traitorWeapon = table.KeyFromValue(traitorBuyable, name)
    local detectiveWeapon = table.KeyFromValue(detectiveBuyable, name)

    -- First try giving the equipment as a weapon, if the ID found isn't a number (and therefore isn't an equipment ID)
    if traitorWeapon ~= nil and not isnumber(tonumber(traitorWeapon)) then
        ply:Give(traitorWeapon)
        Randomat:CallShopHooks(false, traitorWeapon, ply)
    elseif detectiveWeapon ~= nil and not isnumber(tonumber(detectiveWeapon)) then
        ply:Give(detectiveWeapon)
        Randomat:CallShopHooks(false, detectiveWeapon, ply)
    else
        -- Else try giving the weapon as a passive item in the detective or traitor buy menus
        local itemFound = false

        for _, equ in ipairs(EquipmentItems[ROLE_TRAITOR]) do
            if equ.name == name and isnumber(tonumber(equ.id)) then
                id = equ.id
                ply:GiveEquipmentItem(tonumber(id))
                Randomat:CallShopHooks(true, id, ply)
                itemFound = true
                break
            end
        end

        if itemFound then return end

        for _, equ in ipairs(EquipmentItems[ROLE_DETECTIVE]) do
            if equ.name == name and isnumber(tonumber(equ.id)) then
                id = equ.id
                ply:GiveEquipmentItem(tonumber(id))
                Randomat:CallShopHooks(true, id, ply)
                itemFound = true
                break
            end
        end

        if itemFound then return end
        -- If that fails, simply print a message in chat to the player
        ply:ChatPrint("The equipment '" .. name .. "' you were supposed to be given wasn't found...")
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

function IsBuyableItem(role, wep, includeWepsExist, excludeWepsExist)
    --when player buys an item, first check if its on the SWEP list
    local classname = wep.ClassName
    local id = wep.id

    if isstring(classname) and wep.CanBuy then
        -- Also take into account the weapon exclude and include lists from Custom Roles, if they exist
        if includeWepsExist then
            for i, includedWep in ipairs(WEPS.BuyableWeapons[role]) do
                if classname == includedWep then return true end
            end
        end

        if excludeWepsExist then
            for i, excludedWep in ipairs(WEPS.ExcludeWeapons[role]) do
                if classname == excludedWep then return false end
            end
        end

        if table.HasValue(wep.CanBuy, role) then return true end
        --if its not on the SWEP list, then check the equipment item menu for the role
    elseif isnumber(id) then
        id = tonumber(id)

        if includeWepsExist then
            for i, includedWep in ipairs(WEPS.BuyableWeapons[role]) do
                if id == includedWep then return true end
            end
        end

        if excludeWepsExist then
            for i, excludedWep in ipairs(WEPS.ExcludeWeapons[role]) do
                if id == excludedWep then return false end
            end
        end

        return true
    end

    return false
end

-- Function to set/reset playermodels without having to deal with networking
-- Other than avoiding jankyness with the timing of net messages, 
-- this function ensures playermodel changing randomats reset players to their actual playermodels
-- when multiple playermodel changing randomats trigger in one round
local playermodels = {}
local viewOffsets = {}
local viewOffsetsDucked = {}

hook.Add("TTTBeginRound", "RandomatGetBeginPlayermodels", function()
    for _, ply in ipairs(player.GetAll()) do
        playermodels[ply] = ply:GetModel()
        viewOffsets[ply] = ply:GetViewOffset()
        viewOffsetsDucked[ply] = ply:GetViewOffsetDucked()
    end
end)

function ForceSetPlayermodel(ply, model, viewOffset, viewOffsetDucked)
    if IsPlayer(ply) then
        if util.IsValidModel(model) then
            FindMetaTable("Entity").SetModel(ply, model)
        end

        timer.Simple(0, function()
            if viewOffset then
                ply:SetViewOffset(viewOffset)
            else
                ply:SetViewOffset(Vector(0, 0, 64))
            end

            if viewOffsetDucked then
                ply:SetViewOffsetDucked(viewOffsetDucked)
            else
                ply:SetViewOffsetDucked(Vector(0, 0, 28))
            end
        end)
    end
end

function ForceResetAllPlayermodels()
    for _, ply in ipairs(player.GetAll()) do
        if playermodels[ply] then
            ForceSetPlayermodel(ply, playermodels[ply], viewOffsets[ply], viewOffsetsDucked[ply])
        end
    end
end