net.Receive("CrabWalkRandomatBegin", function()
    hook.Add("StartCommand", "CrabWalkRandomatSidewaysOnly", function(ply, CUserCmd)
        CUserCmd:SetForwardMove(0)
    end)
end)

net.Receive("CrabWalkRandomatEnd", function()
    hook.Remove("StartCommand", "CrabWalkRandomatSidewaysOnly")
end)