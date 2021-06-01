CreateConVar("randomat_guilt_time", 5, {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Time Guilty", 1, 30)
net.Receive("Guilty", function()

    time = CurTime()
    hook.Add("Think", "RandomatGuiltThink", function()

        if (CurTime() - time) < GetConVar("randomat_guilt_time"):GetInt() then
            current = LocalPlayer():EyeAngles()
            current.p = 90
            LocalPlayer():SetEyeAngles(current)
            
        else
            hook.Remove("Think", "RandomatGuiltThink")
        end
    
    end)

    LocalPlayer():NextThink( CurTime() ) -- Set the next think to run as soon as possible, i.e. the next frame.
	return true -- Apply NextThink call

end)