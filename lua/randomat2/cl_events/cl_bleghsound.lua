net.Receive("RandomatBleghSound", function()
    local deathSound = net.ReadString()

    -- I couldn't get the sound to play any louder, so I resorted to playing it 3 times over...
    for i = 1, 3 do
        surface.PlaySound(deathSound)
    end
end)