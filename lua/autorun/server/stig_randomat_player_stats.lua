local randomatPlayerStats = {}

function GetRandomatPlayerStats()
    return randomatPlayerStats
end

local fileContent

-- Because loadout items weren't skipped in previous versions, we're using a new stats file name to abandon that dirty data
-- Basically everyone's recorded most bought item was the body armour as a result... (basic detective loadout item)
if file.Exists("randomat/playerstats2.txt", "DATA") then
    -- Read stats file if it exists
    fileContent = file.Read("randomat/playerstats2.txt")
    randomatPlayerStats = util.JSONToTable(fileContent) or {}
else
    -- Create stats file
    file.CreateDir("randomat")
    file.Write("randomat/playerstats2.txt", randomatPlayerStats)
end

-- Setup all entries for every player as they connect
-- This ensures all players have every needed key in the stats table, so it's easier to avoid indexing nil in a table and getting an error
hook.Add("PlayerInitialSpawn", "RandomatStatsFillPlayerIDs", function(ply, transition)
    local plyID = ply:SteamID()

    if not randomatPlayerStats[plyID] then
        randomatPlayerStats[plyID] = {}
    end

    if not randomatPlayerStats[plyID]["EquipmentItems"] then
        randomatPlayerStats[plyID]["EquipmentItems"] = {}
    end

    if not randomatPlayerStats[plyID]["DetectiveWins"] then
        randomatPlayerStats[plyID]["DetectiveWins"] = 0
    end

    if not randomatPlayerStats[plyID]["DetectiveRounds"] then
        randomatPlayerStats[plyID]["DetectiveRounds"] = 0
    end

    if not randomatPlayerStats[plyID]["TraitorPartnerWins"] then
        randomatPlayerStats[plyID]["TraitorPartnerWins"] = {}
    end

    if not randomatPlayerStats[plyID]["TraitorPartnerRounds"] then
        randomatPlayerStats[plyID]["TraitorPartnerRounds"] = {}
    end
end)

-- Keeps track of the number of times any player has bought any one buy menu item, if they're a traitor or detective
hook.Add("TTTOrderedEquipment", "RandomatStatsOrderedEquipment", function(ply, equipment, is_item, given_by_randomat)
    timer.Simple(0.1, function()
        -- Items given by randomats aren't bought by the player, so they shouldn't count
        if given_by_randomat or GetGlobalBool("DisableRandomatStats") or not IsValid(ply) then return end
        local plyID = ply:SteamID()

        -- Passive items are indexed by their print name, if it exists
        if is_item then
            equipment = tonumber(equipment)

            if equipment then
                equipment = math.floor(equipment)
            else
                -- If is_item is truthy but the passed equipment failed to be converted to a number then something went wrong here
                return
            end

            -- If the item isn't found in the detective or traitor equipment tables then abort
            local traitorItem = GetEquipmentItem(ROLE_TRAITOR, equipment)
            local detectiveItem = GetEquipmentItem(ROLE_DETECTIVE, equipment)
            local item = detectiveItem or traitorItem
            if not item then return end
            -- Don't count loadout items towards stats
            if Randomat:IsTraitorTeam(ply) and traitorItem and traitorItem.loadout then return end
            if Randomat:IsGoodDetectiveLike(ply) and detectiveItem and detectiveItem.loadout then return end

            -- Recording passive item as bought
            if item and item.name then
                if not randomatPlayerStats[plyID]["EquipmentItems"][item.name] then
                    randomatPlayerStats[plyID]["EquipmentItems"][item.name] = 0
                end

                randomatPlayerStats[plyID]["EquipmentItems"][item.name] = randomatPlayerStats[plyID]["EquipmentItems"][item.name] + 1
            end
        else
            -- Active items are indexed by their classname, which this hook passes by itself
            if not randomatPlayerStats[plyID]["EquipmentItems"][equipment] then
                randomatPlayerStats[plyID]["EquipmentItems"][equipment] = 0
            end

            randomatPlayerStats[plyID]["EquipmentItems"][equipment] = randomatPlayerStats[plyID]["EquipmentItems"][equipment] + 1
        end
    end)
end)

-- Record detective and traitor wins at the end of each round
hook.Add("TTTEndRound", "RandomatStatsRoundWinners", function(winType)
    if GetGlobalBool("DisableRandomatStats") then return end
    local traitors = {}

    for _, ply in ipairs(player.GetAll()) do
        local plyID = ply:SteamID()

        if Randomat:IsGoodDetectiveLike(ply) then
            if not randomatPlayerStats[plyID]["DetectiveRounds"] then
                randomatPlayerStats[plyID]["DetectiveRounds"] = 0
            end

            randomatPlayerStats[plyID]["DetectiveRounds"] = randomatPlayerStats[plyID]["DetectiveRounds"] + 1

            if winType == WIN_INNOCENT then
                if not randomatPlayerStats[plyID]["DetectiveWins"] then
                    randomatPlayerStats[plyID]["DetectiveWins"] = 0
                end

                randomatPlayerStats[plyID]["DetectiveWins"] = randomatPlayerStats[plyID]["DetectiveWins"] + 1
            end
        elseif Randomat:IsTraitorTeam(ply) then
            table.insert(traitors, ply)
        end
    end

    for _, traitor in ipairs(traitors) do
        local plyID = traitor:SteamID()

        for _, traitorPartner in ipairs(traitors) do
            if traitor ~= traitorPartner then
                local partnerID = traitorPartner:SteamID()

                if not randomatPlayerStats[plyID]["TraitorPartnerRounds"][partnerID] then
                    randomatPlayerStats[plyID]["TraitorPartnerRounds"][partnerID] = 0
                end

                randomatPlayerStats[plyID]["TraitorPartnerRounds"][partnerID] = randomatPlayerStats[plyID]["TraitorPartnerRounds"][partnerID] + 1

                if winType == WIN_TRAITOR then
                    if not randomatPlayerStats[plyID]["TraitorPartnerWins"][partnerID] then
                        randomatPlayerStats[plyID]["TraitorPartnerWins"][partnerID] = 0
                    end

                    randomatPlayerStats[plyID]["TraitorPartnerWins"][partnerID] = randomatPlayerStats[plyID]["TraitorPartnerWins"][partnerID] + 1
                end
            end
        end
    end
end)

-- Record all stats in the stats file when server shuts down/changes maps
hook.Add("ShutDown", "RecordStigRandomatStats", function()
    if GetGlobalBool("DisableRandomatStats") then return end
    fileContent = util.TableToJSON(randomatPlayerStats, false)
    file.Write("randomat/playerstats2.txt", fileContent)
end)