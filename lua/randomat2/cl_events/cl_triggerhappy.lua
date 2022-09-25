net.Receive("TriggerHappyRandomat", function()
    -- Looking for the player pressing the attack bind, alive, having some ammo in their gun's clip, and not clicking while in a context menu like the buy menu
    hook.Add("PlayerButtonDown", "TriggerHappyRandomat", function(ply, button)
        if button == MOUSE_LEFT and ply:Alive() and not ply:IsSpec() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():Clip1() ~= nil and ply:GetActiveWeapon():Clip1() > 0 and not ply:IsWorldClicking() then
            net.Start("TriggerHappyRandomatAttack")
            net.SendToServer()
        end
    end)
end)

net.Receive("TriggerHappyRandomatEnd", function()
    hook.Remove("PlayerButtonDown", "TriggerHappyRandomat")
end)