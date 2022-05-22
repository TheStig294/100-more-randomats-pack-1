net.Receive("SpeedrunRandomatPlayAlertSound", function()
    local alertSound = net.ReadString()

    for i = 1, 2 do
        surface.PlaySound(alertSound)
    end
end)