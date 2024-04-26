local EVENT = {}

CreateConVar("randomat_favouritesleast_given_items_count", "2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How many items to give out", 1, 10)

local function GetDescription()
    local count = GetConVar("randomat_favouritesleast_given_items_count"):GetInt()

    if count == 1 then
        return "Get an item you've never bought before, but what happens when you've bought everything?"
    else
        return "Get " .. GetConVar("randomat_favouritesleast_given_items_count"):GetInt() .. " items you've never bought before, but what happens when you've bought everything?"
    end
end

EVENT.Title = "Everyone has their least favourites"
EVENT.Description = GetDescription()
EVENT.id = "favouritesleast"

EVENT.Categories = {"stats", "eventtrigger", "item", "moderateimpact"}

-- Let this randomat trigger again at the start of a new map
local eventTriggered = false

function EVENT:Begin()
    -- This randomat can only trigger once per map
    eventTriggered = true
    self.Description = GetDescription()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = GetRandomatPlayerStats()
    -- Randomat:GetTraitorDetectiveBuyable() is from stig_randomat_server_functions.lua
    local buyableEquipment = table.GetKeys(Randomat:GetTraitorDetectiveBuyable())
    local boughtAllPlys = {}

    for _, ply in pairs(self:GetAlivePlayers()) do
        local equipmentStats = table.Copy(stats[ply:SteamID()]["EquipmentItems"])
        local boughtEquipment = table.GetKeys(equipmentStats)
        local unboughtEquipment = table.Copy(buyableEquipment)

        -- Remove all bought weapons from the unboughtEquipment table
        -- Doing it this way avoids counting traitor items that have been since removed from the server counting towards the total number bought
        for _, equ in ipairs(boughtEquipment) do
            table.RemoveByValue(unboughtEquipment, equ)
        end

        if table.IsEmpty(unboughtEquipment) or unboughtEquipment == {} then
            ply:PrintMessage(HUD_PRINTTALK, "For buying every detective/traitor item at least once,\nyou get to make a randomat at the start of each round,\nuntil the next map!")
            -- This table is needed in case multiple players bought everything
            -- in which case, a random player will be chosen out of each of them to make a randomat at the start of each round
            table.insert(boughtAllPlys, ply)
            continue
        end

        -- Shuffle the table and only give out as many items as the player has unbought
        -- So if the player has 1 unbought item, they should get 1 item
        local itemCount = math.min(GetConVar("randomat_favouritesleast_given_items_count"):GetInt(), #unboughtEquipment)
        table.Shuffle(unboughtEquipment)

        -- Giving unbought items, if any
        for i = 1, itemCount do
            Randomat:GivePassiveOrActiveItem(ply, unboughtEquipment[i], true)
        end
    end

    if not table.IsEmpty(boughtAllPlys) and boughtAllPlys ~= {} then
        -- Displays a randomat alert and message to chat for everyone displaying which players have bought all weapons
        timer.Simple(5, function()
            Randomat:SmallNotify("One or more players bought 'em all!")
            PrintMessage(HUD_PRINTTALK, "Players who have bought every traitor/detective item at least once:")

            for _, ply in ipairs(boughtAllPlys) do
                PrintMessage(HUD_PRINTTALK, ply:Nick())
            end
        end)

        timer.Simple(10, function()
            Randomat:SmallNotify("They now get to make a randomat at the start of every round, for the rest of the map!")
        end)

        -- At the start of every round, for the rest of the current map, a random player that bought every weapon gets to make the randomat for that round
        hook.Add("TTTRandomatShouldAuto", "FavouritesleastPreventAutoRandomat", function(id, owner) return false end)

        hook.Add("TTTBeginRound", "FavouritesleastRandomat", function()
            local rdmPly = boughtAllPlys[math.random(#boughtAllPlys)]
            rdmPly:ChatPrint("Make a randomat because you bought 'em all!")
            Randomat:SilentTriggerEvent("make", rdmPly)
        end)
    end
end

function EVENT:Condition()
    return not eventTriggered
end

-- This event can only trigger once a map to prevent multiple people making randomats at once
function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"given_items_count"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)
            convar:Revert()

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