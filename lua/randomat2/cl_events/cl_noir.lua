local color_tbl = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 0,
    ["$pp_colour_mulr"] = 0.05,
    ["$pp_colour_mulg"] = 0.05,
    ["$pp_colour_mulb"] = 0.05
}

net.Receive("randomat_noir", function()
    local playMusic = net.ReadBool()
    local chosenMusic = net.ReadString()

    hook.Add("RenderScreenspaceEffects", "GrayscaleRandomatEffect", function()
        local client = LocalPlayer()
        if not client:Alive() or client:IsSpec() then return end
        DrawColorModify(color_tbl)
        cam.Start3D(EyePos(), EyeAngles())
        render.SuppressEngineLighting(true)
        render.SetColorModulation(1, 1, 1)
        render.SuppressEngineLighting(false)
        cam.End3D()
    end)

    if playMusic then
        for i = 1, 2 do
            surface.PlaySound(chosenMusic)
        end
    end
end)

net.Receive("randomat_noir_end", function()
    hook.Remove("RenderScreenspaceEffects", "GrayscaleRandomatEffect")
end)