local EVENT = {}

CreateConVar("randomat_cupboard_given_items_count", "2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How many least bought items to give out", 1, 10)

local function GetDescription()
    local count = GetConVar("randomat_cupboard_given_items_count"):GetInt()

    if count == 1 then
        return "Everyone gets their least bought item!"
    else
        return "Everyone gets their " .. GetConVar("randomat_cupboard_given_items_count"):GetInt() .. " least bought items!"
    end
end

EVENT.Title = "Back of the Cupboard"
EVENT.Description = GetDescription()
EVENT.id = "cupboard"

EVENT.Categories = {"stats", "item", "moderateimpact"}

function EVENT:Begin()
    self.Description = GetDescription()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = GetRandomatPlayerStats()

    for _, ply in pairs(self:GetAlivePlayers()) do
        local ID = ply:SteamID()
        local equipmentStats = table.Copy(stats[ID]["EquipmentItems"])

        -- Set the body armour and radar as bought as a fail-safe if the player has never bought anything before
        if table.IsEmpty(equipmentStats) then
            equipmentStats["item_radar"] = 1
            equipmentStats["item_armor"] = 1
        end

        local itemCount = math.min(GetConVar("randomat_cupboard_given_items_count"):GetInt(), table.Count(equipmentStats))
        -- Sort the table from least to most bought
        table.sort(equipmentStats)
        local keys = table.GetKeys(equipmentStats)
        local itemGivenCount = 0

        while itemGivenCount < itemCount and next(keys) ~= nil do
            -- Attempt to get the least bought item and remove it from the table, and repeat
            local leastBoughtItem = keys[1]
            local givenItem = Randomat:GivePassiveOrActiveItem(ply, leastBoughtItem, true)

            if givenItem then
                itemGivenCount = itemGivenCount + 1
            end

            table.remove(keys, 1)
        end

        -- If all of the items the player bought before have been since removed from the server, give them a body armour and radar
        if itemGivenCount ~= itemCount then
            Randomat:GivePassiveOrActiveItem(ply, "item_radar", true)
            Randomat:GivePassiveOrActiveItem(ply, "item_armor", true)
        end
    end
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