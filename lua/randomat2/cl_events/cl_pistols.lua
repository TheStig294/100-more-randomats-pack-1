local color_tbl = {}
local barFrame
local barFrame2

net.Receive("PistolsPrepareShowdown", function()
    -- Adds a near-black-and-white filter to the screen
    color_tbl = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    hook.Add("RenderScreenspaceEffects", "PistolsRandomatTintEffect", function()
        DrawColorModify(color_tbl)
        cam.Start3D(EyePos(), EyeAngles())
        render.SuppressEngineLighting(true)
        render.SetColorModulation(1, 1, 1)
        render.SuppressEngineLighting(false)
        cam.End3D()
    end)

    -- Draws 2 black bars on the screen, to make a cinematic letterbox effect
    barFrame = vgui.Create("DFrame")
    barFrame:SetSize(ScrW(), 0)
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
    barFrame2:SetPos(0, ScrH())
    barFrame2:SetTitle("")
    barFrame2:SetDraggable(false)
    barFrame2:ShowCloseButton(false)
    barFrame2:SetVisible(true)
    barFrame2:SetDeleteOnClose(true)
    barFrame2:SetZPos(-32768)

    barFrame2.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    timer.Create("PistolsRandomatFadeOIn", 0.01, 100, function()
        if color_tbl["$pp_colour_addr"] + 0.001 < 0.1 then
            color_tbl["$pp_colour_addr"] = color_tbl["$pp_colour_addr"] + 0.001
            color_tbl["$pp_colour_addg"] = color_tbl["$pp_colour_addg"] + 0.001
        end

        local width, height = barFrame:GetSize()
        barFrame:SetHeight(height + 1)
        barFrame2:SetY(barFrame2:GetY() - 1)
    end)

    for i = 1, 2 do
        surface.PlaySound("pistols/rattlesnake_railroad.mp3")
    end
end)

net.Receive("PistolsBeginShowdown", function()
    hook.Add("PreDrawHalos", "PistolsRandomatHalos", function()
        local alivePlys = {}

        for k, v in ipairs(player.GetAll()) do
            if v:Alive() and not v:IsSpec() then
                alivePlys[k] = v
            end
        end

        halo.Add(alivePlys, Color(0, 255, 0), 0, 0, 1, true, true)
    end)
end)

net.Receive("PistolsRandomatWinTitle", function()
    hook.Add("TTTScoringWinTitle", "RandomatPistolsWinTitle", function(wintype, wintitles, title)
        local winner

        for i, ply in ipairs(player.GetAll()) do
            if ply:Alive() and not ply:IsSpec() then
                winner = ply
            end
        end

        if not winner then return end
        LANG.AddToLanguage("english", "win_pistols", string.upper(winner:Nick() .. " wins!"))

        local newTitle = {
            txt = "win_pistols",
            c = ROLE_COLORS[winner:GetRole()],
            params = nil
        }

        return newTitle
    end)
end)

net.Receive("PistolsEndEvent", function()
    hook.Remove("PreDrawHalos", "PistolsRandomatHalos")
    hook.Remove("TTTScoringWinTitle", "RandomatPistolsWinTitle")
    RunConsoleCommand("stopsound")

    timer.Simple(0.1, function()
        surface.PlaySound("pistols/rattlesnake_railroad_end.mp3")
    end)

    -- Fades in colour and moves black bars off the screen over 3 seconds
    timer.Simple(4, function()
        timer.Create("PistolsRandomatFadeOut", 0.01, 100, function()
            if color_tbl["$pp_colour_addr"] and color_tbl["$pp_colour_addr"] - 0.0005 >= 0 then
                color_tbl["$pp_colour_addr"] = color_tbl["$pp_colour_addr"] - 0.001
                color_tbl["$pp_colour_addg"] = color_tbl["$pp_colour_addg"] - 0.001
            end

            local height
            local width

            if barFrame ~= nil then
                width, height = barFrame:GetSize()
                barFrame:SetHeight(height - 1)
            end

            if barFrame2 ~= nil then
                barFrame2:SetY(barFrame2:GetY() + 1)
            end
        end)
    end)

    -- After a 4 second wait, and a 3 second animation, completely remove the black bars and greyscale effect hook altogether
    timer.Simple(9, function()
        hook.Remove("RenderScreenspaceEffects", "PistolsRandomatTintEffect")

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