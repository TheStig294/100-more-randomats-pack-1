net.Receive("GunfireRandomatClientBegin", function()
    -- Looking for the player pressing the attack bind, alive, having some ammo in their gun's clip, and not clicking while in a context menu like the buy menu
    hook.Add("PlayerBindPress", "GunfireRandomatExtinguishPlayer", function(ply, bind)
        if bind == "+attack" and ply:Alive() and not ply:IsSpec() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():Clip1() ~= nil and ply:GetActiveWeapon():Clip1() > 0 and not ply:IsWorldClicking() then
            net.Start("GunfireRandomatClientClickExtinguish")
            net.SendToServer("GunfireRandomatClientClickExtinguish")
        end
    end)
end)

net.Receive("GunfireRandomatClientEnd", function()
    hook.Remove("PlayerBindPress", "GunfireRandomatExtinguishPlayer")
end)