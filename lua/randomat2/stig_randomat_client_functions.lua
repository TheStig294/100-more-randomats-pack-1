-- Disabling fg addon's chat message to clear up chat box for randomat alerts (if installed)
RunConsoleCommand("ttt_fgaddons_textmessage", "0")

-- Just to catch any poorly written randomat packs that call the register function on the client somehow
function Randomat:register(tbl)
end

-- Getting the print names of all weapons and equipment
net.Receive("RandomatGetEquipmentPrintNames", function()
    for _, SWEP in ipairs(weapons.GetList()) do
        if SWEP.PrintName then
            net.Start("RandomatReceiveEquipmentPrintName")
            net.WriteString(SWEP.ClassName)
            net.WriteString(LANG.TryTranslation(SWEP.PrintName))
            net.SendToServer()
        end
    end

    for role, equTable in pairs(EquipmentItems) do
        for _, equ in ipairs(equTable) do
            net.Start("RandomatReceiveEquipmentPrintName")
            net.WriteString(tostring(equ.id))
            local name = LANG.TryTranslation(equ.name)
            net.WriteString(name)
            net.SendToServer()
        end
    end
end)