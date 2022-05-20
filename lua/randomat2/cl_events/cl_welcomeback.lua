local introPopup
local overlayPositions = {}
local Width = 150
local Height = 50
local YPos = Height / 2
local alpha = 0
local playerNames = {}

-- Displays the intro popup and plays the intro sound chosen by the server
net.Receive("WelcomeBackRandomatPopup", function()
    local randomIntroSound = net.ReadString()
    overlayPositions = {}
    RunConsoleCommand("stopsound")

    for i = 1, 2 do
        timer.Simple(0.1, function()
            surface.PlaySound("welcomeback/intro_sound.mp3")

            timer.Simple(3.031, function()
                surface.PlaySound(randomIntroSound)
            end)
        end)
    end

    local pixelOffset = 20
    local offsetLength = 1
    introPopup = vgui.Create("DFrame")
    local xSize = 875 - pixelOffset
    local ySize = 373 - pixelOffset
    local posX = (ScrW() - xSize) / 2
    local posY = (ScrH() - ySize) / 2
    introPopup:SetPos(posX, posY)
    introPopup:SetSize(xSize, ySize)
    introPopup:ShowCloseButton(false)
    introPopup:SetTitle("")
    introPopup:MakePopup()
    introPopup.Paint = function(self, w, h) end
    local image = vgui.Create("DImage", introPopup)
    image:SetImage("materials/vgui/ttt/welcomeback/ttt_popup.png")
    image:SetPos(0, 0)

    timer.Create("WelcomeBackIntroPopupTimer", offsetLength / pixelOffset, pixelOffset * offsetLength, function()
        local repetitions = pixelOffset - timer.RepsLeft("WelcomeBackIntroPopupTimer")
        local currentXSize = xSize + repetitions
        local currentYSize = ySize + repetitions
        posX = (ScrW() - currentXSize) / 2
        posY = (ScrH() - currentYSize) / 2
        introPopup:SetPos(posX, posY)
        introPopup:SetSize(currentXSize + repetitions, currentYSize + repetitions)
        image:SetSize(currentXSize + repetitions, currentYSize + repetitions)
        image:Center()
    end)

    timer.Create("WelcomeBackCloseIntroPopup", 3.031, 1, function()
        introPopup:Close()
    end)
end)

surface.CreateFont("WelcomeBackRandomatOverlayFont", {
    font = "Trebuchet24",
    size = 24,
    weight = 1000
})

-- Creates the table of players to be displayed in the role overlay
net.Receive("WelcomeBackRandomatCreateOverlay", function()
    local playerCount = 0
    local alivePlayers = {}
    local screenWidth = ScrW()

    for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() and not ply:IsSpec() then
            -- Grabbing the alive players and the number of them
            playerCount = playerCount + 1
            table.insert(alivePlayers, ply)
            -- Grabbing each player's nickname and adding an ellipsis if it is too long
            local playerName = ply:Nick()

            if #playerName > 11 then
                playerName = string.Left(playerName, 11) .. "..."
            end

            playerNames[ply] = playerName
        end
    end

    -- The magic formula for getting the correct x-coordinates of where each overlay box should be
    -- This is used for getting centred positions of many objects on the screen in a row for HUDs
    -- Sorry for this being a bit of a magic number... took a lot of thought to come up with this formula
    -- Probably would've been faster to google this since I'm probably not the only person to have had this problem to solve, oh well...
    for playerIndex, ply in ipairs(player.GetAll()) do
        overlayPositions[ply] = ((playerIndex * screenWidth) / (playerCount + 1)) - Width / 2
    end

    -- Fallback colours to use
    local colourTable = {
        [ROLE_INNOCENT] = Color(25, 200, 25, 200),
        [ROLE_TRAITOR] = Color(200, 25, 25, 200),
        [ROLE_DETECTIVE] = Color(25, 25, 200, 200)
    }

    local ROLE_COLORS = ROLE_COLORS or colourTable
    alpha = 0

    timer.Create("WelcomeBackFadeIn", 0.01, 100, function()
        alpha = alpha + 0.01
    end)

    hook.Add("DrawOverlay", "WelcomeBackRandomatDrawNameOverlay", function()
        surface.SetAlphaMultiplier(alpha)

        for ply, XPos in SortedPairsByValue(overlayPositions) do
            if not IsPlayer(ply) then continue end
            surface.SetDrawColor(100, 100, 100)

            -- Reveal yourself and searched players
            if ply == LocalPlayer() or ply:GetNWBool("WelcomeBackScoreboardRoleRevealed") then
                surface.SetDrawColor(ROLE_COLORS[ply:GetRole()])
                -- Reveal detective-like players only as detectives to everyone
            elseif ply:GetNWBool("WelcomeBackIsDetectiveLike") then
                surface.SetDrawColor(ROLE_COLORS[ROLE_DETECTIVE])
            elseif LocalPlayer():GetNWBool("WelcomeBackTraitor") and ply:GetNWBool("WelcomeBackJester") then
                -- Reveal jesters only to traitors
                surface.SetDrawColor(ROLE_COLORS[ply:GetRole()])
            elseif LocalPlayer():GetNWBool("WelcomeBackTraitor") and ply:GetNWBool("WelcomeBackTraitor") then
                -- Reveal fellow traitors as plain traitors until they're searched, as there could be a glitch
                surface.SetDrawColor(ROLE_COLORS[ROLE_TRAITOR])
            end

            draw.RoundedBox(20, XPos, YPos, Width, Height, surface.GetDrawColor())
            surface.SetFont("WelcomeBackRandomatOverlayFont")
            surface.SetTextPos(XPos + (Width / 20), YPos + (Height / 4))
            surface.SetTextColor(255, 255, 255)
            surface.DrawText(playerNames[ply])

            if not ply:Alive() or ply:IsSpec() then
                surface.SetDrawColor(255, 0, 0)
                surface.DrawLine(XPos, YPos, XPos + Width, YPos + Height)
                surface.DrawLine(XPos, YPos + Height, XPos + Width, YPos)
            end
        end
    end)
end)

-- Cleans up everything and slowly fades out the overlay
net.Receive("WelcomeBackRandomatEnd", function()
    timer.Remove("WelcomeBackCloseIntroPopup")
    timer.Remove("WelcomeBackFadeIn")

    timer.Create("WelcomeBackFadeOut", 0.01, 100, function()
        alpha = alpha - 0.01

        if timer.RepsLeft("WelcomeBackFadeOut") == 0 then
            hook.Remove("DrawOverlay", "WelcomeBackRandomatDrawNameOverlay")
        end
    end)

    if IsValid(introPopup) then
        introPopup:Close()
    end
end)