local EVENT = {}

CreateConVar("randomat_buyemall_given_items_count", "2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How many items to give out", 1, 10)

local function GetDescription()
    local count = GetConVar("randomat_buyemall_given_items_count"):GetInt()

    if count == 1 then
        return "Get an item you've never bought before, but what happens when you buy 'em all?"
    else
        return "Get " .. GetConVar("randomat_buyemall_given_items_count"):GetInt() .. " items you've never bought before, but what happens when you buy 'em all?"
    end
end

EVENT.Title = "Gotta buy 'em all!"
EVENT.Description = GetDescription()
EVENT.id = "buyemall"
-- Let this randomat trigger again at the start of a new map
local eventTriggered = false

function EVENT:Begin()
    -- This randomat can only trigger once per map
    eventTriggered = true
    self.Description = GetDescription()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = randomatPlayerStats
    -- Functionality of GetDetectiveBuyable() and GetTraitorBuyable() can be found in stig_randomat_base_functions.lua and stig_randomat_client_functions.lua
    local detectiveBuyable = GetDetectiveBuyable()
    local traitorBuyable = GetTraitorBuyable()
    local buyableEquipment = table.GetKeys(table.Merge(detectiveBuyable, traitorBuyable))
    local boughtEmAllPlayers = {}

    for _, ply in pairs(self:GetAlivePlayers()) do
        local ID = ply:SteamID()
        local equipmentStats = table.Copy(stats[ID]["EquipmentItems"])
        local boughtEquipment = table.GetKeys(equipmentStats)
        local unboughtEquipment = table.Copy(buyableEquipment)

        for i, equipment in ipairs(unboughtEquipment) do
            local item = tonumber(equipment)

            if item then
                local name = GetEquipmentItemById(math.floor(item)).name

                if name then
                    unboughtEquipment[i] = name
                end
            end
        end

        -- Remove all bought weapons from the unboughtEquipment table
        for _, equipment in ipairs(boughtEquipment) do
            table.RemoveByValue(unboughtEquipment, equipment)
        end

        if table.IsEmpty(unboughtEquipment) then
            ply:PrintMessage(HUD_PRINTTALK, "==CONGRATS! YOU BOUGHT 'EM ALL!==\nYou get to choose a randomat at the start of each round!")
            ply:PrintMessage(HUD_PRINTCENTER, "CONGRATS! YOU BOUGHT 'EM ALL!")
            -- This table is needed in case multiple players bought everything
            -- in which case, a random player will be chosen out of each of them to choose a randomat at the start of each round
            table.insert(boughtEmAllPlayers, ply)
            continue
        end

        -- Shuffle the table and only give out as many items as the player has unbought
        -- So if the player has 1 unbought item, they should get 1 item
        local itemCount = math.min(GetConVar("randomat_buyemall_given_items_count"):GetInt(), table.Count(unboughtEquipment))
        table.Shuffle(unboughtEquipment)
        local wepKind = 10

        for i = 1, itemCount do
            GiveEquipmentByIdOrClass(ply, unboughtEquipment[i], wepKind)
            wepKind = wepKind + 1
        end
    end

    local choices = GetConVar("randomat_choose_choices"):GetInt()

    if not table.IsEmpty(boughtEmAllPlayers) then
        GetConVar("randomat_choose_choices"):SetInt(5)

        -- Displays a randomat alert and message to chat for everyone displaying which players have bought all weapons
        timer.Simple(5, function()
            Randomat:SmallNotify("One or more players bought 'em all!")
            PrintMessage(HUD_PRINTTALK, "Players who have bought every item at least once:")

            for _, ply in ipairs(boughtEmAllPlayers) do
                PrintMessage(HUD_PRINTTALK, ply:Nick())
            end
        end)

        timer.Simple(10, function()
            Randomat:SmallNotify("They now get to choose a randomat at the start of every round, for the rest of the map!")
        end)

        -- At the start of every round, for the rest of the current map, a random player that bought every weapon gets to choose the randomat for that round
        hook.Add("TTTRandomatShouldAuto", "BuyEmAllPreventAutoRandomat", function(id, owner) return false end)

        hook.Add("TTTBeginRound", "BoughtEmAllRandomat", function()
            Randomat:SilentTriggerEvent("choose", table.Random(boughtEmAllPlayers), false, false)
        end)

        hook.Add("ShutDown", "BoughtEmAllResetConvar", function()
            GetConVar("randomat_choose_choices"):SetInt(choices)
        end)
    end
end

function EVENT:Condition()
    -- This event is reliant on 'Choose an Event!' existing, can only trigger once a map, 
    -- and uses GetDetective/TraitorBuyable(), so this event cannot run before those functions are ready to use
    return Randomat:CanEventRun("choose") and DoneSendingDetectiveTraitorBuyable() and not eventTriggered
end

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