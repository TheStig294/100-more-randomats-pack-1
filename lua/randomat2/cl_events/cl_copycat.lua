net.Receive("CopycatRandomatBegin", function()
    local copiedPlayer = net.ReadEntity()
    local copycat = net.ReadEntity()
    local name = copiedPlayer:Nick()
    print(name)

    -- Name changed on scoreboard and when you look at the copycat
    hook.Add("TTTScoreboardPlayerName", "CopycatRandomatCopyName", function(ply, client, currentName)
        print(ply)
        print(copycat)
        if ply == copycat then return name end
    end)

    hook.Add("TTTTargetIDPlayerName", "CopycatRandomatCopyName", function(ply, client, text, clr)
        if ply == copycat then return name, clr end
    end)
end)

net.Receive("CopycatRandomatEnd", function()
    hook.Remove("TTTScoreboardPlayerName", "CopycatRandomatCopyName")
    hook.Remove("TTTTargetIDPlayerName", "CopycatRandomatCopyName")
end)