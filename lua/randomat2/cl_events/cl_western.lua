local color_tbl = {}
local xPos
local yPos
local width
local height
local xPos2
local yPos2
local width2
local height2

net.Receive("WesternBeginEvent", function()
    -- Adds a near-black-and-white filter to the screen
    color_tbl = {
        ["$pp_colour_addr"] = 0.1,
        ["$pp_colour_addg"] = 0.1,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    hook.Add("RenderScreenspaceEffects", "WesternRandomatTintEffect", function()
        DrawColorModify(color_tbl)
        cam.Start3D(EyePos(), EyeAngles())
        render.SuppressEngineLighting(true)
        render.SetColorModulation(1, 1, 1)
        render.SuppressEngineLighting(false)
        cam.End3D()
    end)

    -- Draws 2 black bars on the screen, to make a cinematic letterbox effect
    xPos = 0
    yPos = 0
    width = ScrW()
    height = ScrH() / 7
    xPos2 = 0
    yPos2 = ScrH() - (ScrH() / 7)
    width2 = ScrW()
    height2 = ScrH() / 6

    hook.Add("HUDPaintBackground", "WesternRandomatDrawBars", function()
        surface.SetDrawColor(0, 0, 0)
        surface.DrawRect(xPos, yPos, width, height)
        surface.DrawRect(xPos2, yPos2, width2, height2)
    end)

    -- Playing music originally from the 'Pistols at Dawn' randomat event
    music = net.ReadBool()

    if music then
        for i = 1, 2 do
            surface.PlaySound("pistols/rattlesnake_railroad.mp3")
        end

        timer.Create("WesternRandomatMusicLoop", 220, 0, function()
            for i = 1, 2 do
                surface.PlaySound("pistols/rattlesnake_railroad.mp3")
            end
        end)
    end

    -- Prevents players from walking around while in a duel
    hook.Add("StartCommand", "WesternRandomatStopDuelMovement", function(ply, CUserCmd)
        if IsPlayer(ply:GetNWEntity("WesternDuellingPlayer", NULL)) then
            CUserCmd:ClearMovement()
        end
    end)
end)

-- Ends the event
net.Receive("WesternEndEvent", function()
    hook.Remove("StartCommand", "WesternRandomatStopDuelMovement")
    timer.Remove("WesternRandomatMusicLoop")
    RunConsoleCommand("stopsound")

    timer.Simple(0.1, function()
        surface.PlaySound("pistols/rattlesnake_railroad_end.mp3")
    end)

    -- Fades in colour and moves black bars off the screen over 2 seconds
    timer.Simple(4, function()
        timer.Create("WesternRandomatFadeOut", 0.01, 200, function()
            if color_tbl["$pp_colour_addr"] and color_tbl["$pp_colour_addr"] - 0.001 >= 0 then
                color_tbl["$pp_colour_addr"] = color_tbl["$pp_colour_addr"] - 0.001
                color_tbl["$pp_colour_addg"] = color_tbl["$pp_colour_addg"] - 0.001
            end

            height = height - 1
            yPos2 = yPos2 + 1
        end)
    end)

    -- After a 4 second wait, and a 3 second animation, completely remove the black bars and greyscale effect hook altogether
    timer.Simple(9, function()
        hook.Remove("RenderScreenspaceEffects", "WesternRandomatTintEffect")
        hook.Remove("HUDPaintBackground", "WesternRandomatDrawBars")
    end)
end)