Randomat = Randomat or {}
-- Seeding random numbers in Garry's Mod to help with the same randomats being picked over and over, running only once
math.randomseed(os.time())

-- Pre-emptively calculating unused random numbers to improve the randomness when math.random() is actually used
for i = 1, 1000 do
    math.random()
end

-- Now disabling math.randomseed for everyone else so the good randomness just built up isn't reset
function math.randomseed(seed)
end

-- Returns whether or not the current map has a navmesh. Used for randomats that use ai-based weapons that need a navmesh to work, such as the guard dog or killer snail randomats
function Randomat:MapHasAI()
    return file.Exists("maps/" .. game.GetMap() .. ".nav", "GAME")
end

function Randomat:IsSameTeam(attacker, victim)
    -- First check if CR's plymeta:IsSameTeam() is available, and if so, just use that
    if attacker.IsSameTeam and isfunction(attacker.IsSameTeam) then
        return attacker:IsSameTeam(victim)
    else
        -- Else use the randomat's in-built team functions
        if (Randomat:IsInnocentTeam(attacker, false) and Randomat:IsInnocentTeam(victim, false)) or (Randomat:IsTraitorTeam(attacker) and Randomat:IsTraitorTeam(victim)) or (Randomat:IsMonsterTeam(attacker) and Randomat:IsMonsterTeam(victim)) then
            return true
        else
            return false
        end
    end
end

-- Checking if an item is in a role's buy menu,
-- and hasn't been edited out, or has been edited in, using Custom Role's buy menu editing system
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

function Randomat:HandleReplicatedValue(onreplicated, onglobal)
    if isfunction(CRVersion) and CRVersion("1.9.3") then return onreplicated() end

    return onglobal()
end