net.Receive("RandomatDetectiveWeaponsList", function()
	local error = false
	--when player buys an item, first check if its on the SWEP list
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
	for k, v in pairs (EquipmentItems[ROLE_DETECTIVE]) do
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
	--when player buys an item, first check if its on the SWEP list
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
	for k, v in pairs (EquipmentItems[ROLE_TRAITOR]) do
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