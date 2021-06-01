local popupTime = 17

net.Receive("HUDRandomatHint", function()
    popupTime = GetConVar("ttt_startpopup_duration"):GetInt()
    GetConVar("ttt_startpopup_duration"):SetInt(0)
end)

net.Receive("HUDRandomat", function()
    hook.Add("HUDShouldDraw", "RandomatHideAllHUD", function() return false end)

    hook.Add("PlayerBindPress", "WhoAmIDisableScorboard", function(ply, bind, pressed)
        if (string.find(bind, "+showscores")) then return true end
    end)
end)

net.Receive("HUDRandomatEnd", function()
    GetConVar("ttt_startpopup_duration"):SetInt(popupTime)
    hook.Remove("HUDShouldDraw", "RandomatHideAllHUD", function() return false end)
    hook.Remove("PlayerBindPress", "WhoAmIDisableScorboard")
end)