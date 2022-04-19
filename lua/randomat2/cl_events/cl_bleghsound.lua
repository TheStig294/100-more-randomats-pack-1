net.Receive("BleghRandomatSound", function()
    local deathSound = net.ReadString()

    for i = 1, 3 do
        surface.PlaySound(deathSound)
    end
end)