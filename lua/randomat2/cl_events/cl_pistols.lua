local color_tbl = {}
local xPos
local yPos
local width
local height
local xPos2
local yPos2
local width2
local height2
local music
local yellowTint

net.Receive("PistolsPrepareShowdown", function()
    music = net.ReadBool()
    yellowTint = net.ReadBool()

    -- Adds a near-black-and-white filter to the screen
    if yellowTint then
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
    end

    -- Draws 2 black bars on the screen, to make a cinematic letterbox effect
    xPos = 0
    yPos = 0
    width = ScrW()
    height = 0
    xPos2 = 0
    yPos2 = ScrH()
    width2 = ScrW()
    height2 = ScrH() / 6

    hook.Add("HUDPaintBackground", "PistolsRandomatDrawBars", function()
        surface.SetDrawColor(0, 0, 0)
        surface.DrawRect(xPos, yPos, width, height)
        surface.DrawRect(xPos2, yPos2, width2, height2)
    end)

    -- Makes the black bars initially slide onto the screen, along with a yellow tint being slowly applied
    timer.Create("PistolsRandomatFadeOIn", 0.01, 100, function()
        if yellowTint and color_tbl["$pp_colour_addr"] + 0.001 < 0.1 then
            color_tbl["$pp_colour_addr"] = color_tbl["$pp_colour_addr"] + 0.001
            color_tbl["$pp_colour_addg"] = color_tbl["$pp_colour_addg"] + 0.001
        end

        height = height + 1
        yPos2 = yPos2 - 1
    end)

    if music then
        for i = 1, 2 do
            surface.PlaySound("pistols/rattlesnake_railroad.mp3")
        end

        timer.Simple(5, function()
            chat.AddText("Press 'M' to mute music")
        end)

        hook.Add("PlayerButtonDown", "PistolsMuteMusicButton", function(ply, button)
            if button == KEY_M then
                RunConsoleCommand("stopsound")
                chat.AddText("Music muted")
                music = false
                hook.Remove("PlayerButtonDown", "PistolsMuteMusicButton")
            end
        end)
    end
end)

-- Draws halos over the duelling players
net.Receive("PistolsBeginShowdown", function()
    hook.Add("PreDrawHalos", "PistolsRandomatHalos", function()
        local alivePlys = {}

        for k, v in ipairs(player.GetAll()) do
            if v:Alive() and not v:IsSpec() then
                alivePlys[k] = v
            end
        end

        halo.Add(alivePlys, Color(255, 255, 255), 1, 1, 2, true, true)
    end)
end)

-- Changes the win screen to say "[player] WINS!", as opposed to "INNOCENTS WIN"
net.Receive("PistolsRandomatWinTitle", function()
    hook.Add("TTTScoringWinTitle", "RandomatPistolsWinTitle", function(wintype, wintitles, title)
        if wintype == WIN_INNOCENT or wintype == WIN_TRAITOR then
            local winner

            for i, ply in ipairs(player.GetAll()) do
                if ply:Alive() and not ply:IsSpec() and not Randomat:IsJesterTeam(ply) then
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
        end
    end)
end)

-- Ends the event completely
net.Receive("PistolsEndEvent", function()
    hook.Remove("PreDrawHalos", "PistolsRandomatHalos")
    hook.Remove("TTTScoringWinTitle", "RandomatPistolsWinTitle")

    if music then
        RunConsoleCommand("stopsound")

        timer.Simple(0.1, function()
            surface.PlaySound("pistols/rattlesnake_railroad_end.mp3")
        end)
    end

    -- Fades in colour and moves black bars off the screen over 3 seconds
    timer.Simple(4, function()
        timer.Create("PistolsRandomatFadeOut", 0.01, 100, function()
            if yellowTint and color_tbl["$pp_colour_addr"] and color_tbl["$pp_colour_addr"] - 0.0005 >= 0 then
                color_tbl["$pp_colour_addr"] = color_tbl["$pp_colour_addr"] - 0.001
                color_tbl["$pp_colour_addg"] = color_tbl["$pp_colour_addg"] - 0.001
            end

            -- Don't try to manipulate the black bars if they are off-screen already or they haven't been drawn
            if height and height ~= 0 then
                height = height - 1
                yPos2 = yPos2 + 1
            end
        end)
    end)

    -- After a 4 second wait, and a 3 second animation, completely remove the black bars and greyscale effect hook altogether
    timer.Simple(9, function()
        hook.Remove("RenderScreenspaceEffects", "PistolsRandomatTintEffect")
        hook.Remove("HUDPaintBackground", "PistolsRandomatDrawBars")
        hook.Remove("PlayerButtonDown", "PistolsMuteMusicButton")
    end)
end)