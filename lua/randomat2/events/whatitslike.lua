local EVENT = {}
CreateConVar("randomat_whatitslike_given_items_count", "2", FCVAR_NONE, "How many most bought items to give out", 1, 10)

local function GetDescription()
    local count = GetConVar("randomat_favourites_given_items_count"):GetInt()

    if count == 1 then
        return "Everyone gets someone's playermodel and their most bought item!"
    else
        return "Everyone gets someone's playermodel and their " .. GetConVar("randomat_favourites_given_items_count"):GetInt() .. " most bought items!"
    end
end

util.AddNetworkString("WhatItsLikeRandomatHideNames")
util.AddNetworkString("WhatItsLikeRandomatEnd")
EVENT.Title = ""
EVENT.id = "whatitslike"
EVENT.Description = GetDescription()
EVENT.AltTitle = "What it's like to be..."

EVENT.Categories = {"stats", "modelchange", "item", "largeimpact"}

CreateConVar("randomat_whatitslike_disguise", 0, FCVAR_NONE, "Hide player names")

function EVENT:Begin()
    self.Description = GetDescription()
    local randomPly = self:GetAlivePlayers(true)[1]
    Randomat:EventNotifySilent("What it's like to be " .. randomPly:Nick())
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = GetRandomatPlayerStats()
    local ID = randomPly:SteamID()
    local equipmentStats = table.Copy(stats[ID]["EquipmentItems"])
    -- Set buy count of the radar and body armour to 1 to prevent these from always being a player's most bought item
    -- Also effectively sets the player's most bought item to the body armour and radar as a fail-safe if the player has never bought anything before
    equipmentStats["item_radar"] = 1
    equipmentStats["item_armor"] = 1
    local itemCount = math.min(GetConVar("randomat_whatitslike_given_items_count"):GetInt(), table.Count(equipmentStats))
    local mostBoughtItems = {}

    for i = 1, itemCount do
        local mostBoughtItem = table.GetWinningKey(equipmentStats)
        table.insert(mostBoughtItems, mostBoughtItem)
        equipmentStats[mostBoughtItem] = 0
    end

    local playermodelData = Randomat:GetPlayerModelData(randomPly)

    for _, ply in pairs(self:GetAlivePlayers()) do
        -- Set playermodels and hide names
        Randomat:ForceSetPlayermodel(ply, playermodelData)

        if not CR_VERSION and GetConVar("randomat_whatitslike_disguise"):GetBool() then
            -- Traitors still see names if CR is not installed
            ply:SetNWBool("disguised", true)
        end

        -- Give everyone the chosen player's most bought items
        for _, item in ipairs(mostBoughtItems) do
            Randomat:GivePassiveOrActiveItem(ply, item, true)
        end
    end

    if CR_VERSION and GetConVar("randomat_whatitslike_disguise"):GetBool() then
        net.Start("WhatItsLikeRandomatHideNames")
        net.Broadcast()
    end

    -- Sets someone's playermodel again when respawning
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            Randomat:ForceSetPlayermodel(ply, playermodelData)

            if not CR_VERSION and GetConVar("randomat_whatitslike_disguise"):GetBool() then
                ply:SetNWBool("disguised", true)
            end
        end)
    end)
end

function EVENT:End()
    Randomat:ForceResetAllPlayermodels()

    if CR_VERSION then
        net.Start("WhatItsLikeRandomatEnd")
        net.Broadcast()
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

    local checks = {}

    for _, v in pairs({"disguise"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks
end

Randomat:register(EVENT)