net.Receive("NobodyRandomatDeathConfetti", function()
    local ply = net.ReadEntity()
    ply:Celebrate(nil, true)
end)