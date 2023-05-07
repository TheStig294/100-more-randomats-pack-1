net.Receive("DuncanEventRandomatHideNames", function()
    local disguise = net.ReadBool()
    hook.Add("TTTTargetIDPlayerName", "DuncanEventRandomatHideNames", function(ply, client, text, clr) return false, clr end)

    if disguise then
        local defaultcolor = Color(0, 0, 0, 0)
        hook.Add("TTTScoreboardPlayerRole", "DuncanEventRandomatHideRoles", function(ply, client, color, roleFileName) return defaultcolor, "nil", false end)
    end
end)

net.Receive("DuncanEventRandomatEnd", function()
    hook.Remove("TTTTargetIDPlayerName", "DuncanEventRandomatHideNames")
    hook.Remove("TTTScoreboardPlayerRole", "DuncanEventRandomatHideRoles")
end)