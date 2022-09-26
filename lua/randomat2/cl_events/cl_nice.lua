local hitMarkerSound

net.Receive("RandomatNiceBegin", function()
    for i = 1, 2 do
        surface.PlaySound("nice/nice.mp3")
    end

    hitMarkerSound = GetConVar("hm_hitsound"):GetBool()
    GetConVar("hm_hitsound"):SetBool(false)
end)

net.Receive("RandomatNiceEnd", function()
    if hitMarkerSound then
        RunConsoleCommand("hm_hitsound", "1")
    end
end)