net.Receive("DoomedRandomatBegin", function()
    local ply = LocalPlayer()

    -- Prevents up/down movement with the mouse
    hook.Add("InputMouseApply", "DoomedRandomat", function(cmd, x, y, ang)
        if not IsPlayer(ply) or not ply:Alive() or ply:IsSpec() then return end
        ang.pitch = 0
        ang.yaw = ang.yaw - (x / 50)
        cmd:SetViewAngles(ang)

        return true
    end)
end)

net.Receive("DoomedRandomatEnd", function()
    hook.Remove("InputMouseApply", "DoomedRandomat")
end)