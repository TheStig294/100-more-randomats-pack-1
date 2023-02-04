-- Seeding random numbers in Garry's Mod to help with the same randomats being picked over and over, running only once
math.randomseed(os.time())

-- Pre-emptively calculating unused random numbers to improve the randomness when math.random() is actually used
for i = 1, 2000 do
    math.random()
end

-- Now disabling math.randomseed for everyone else so the good randomness just built up isn't reset
function math.randomseed(seed)
end

-- Returns whether or not the current map has a navmesh. Used for randomats that use ai-based weapons that need a navmesh to work, such as the guard dog or killer snail randomats
function Randomat:MapHasAI()
    return file.Exists("maps/" .. game.GetMap() .. ".nav", "GAME")
end

-- Takes 2 players and checks if they are on the same team, checking one team at a time
function Randomat:IsSameTeam(attacker, victim)
    if (Randomat:IsInnocentTeam(attacker, false) and Randomat:IsInnocentTeam(victim, false)) or (Randomat:IsTraitorTeam(attacker) and Randomat:IsTraitorTeam(victim)) or (Randomat:IsMonsterTeam(attacker) and Randomat:IsMonsterTeam(victim)) then
        return true
    else
        return false
    end
end

function Randomat:IsBuyableItem(role, wep)
    if isstring(wep) then
        wep = weapons.Get(wep)
    end

    if not role or not wep then return false end
    local classname = wep.ClassName
    local id = wep.id
    local excludeWepsExist = istable(WEPS.ExcludeWeapons) and istable(WEPS.ExcludeWeapons[role])
    local includeWepsExist = istable(WEPS.BuyableWeapons) and istable(WEPS.BuyableWeapons[role])

    -- Checking if item is an active item
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
        -- Checking if item is a passive item
    elseif isnumber(id) then
        id = tonumber(id)
        -- Loadout items cannot be bought as they are automatically given
        local item = GetEquipmentItem(role, id)
        if item.loadout then return false end
        if not item.name then return false end

        if includeWepsExist then
            for i, includedWep in ipairs(WEPS.BuyableWeapons[role]) do
                if item.name == includedWep then return true end
            end
        end

        if excludeWepsExist then
            for i, excludedWep in ipairs(WEPS.ExcludeWeapons[role]) do
                if item.name == excludedWep then return false end
            end
        end

        return true
    end

    return false
end

-- Functions to set/reset playermodels without having to deal with networking
-- Other than avoiding jankyness with the timing of net messages, 
-- this function ensures playermodel changing randomats reset players to their actual playermodels
-- when multiple playermodel changing randomats trigger in one round
function Randomat:GetPlayerModelData(ply)
    local data = {}
    data.model = ply:GetModel()
    data.viewOffset = ply:GetViewOffset()
    data.viewOffsetDucked = ply:GetViewOffsetDucked()
    data.playerColor = ply:GetPlayerColor()
    data.skin = ply:GetSkin()
    data.bodyGroups = ply:GetBodyGroups()
    data.bodygroupValues = {}

    for _, value in ipairs(ply:GetBodyGroups()) do
        data.bodygroupValues[value.id] = ply:GetBodygroup(value.id)
    end

    return data
end

local function SetHands(ent, model)
    if not IsValid(ent) then return end
    local simpleModelName = player_manager.TranslateToPlayerModelName(model)
    local handsData = player_manager.TranslatePlayerHands(simpleModelName)

    if handsData then
        ent:SetModel(handsData.model)
        ent:SetSkin(handsData.skin)
        ent:SetBodyGroups(handsData.body)
    end
end

function Randomat:ForceSetPlayermodel(ply, data)
    if IsPlayer(ply) then
        -- If just a model by itself is passed, just set the model and leave it at that
        if not istable(data) then
            if (not isstring(data)) or not util.IsValidModel(data) then return end
            FindMetaTable("Entity").SetModel(ply, data)
            SetHands(ply:GetHands(), data)

            return
        end

        -- Else, set everything that's in the data table
        if util.IsValidModel(data.model) then
            FindMetaTable("Entity").SetModel(ply, data.model)
            SetHands(ply:GetHands(), data.model)
        end

        if data.playerColor then
            ply:SetPlayerColor(data.playerColor)
        end

        if data.skin then
            ply:SetSkin(data.skin)
        end

        if data.bodyGroups then
            for _, value in pairs(data.bodyGroups) do
                ply:SetBodygroup(value.id, data.bodygroupValues[value.id])
            end
        elseif data.bodygroupValues then
            for id = 0, #data.bodygroupValues do
                ply:SetBodygroup(id, data.bodygroupValues[id])
            end
        end

        timer.Simple(0.1, function()
            if data.viewOffset then
                ply:SetViewOffset(data.viewOffset)
            else
                ply:SetViewOffset(Vector(0, 0, 64))
            end

            if data.viewOffsetDucked then
                ply:SetViewOffsetDucked(data.viewOffsetDucked)
            else
                ply:SetViewOffsetDucked(Vector(0, 0, 28))
            end
        end)
    end
end

local playermodelData = {}

hook.Add("TTTBeginRound", "RandomatGetBeginPlayermodels", function()
    for _, ply in ipairs(player.GetAll()) do
        playermodelData[ply] = Randomat:GetPlayerModelData(ply)
    end
end)

function Randomat:ForceResetAllPlayermodels()
    for _, ply in ipairs(player.GetAll()) do
        if playermodelData[ply] then
            Randomat:ForceSetPlayermodel(ply, playermodelData[ply])
        end
    end
end

function Randomat:IsMeleeDamageRole(ply)
    local role = ply:GetRole()

    return role == ROLE_ZOMBIE or role == ROLE_KILLER or role == ROLE_MADSCIENTIST
end

function Randomat:IsKillCommandSensitiveRole(ply)
    local role = ply:GetRole()

    return role == ROLE_MADSCIENTIST or role == ROLE_ZOMBIE or role == ROLE_PARASITE or role == ROLE_REVENGER or role == ROLE_PHANTOM
end

function Randomat:MapHasProps()
    local propCount = table.Count(ents.FindByClass("prop_physics*")) + table.Count(ents.FindByClass("prop_dynamic"))

    return propCount > 5
end