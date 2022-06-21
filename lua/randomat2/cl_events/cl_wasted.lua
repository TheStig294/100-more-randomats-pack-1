net.Receive("WastedRandomatDeath", function()
    local slowdownTimescale = 0.3

    -- Play the "Wasted" sound effect
    for i = 1, 2 do
        surface.PlaySound("wasted/wasted.mp3")
    end

    -- Draw the "Wasted" vignette and popup
    local drawWastedImage = false
    local vignette = Material("vgui/ttt/wasted/vignette.png")
    local wastedImage = Material("vgui/ttt/wasted/wasted.png")
    local screenWidth = ScrW()
    local screenHeight = ScrH()
    -- 218 pixels is the height of the "Wasted" image
    local wastedYPos = (screenHeight / 2) - (218 / 2)
    local wastedHeight = screenHeight / 5

    hook.Add("DrawOverlay", "WastedRandomatOverlay", function()
        surface.SetAlphaMultiplier(0.6)
        surface.SetMaterial(vignette)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(0, 0, screenWidth, screenHeight)

        if drawWastedImage then
            surface.SetMaterial(wastedImage)
            surface.DrawTexturedRect(0, wastedYPos, screenWidth, wastedHeight)
        end
    end)

    -- Makes the screen black and white when the "Wasted" popup should be drawn
    timer.Simple(2.3 * slowdownTimescale, function()
        drawWastedImage = true

        -- Adds a near-black-and-white filter to the screen
        local color_tbl = {
            ["$pp_colour_addr"] = 0,
            ["$pp_colour_addg"] = 0,
            ["$pp_colour_addb"] = 0,
            ["$pp_colour_brightness"] = 0,
            ["$pp_colour_contrast"] = 1,
            ["$pp_colour_colour"] = 0,
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0,
            ["$pp_colour_mulb"] = 0
        }

        hook.Add("RenderScreenspaceEffects", "WastedRandomatGreyscaleEffect", function()
            DrawColorModify(color_tbl)
            cam.Start3D(EyePos(), EyeAngles())
            render.SuppressEngineLighting(true)
            render.SetColorModulation(1, 1, 1)
            render.SuppressEngineLighting(false)
            cam.End3D()
        end)
    end)

    -- After the sound has played, remove everything
    timer.Simple(7 * slowdownTimescale, function()
        hook.Remove("DrawOverlay", "WastedRandomatOverlay")
        hook.Remove("RenderScreenspaceEffects", "WastedRandomatGreyscaleEffect")
    end)
end)