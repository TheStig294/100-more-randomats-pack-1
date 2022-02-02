net.Receive("DuncanEventRandomatHideNames", function()
    hook.Add("TTTTargetIDPlayerName", "DuncanEventRandomatHideNames", function(ply, client, text, clr) return false, clr end)
end)

net.Receive("DuncanEventRandomatEnd", function()
    hook.Remove("TTTTargetIDPlayerName", "DuncanEventRandomatHideNames")
end)