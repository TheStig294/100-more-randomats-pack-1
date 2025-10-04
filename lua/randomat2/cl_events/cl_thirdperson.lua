net.Receive("ThirdPersonRandomat", function()
    hook.Add("CalcView", "ThirdPersonRandomatView", function(ply, pos, angles, fov, znear, zfar)
        if not ply:Alive() or ply:IsSpec() then return end

        local view = {
            origin = pos - (angles:Forward() * 100),
            angles = angles,
            fov = fov,
            drawviewer = true,
            znear = znear,
            zfar = zfar
        }

        return view
    end)

    hook.Add("TTTEndRound", "ThirdPersonRandomatReset", function()
        hook.Remove("CalcView", "ThirdPersonRandomatView")
        hook.Remove("TTTEndRound", "ThirdPersonRandomatReset")
    end)
end)