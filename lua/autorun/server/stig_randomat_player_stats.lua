-- Stats table is global, so any mod can use it
randomatPlayerStats = {}
local fileContent

-- Create stats file if it doesn't exist
if file.Exists("randomat/playerstats.txt", "DATA") then
    fileContent = file.Read("randomat/playerstats.txt")
    randomatPlayerStats = util.JSONToTable(fileContent) or {}
else
    file.CreateDir("randomat")
    file.Write("randomat/playerstats.txt", randomatPlayerStats)
end

-- Setup all entries for every player as they connect
-- This *should* ensure all players have every needed key in the stats table, so we should never try to index a nil value in the table
hook.Add("PlayerInitialSpawn", "RandomatStatsFillPlayerIDs", function(ply, transition)
    local ID = ply:SteamID()

    if not randomatPlayerStats[ID] then
        randomatPlayerStats[ID] = {}
    end

    if not randomatPlayerStats[ID]["EquipmentItems"] then
        randomatPlayerStats[ID]["EquipmentItems"] = {}
    end

    if not randomatPlayerStats[ID]["DetectiveWins"] then
        randomatPlayerStats[ID]["DetectiveWins"] = 0
    end

    if not randomatPlayerStats[ID]["DetectiveRounds"] then
        randomatPlayerStats[ID]["DetectiveRounds"] = 0
    end

    if not randomatPlayerStats[ID]["TraitorPartnerWins"] then
        randomatPlayerStats[ID]["TraitorPartnerWins"] = {}
    end

    if not randomatPlayerStats[ID]["TraitorPartnerRounds"] then
        randomatPlayerStats[ID]["TraitorPartnerRounds"] = {}
    end
end)

-- Keeps track of the number of times any player has bought any one buy menu item
hook.Add("TTTOrderedEquipment", "RandomatStatsOrderedEquipment", function(ply, equipment, is_item, given_by_randomat)
    -- Items given by randomats aren't bought by the player, so they shouldn't count
    if given_by_randomat or GetGlobalBool("DisableRandomatStats") then return end
    local ID = ply:SteamID()

    -- Passive items are indexed by their print name, if it exists
    if is_item then
        equipment = tonumber(equipment)

        if equipment then
            equipment = math.floor(equipment)
        else
            -- If is_item is truthy but the passed equipment failed to be converted to a number then something went wrong here
            return
        end

        local itemTable = GetEquipmentItem(ROLE_DETECTIVE, equipment) or GetEquipmentItem(ROLE_TRAITOR, equipment)
        -- Don't count loadout items towards stats
        if itemTable.loadout then return end
        local itemName

        if itemTable then
            itemName = itemTable.name
        end

        if itemName then
            local equipmentCount = randomatPlayerStats[ID]["EquipmentItems"][itemName]

            if equipmentCount then
                equipmentCount = equipmentCount + 1
                randomatPlayerStats[ID]["EquipmentItems"][itemName] = equipmentCount
            else
                randomatPlayerStats[ID]["EquipmentItems"][itemName] = 1
            end
        end
    else
        -- Active items are indexed by their classname, which this hook passes by itself
        local equipmentCount = randomatPlayerStats[ID]["EquipmentItems"][equipment]

        if equipmentCount then
            equipmentCount = equipmentCount + 1
            randomatPlayerStats[ID]["EquipmentItems"][equipment] = equipmentCount
        else
            randomatPlayerStats[ID]["EquipmentItems"][equipment] = 1
        end
    end
end)

-- Record player wins at the end of each round
hook.Add("TTTEndRound", "RandomatStatsRoundWinners", function(winType)
    if GetGlobalBool("DisableRandomatStats") then return end
    local traitors = {}

    for _, ply in ipairs(player.GetAll()) do
        local ID = ply:SteamID()

        if Randomat:IsGoodDetectiveLike(ply) then
            if randomatPlayerStats[ID]["DetectiveRounds"] then
                randomatPlayerStats[ID]["DetectiveRounds"] = randomatPlayerStats[ID]["DetectiveRounds"] + 1
            else
                randomatPlayerStats[ID]["DetectiveRounds"] = 1
            end

            if winType == WIN_INNOCENT then
                if randomatPlayerStats[ID]["DetectiveWins"] then
                    randomatPlayerStats[ID]["DetectiveWins"] = randomatPlayerStats[ID]["DetectiveWins"] + 1
                else
                    randomatPlayerStats[ID]["DetectiveWins"] = 1
                end
            end
        elseif Randomat:IsTraitorTeam(ply) then
            table.insert(traitors, ply)
        end
    end

    for _, traitor in ipairs(traitors) do
        local ID = traitor:SteamID()

        for _, traitorPartner in ipairs(traitors) do
            if traitor ~= traitorPartner then
                local partnerID = traitorPartner:SteamID()

                if randomatPlayerStats[ID]["TraitorPartnerRounds"][partnerID] then
                    randomatPlayerStats[ID]["TraitorPartnerRounds"][partnerID] = randomatPlayerStats[ID]["TraitorPartnerRounds"][partnerID] + 1
                else
                    randomatPlayerStats[ID]["TraitorPartnerRounds"][partnerID] = 1
                end

                if winType == WIN_TRAITOR then
                    if randomatPlayerStats[ID]["TraitorPartnerWins"][partnerID] then
                        randomatPlayerStats[ID]["TraitorPartnerWins"][partnerID] = randomatPlayerStats[ID]["TraitorPartnerWins"][partnerID] + 1
                    else
                        randomatPlayerStats[ID]["TraitorPartnerWins"][partnerID] = 1
                    end
                end
            end
        end
    end
end)

-- Record all stats in the stats file when server shuts down/changes maps
hook.Add("ShutDown", "RecordStigRandomatStats", function()
    if GetGlobalBool("DisableRandomatStats") then return end
    fileContent = util.TableToJSON(randomatPlayerStats, true)
    file.Write("randomat/playerstats.txt", fileContent)
end)