util.AddNetworkString("RandomatGetEquipmentPrintNames")
util.AddNetworkString("RandomatReceiveEquipmentPrintName")
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
    -- Getting the printnames of all weapons and equipment off the client and on the server
    net.Start("RandomatGetEquipmentPrintNames")
    net.Send(Entity(1))
    hook.Remove("TTTPrepareRound", "RandomatGetEquipmentPrintNames")

    -- Getting the lists of all buyable equipment by detectives and traitors
    -- First check if its on the SWEP list
    for _, SWEP in pairs(weapons.GetList()) do
        if IsBuyableItem(ROLE_TRAITOR, SWEP) then
            traitorBuyable[SWEP.ClassName] = true
        elseif IsBuyableItem(ROLE_DETECTIVE, SWEP) then
            detectiveBuyable[SWEP.ClassName] = true
        end
    end

    -- If its not on the SWEP list, then check the equipment items table
    for _, item in pairs(EquipmentItems[ROLE_TRAITOR]) do
        if IsBuyableItem(ROLE_TRAITOR, item) then
            -- Use name and not ID because this is used for randomat stats and we need a unique identifier
            -- If equipment items are uninstalled from the server, old equipment could start using IDs previously held by other equipment
            -- And thus stats could become mixed with another equipment's stats
            traitorBuyable[item.name] = true
        end
    end

    for _, item in pairs(EquipmentItems[ROLE_DETECTIVE]) do
        if IsBuyableItem(ROLE_DETECTIVE, item) then
            -- Use name and not ID because this is used for randomat stats and we need a unique identifier
            -- If equipment items are uninstalled from the server, old equipment could start using IDs previously held by other equipment
            -- And thus stats could become mixed with another equipment's stats
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

function GetTraitorBuyable()
    return traitorBuyable
end

function GetDetectiveBuyable()
    return detectiveBuyable
end

function GetTraitorDetectiveBuyable()
    return traitorDetectiveBuyable
end

local equPrintNames = {}

net.Receive("RandomatReceiveEquipmentPrintName", function(len, ply)
    local id = net.ReadString()
    local printname = net.ReadString()
    equPrintNames[id] = printname
end)

function GetEquipmentPrintName(id)
    id = tostring(id)

    return equPrintNames[id]
end

-- Choosing an arbitrary weapon kind so all weapons get given regardless of weapon slots
local wepKind = 103

function GivePassiveOrActiveItem(ply, equipment, printChat)
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

    if printChat then
        timer.Simple(5, function()
            local name

            if itemID then
                name = GetEquipmentPrintName(tostring(itemID))
            else
                name = GetEquipmentPrintName(equipment)
            end

            ply:ChatPrint("You received a " .. name .. "!")
        end)
    end

    return givenItem
end

function SetToBasicRole(ply)
    if Randomat:IsTraitorTeam(ply) then
        Randomat:SetRole(ply, ROLE_TRAITOR)
    elseif Randomat:IsGoodDetectiveLike(ply) then
        Randomat:SetRole(ply, ROLE_DETECTIVE)
    else
        Randomat:SetRole(ply, ROLE_INNOCENT)
    end

    ply:Give("weapon_zm_improvised")
    ply:Give("weapon_zm_carry")
    ply:Give("weapon_ttt_unarmed")
end

function IsBodyDependentRole(ply)
    local role = ply:GetRole()
    if role == ROLE_PARASITE and ConVarExists("ttt_parasite_respawn_mode") and GetConVar("ttt_parasite_respawn_mode"):GetInt() == 1 then return true end

    return role == ROLE_MADSCIENTIST or role == ROLE_HYPNOTIST or role == ROLE_BODYSNATCHER or role == ROLE_PARAMEDIC or role == ROLE_PHANTOM or role == ROLE_TAXIDERMIST
end

function SpectatorRandomatAlert(ply, EVENT)
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

function DisableRoundEndSounds()
    -- Disables round end sounds mod and 'Ending Flair' event
    -- So events that that play sounds at the end of the round can do so without overlapping with other sounds/music
    SetGlobalBool("StopEndingFlairRandomat", true)
    local roundEndSounds = false

    if ConVarExists("ttt_roundendsounds") and GetConVar("ttt_roundendsounds"):GetBool() then
        GetConVar("ttt_roundendsounds"):SetBool(false)
        roundEndSounds = true
    end

    hook.Add("TTTEndRound", "RandomatReenableRoundEndSounds", function()
        -- Re-enable round end sounds and 'Ending Flair' event
        timer.Simple(1, function()
            SetGlobalBool("StopEndingFlairRandomat", false)

            -- Don't turn on round end sounds if they weren't on already
            if roundEndSounds then
                GetConVar("ttt_roundendsounds"):SetBool(true)
            end
        end)

        hook.Remove("TTTEndRound", "RandomatReenableRoundEndSounds")
    end)
end