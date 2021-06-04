--A couple of net messages for getting the print names of buy menu weapons
--Triggers at the start of the first round of TTT on a map, every buy menu item found on the first connected player has its print name associated with its class name
--Used with randomats that rely on 'TTT Total Statistics'
--Buy menu items on the server but not on the first connected client aren't tracked by these randomats
net.Receive("RandomatDetectiveWeaponsList", function()
    local error = false

    --first check if a weapons is on the SWEP list
    for k, v in pairs(weapons.GetList()) do
        if isstring(v.ClassName) then
            if table.HasValue(v.CanBuy, ROLE_DETECTIVE) then
                net.Start("Randomat_SendDetectiveEquipmentName")
                net.WriteString(v.PrintName .. "," .. v.ClassName)
                net.WriteBool(error)
                net.SendToServer()
            end
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

    --first check if a weapons is on the SWEP list
    for k, v in pairs(weapons.GetList()) do
        if isstring(v.ClassName) then
            if table.HasValue(v.CanBuy, ROLE_TRAITOR) then
                net.Start("Randomat_SendTraitorEquipmentName")
                net.WriteString(v.PrintName .. "," .. v.ClassName)
                net.WriteBool(error)
                net.SendToServer()
            end
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

--Catches any randomats trying to register on both the client and server, rather than just the server, to prevent console errors
function Randomat:register(tbl)
end