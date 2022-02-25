net.Receive("WhatItsLikeRandomatHideNames", function()
    hook.Add("TTTTargetIDPlayerName", "WhatItsLikeRandomatHideNames", function(ply, client, text, clr) return false, clr end)
end)

net.Receive("WhatItsLikeRandomatEnd", function()
    hook.Remove("TTTTargetIDPlayerName", "WhatItsLikeRandomatHideNames")
end)