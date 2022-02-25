local EVENT = {}

CreateConVar("randomat_favourites_given_items_count", "2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How many most bought items to give out", 1, 10)

local function GetDescription()
    local count = GetConVar("randomat_favourites_given_items_count"):GetInt()

    if count == 1 then
        return "Everyone gets their most bought item!"
    else
        return "Everyone gets their " .. GetConVar("randomat_favourites_given_items_count"):GetInt() .. " most bought items!"
    end
end

EVENT.Title = "Everyone has their favourites"
EVENT.Description = GetDescription()
EVENT.id = "favourites"

function EVENT:Begin()
    self.Description = GetDescription()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = randomatPlayerStats

    for _, ply in pairs(self:GetAlivePlayers()) do
        local ID = ply:SteamID()
        local equipmentStats = table.Copy(stats[ID]["EquipmentItems"])
        -- Set every player's buy count of the radar and body armour to 1 to prevent these from always being a player's most bought item
        -- Also effectively sets the player's most bought item to the body armour and radar as a fail-safe if the player has never bought anything before
        equipmentStats["item_radar"] = 1
        equipmentStats["item_armor"] = 1
        local wepKind = 10
        local itemCount = math.min(GetConVar("randomat_favourites_given_items_count"):GetInt(), table.Count(equipmentStats))

        for i = 1, itemCount do
            local mostBoughtItem = table.GetWinningKey(equipmentStats)
            GiveEquipmentByIdOrClass(ply, mostBoughtItem, wepKind)
            equipmentStats[mostBoughtItem] = 0
            wepKind = wepKind + 1
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