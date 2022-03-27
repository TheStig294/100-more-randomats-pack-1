--Time the role hint popup appears at the bottom-centre of the screen at the start of every round of TTT
--Default time is 17 seconds
local popupTime = 17

net.Receive("HUDRandomatHint", function()
    popupTime = GetConVar("ttt_startpopup_duration"):GetInt()
    --Prevents the role popup appearing at all if randomat is triggered at the start of the round
    GetConVar("ttt_startpopup_duration"):SetInt(0)
end)

net.Receive("HUDRandomat", function()
    --The magic hook that does all the work! (Hiding the HUD)
    hook.Add("HUDShouldDraw", "HUDRandomatHideAllHUD", function(name)
        if name ~= "CHudGMod" then return false end
    end)

    --Disable the scoreboard as well
    hook.Add("PlayerBindPress", "HUDRandomatDisableScoreboard", function(ply, bind, pressed)
        if (string.find(bind, "+showscores")) then return true end
    end)
end)

net.Receive("HUDRandomatEnd", function()
    --Reset the role hint popup time to what it was
    GetConVar("ttt_startpopup_duration"):SetInt(popupTime)
    --Re-enable HUD and scoreboard once we're done
    hook.Remove("HUDShouldDraw", "HUDRandomatHideAllHUD")
    hook.Remove("PlayerBindPress", "HUDRandomatDisableScoreboard")
end)