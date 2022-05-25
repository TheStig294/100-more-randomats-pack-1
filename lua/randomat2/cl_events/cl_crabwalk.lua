net.Receive("CrabWalkRandomatBegin", function()
    hook.Add("StartCommand", "CrabWalkRandomatSidewaysOnly", function(ply, CUserCmd)
        if ply:Alive() and not ply:IsSpec() then
            CUserCmd:SetForwardMove(0)
        end
    end)
end)

net.Receive("CrabWalkRandomatEnd", function()
    hook.Remove("StartCommand", "CrabWalkRandomatSidewaysOnly")
end)