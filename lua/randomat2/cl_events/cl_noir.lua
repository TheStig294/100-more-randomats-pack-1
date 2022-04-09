local color_tbl = {}
local barFrame
local barFrame2
local playMusic = true

net.Receive("randomat_noir", function()
    -- Adds a near-black-and-white filter to the screen
    color_tbl = {
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

    hook.Add("RenderScreenspaceEffects", "NoirRandomatGreyscaleEffect", function()
        DrawColorModify(color_tbl)
        cam.Start3D(EyePos(), EyeAngles())
        render.SuppressEngineLighting(true)
        render.SetColorModulation(1, 1, 1)
        render.SuppressEngineLighting(false)
        cam.End3D()
    end)

    -- Plays a noir jazz song if enabled
    playMusic = net.ReadBool()

    if playMusic then
        for i = 1, 2 do
            surface.PlaySound("noir/deadly_roulette.mp3")
        end

        timer.Create("NoirRandomatMusicLoop", 153, 0, function()
            for i = 1, 2 do
                surface.PlaySound("noir/deadly_roulette.mp3")
            end
        end)
    end

    -- Draws 2 black bars on the screen, to make a cinematic letterbox effect
    barFrame = vgui.Create("DFrame")
    barFrame:SetSize(ScrW(), ScrH() / 7)
    barFrame:SetPos(0, 0)
    barFrame:SetTitle("")
    barFrame:SetDraggable(false)
    barFrame:ShowCloseButton(false)
    barFrame:SetVisible(true)
    barFrame:SetDeleteOnClose(true)
    barFrame:SetZPos(-32768)

    barFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    barFrame2 = vgui.Create("DFrame")
    barFrame2:SetSize(ScrW(), ScrH() / 6)
    barFrame2:SetPos(0, ScrH() - (ScrH() / 7))
    barFrame2:SetTitle("")
    barFrame2:SetDraggable(false)
    barFrame2:ShowCloseButton(false)
    barFrame2:SetVisible(true)
    barFrame2:SetDeleteOnClose(true)
    barFrame2:SetZPos(-32768)

    barFrame2.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end
end)

net.Receive("randomat_noir_end", function()
    timer.Remove("NoirRandomatMusicLoop")

    -- Plays ending sound
    if playMusic then
        RunConsoleCommand("stopsound")

        timer.Simple(0.1, function()
            for i = 1, 2 do
                surface.PlaySound("noir/deadly_roulette_end.mp3")
            end
        end)
    end

    -- Fades in colour and moves black bars off the screen over 3 seconds
    timer.Simple(4, function()
        timer.Create("NoirRandomatFadeIn", 0.01, 200, function()
            if color_tbl["$pp_colour_colour"] + 0.005 <= 1 then
                color_tbl["$pp_colour_colour"] = color_tbl["$pp_colour_colour"] + 0.005
            end

            local width, height = barFrame:GetSize()
            barFrame:SetHeight(height - 1)
            barFrame2:SetY(barFrame2:GetY() + 1)
        end)
    end)

    -- After a 4 second wait, and a 3 second animation, completely remove the black bars and greyscale effect hook altogether
    timer.Simple(9, function()
        hook.Remove("RenderScreenspaceEffects", "NoirRandomatGreyscaleEffect")

        if barFrame ~= nil then
            barFrame:Close()
            barFrame = nil
        end

        if barFrame2 ~= nil then
            barFrame2:Close()
            barFrame2 = nil
        end
    end)
end)