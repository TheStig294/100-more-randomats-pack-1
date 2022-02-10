net.Receive("RandomatDetectiveWeaponsList", function()
    local error = false
    local excludeWepsExist = istable(WEPS.ExcludeWeapons) and istable(WEPS.ExcludeWeapons[ROLE_DETECTIVE])
    local includeWepsExist = istable(WEPS.BuyableWeapons) and istable(WEPS.BuyableWeapons[ROLE_DETECTIVE])

    --when player buys an item, first check if its on the SWEP list
    for k, v in pairs(weapons.GetList()) do
        if IsBuyableItem(ROLE_DETECTIVE, v, includeWepsExist, excludeWepsExist) then
            net.Start("Randomat_SendDetectiveEquipmentName")
            net.WriteString(v.PrintName .. "," .. v.ClassName)
            net.WriteBool(error)
            net.SendToServer()
        end
    end

    --if its not on the SWEP list, then check the equipment item menu for the role
    for k, v in pairs(EquipmentItems[ROLE_DETECTIVE]) do
        if IsBuyableItem(ROLE_DETECTIVE, v, includeWepsExist, excludeWepsExist) then
            net.Start("Randomat_SendDetectiveEquipmentName")
            net.WriteString(v.name .. "," .. v.id)
            net.WriteBool(error)
            net.SendToServer()
        end
    end
end)

net.Receive("RandomatTraitorWeaponsList", function()
    local error = false
    local excludeWepsExist = istable(WEPS.ExcludeWeapons) and istable(WEPS.ExcludeWeapons[ROLE_TRAITOR])
    local includeWepsExist = istable(WEPS.BuyableWeapons) and istable(WEPS.BuyableWeapons[ROLE_TRAITOR])

    --when player buys an item, first check if its on the SWEP list
    for k, v in pairs(weapons.GetList()) do
        if IsBuyableItem(ROLE_TRAITOR, v, includeWepsExist, excludeWepsExist) then
            net.Start("Randomat_SendTraitorEquipmentName")
            net.WriteString(v.PrintName .. "," .. v.ClassName)
            net.WriteBool(error)
            net.SendToServer()
        end
    end

    --if its not on the SWEP list, then check the equipment item menu for the role
    for k, v in pairs(EquipmentItems[ROLE_TRAITOR]) do
        if IsBuyableItem(ROLE_TRAITOR, v, includeWepsExist, excludeWepsExist) then
            net.Start("Randomat_SendTraitorEquipmentName")
            net.WriteString(v.name .. "," .. v.id)
            net.WriteBool(error)
            net.SendToServer()
        end
    end
end)

local detectiveBuyable = {}
local traitorBuyable = {}

hook.Add("TTTPrepareRound", "RandomatPrimeBuyableLists", function()
    local excludeWepsExist = istable(WEPS.ExcludeWeapons) and istable(WEPS.ExcludeWeapons[ROLE_TRAITOR])
    local includeWepsExist = istable(WEPS.BuyableWeapons) and istable(WEPS.BuyableWeapons[ROLE_TRAITOR])

    --when player buys an item, first check if its on the SWEP list
    for k, v in pairs(weapons.GetList()) do
        if IsBuyableItem(ROLE_DETECTIVE, v, includeWepsExist, excludeWepsExist) then
            table.insert(detectiveBuyable, v.ClassName)
        elseif IsBuyableItem(ROLE_TRAITOR, v, includeWepsExist, excludeWepsExist) then
            table.insert(traitorBuyable, v.ClassName)
        end
    end

    --if its not on the SWEP list, then check the equipment item menu for the role
    for k, v in pairs(EquipmentItems[ROLE_DETECTIVE]) do
        if IsBuyableItem(ROLE_DETECTIVE, v, includeWepsExist, excludeWepsExist) then
            table.insert(detectiveBuyable, v.id)
        end
    end

    for k, v in pairs(EquipmentItems[ROLE_TRAITOR]) do
        if IsBuyableItem(ROLE_TRAITOR, v, includeWepsExist, excludeWepsExist) then
            table.insert(traitorBuyable, v.id)
        end
    end

    hook.Remove("TTTPrepareRound", "RandomatPrimeBuyableLists")
end)

function GetDetectiveBuyable()
    return detectiveBuyable
end

function GetTraitorBuyable()
    return traitorBuyable
end

function Randomat:register(tbl)
end