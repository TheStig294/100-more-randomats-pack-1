net.Receive("DiscordSoundRandomatBegin", function()
    local height, margin = 25, 20
    local y = ScrH() - (margin / 2 + height)
    local client = LocalPlayer()

    hook.Add("HUDPaint", "DiscordSoundsRandomatUI", function()
        if client:Alive() or not client:IsSpec() then return end
        draw.WordBox(8, ScrW() / 2, y, "Press: 1 - Connect Sound | 2 - Disconnect Sound | 3 - Ping Sound", "HealthAmmo", COLOR_BLACK, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)
end)

net.Receive("DiscordSoundRandomatEnd", function()
    hook.Remove("HUDPaint", "DiscordSoundsRandomatUI")
end)