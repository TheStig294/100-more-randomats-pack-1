net.Receive("TriggeredRandomatSound", function()
    timer.Create("TriggeredRandomatSoundCooldown", 0.1, 1, function()
        for i = 1, 2 do
            surface.PlaySound("triggered/triggered.mp3")
        end
    end)
end)