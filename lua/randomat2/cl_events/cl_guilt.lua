net.Receive("GuiltyRandomatTrigger", function()
    local guiltyTime = net.ReadInt(8)
    time = CurTime()

    hook.Add("Think", "RandomatGuiltThink", function()
        if (CurTime() - time) < guiltyTime then
            current = LocalPlayer():EyeAngles()
            current.p = 90
            LocalPlayer():SetEyeAngles(current)
        else
            hook.Remove("Think", "RandomatGuiltThink")
        end
    end)

    LocalPlayer():SetNextClientThink(CurTime()) -- Set the next think to run as soon as possible, i.e. the next frame.

    return true -- Apply NextThink call
end)