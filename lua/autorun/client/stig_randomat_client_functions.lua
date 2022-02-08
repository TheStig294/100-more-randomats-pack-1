net.Receive("RandomatDetectiveWeaponsList", function()
    local error = false
    local excludeWepsExist = istable(WEPS.ExcludeWeapons)
    local includeWepsExist = istable(WEPS.BuyableWeapons)

    --when player buys an item, first check if its on the SWEP list
    for k, v in pairs(weapons.GetList()) do
        local classname = v.ClassName
        if not isstring(classname) then continue end
        local included = false

        -- Also take into account the weapon exclude and include lists from Custom Roles, if they exist
        if includeWepsExist then
            for i, includedWep in ipairs(WEPS.BuyableWeapons[ROLE_DETECTIVE]) do
                if classname == includedWep then
                    included = true
                end
            end
        end

        if not included and excludeWepsExist and table.HasValue(v.CanBuy, ROLE_DETECTIVE) then
            for i, excludedWep in ipairs(WEPS.ExcludeWeapons[ROLE_DETECTIVE]) do
                if classname == excludedWep then
                    included = false
                end
            end
        end

        if included then
            net.Start("Randomat_SendDetectiveEquipmentName")
            net.WriteString(v.PrintName .. "," .. classname)
            net.WriteBool(error)
            net.SendToServer()
        end
    end

    --if its not on the SWEP list, then check the equipment item menu for the role
    for k, v in pairs(EquipmentItems[ROLE_DETECTIVE]) do
        if isnumber(v.id) then
            net.Start("Randomat_SendDetectiveEquipmentName")
            net.WriteString(v.name .. "," .. v.id)
            net.WriteBool(error)
            net.SendToServer()
        end
    end
end)

net.Receive("RandomatTraitorWeaponsList", function()
    local error = false
    local excludeWepsExist = istable(WEPS.ExcludeWeapons)
    local includeWepsExist = istable(WEPS.BuyableWeapons)

    --when player buys an item, first check if its on the SWEP list
    for k, v in pairs(weapons.GetList()) do
        local classname = v.ClassName
        if not isstring(classname) then continue end
        local included = false

        -- Also take into account the weapon exclude and include lists from Custom Roles, if they exist
        if includeWepsExist then
            for i, includedWep in ipairs(WEPS.BuyableWeapons[ROLE_TRAITOR]) do
                if classname == includedWep then
                    included = true
                end
            end
        end

        if not included and excludeWepsExist and table.HasValue(v.CanBuy, ROLE_TRAITOR) then
            for i, excludedWep in ipairs(WEPS.ExcludeWeapons[ROLE_TRAITOR]) do
                if classname == excludedWep then
                    included = false
                end
            end
        end

        if included then
            net.Start("Randomat_SendTraitorEquipmentName")
            net.WriteString(v.PrintName .. "," .. classname)
            net.WriteBool(error)
            net.SendToServer()
        end
    end

    --if its not on the SWEP list, then check the equipment item menu for the role
    for k, v in pairs(EquipmentItems[ROLE_TRAITOR]) do
        if isnumber(v.id) then
            net.Start("Randomat_SendTraitorEquipmentName")
            net.WriteString(v.name .. "," .. v.id)
            net.WriteBool(error)
            net.SendToServer()
        end
    end
end)

function Randomat:register(tbl)
end