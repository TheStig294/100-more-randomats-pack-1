local introPopup
local overlayPositions = {}
local overlayBoxWidth = 120
local overlayBoxHeight = 50

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

    for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() and not ply:IsSpec() then
            playerCount = playerCount + 1
            overlayPositions[ply] = overlayBoxWidth * playerCount
        end
    end

    local alpha = 0

    hook.Add("DrawOverlay", "WelcomeBackRandomatDrawNameOverlay", function()
        local plyCount = 0
        alpha = alpha + 0.01
        alpha = math.min(alpha, 1)
        surface.SetAlphaMultiplier(alpha)

        for ply, pos in SortedPairsByValue(overlayPositions) do
            plyCount = plyCount + 1
            local xPos = (overlayBoxWidth * plyCount) + (plyCount * 20)
            local yPos = overlayBoxHeight - (overlayBoxHeight / 2)
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
                surface.SetDrawColor(ROLE_TRAITOR)
            end

            draw.RoundedBox(20, xPos, yPos, overlayBoxWidth, overlayBoxHeight, surface.GetDrawColor())
            surface.SetFont("WelcomeBackRandomatOverlayFont")
            surface.SetTextPos(xPos + (overlayBoxWidth / 20), yPos + (overlayBoxHeight / 4))
            surface.SetTextColor(255, 255, 255)
            surface.DrawText(ply:Nick())

            if not ply:Alive() or ply:IsSpec() then
                surface.SetDrawColor(255, 0, 0)
                surface.DrawLine(xPos, yPos, xPos + overlayBoxWidth, yPos + overlayBoxHeight)
                surface.DrawLine(xPos, yPos + overlayBoxHeight, xPos + overlayBoxWidth, yPos)
            end
        end
    end)
end)

-- Cleans up everything
net.Receive("WelcomeBackRandomatEnd", function()
    hook.Remove("DrawOverlay", "WelcomeBackRandomatDrawNameOverlay")
    timer.Remove("WelcomeBackCloseIntroPopup")

    if IsValid(introPopup) then
        introPopup:Close()
    end
end)