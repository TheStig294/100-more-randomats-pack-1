local introPopup
local overlayPositions = {}
local YPos = 50
local alpha = 0
local iconSize = 32
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
            playerNames[ply] = ply:Nick()
        end
    end

    -- The magic formula for getting the correct x-coordinates of where each overlay box should be
    -- This is used for getting centred positions of many objects on the screen in a row for HUDs
    -- Sorry for this being a bit of a magic number... took a lot of thought to come up with this formula
    -- Probably would've been faster to google this since I'm probably not the only person to have had this problem to solve, oh well...
    for playerIndex, ply in ipairs(player.GetAll()) do
        overlayPositions[ply] = (playerIndex * screenWidth) / (playerCount + 1)
    end

    -- Fallback colours to use
    local colourTable = {
        [ROLE_INNOCENT] = Color(25, 200, 25, 200),
        [ROLE_TRAITOR] = Color(200, 25, 25, 200),
        [ROLE_DETECTIVE] = Color(25, 25, 200, 200)
    }

    local ROLE_COLORS = ROLE_COLORS or colourTable
    -- Getting the icons for every role if Custom Roles for TTT is installed
    local roleIcons = nil

    if ROLE_STRINGS_SHORT then
        roleIcons = {}

        for roleID, shortName in pairs(ROLE_STRINGS_SHORT) do
            if file.Exists("materials/vgui/ttt/roles/" .. shortName .. "/score_" .. shortName .. ".png", "GAME") then
                roleIcons[roleID] = Material("vgui/ttt/roles/" .. shortName .. "/score_" .. shortName .. ".png")
            else
                roleIcons[roleID] = Material("vgui/ttt/score_" .. shortName .. ".png")
            end
        end
    end

    alpha = 0

    timer.Create("WelcomeBackFadeIn", 0.01, 100, function()
        alpha = alpha + 0.01
    end)

    local defaultColour = Color(100, 100, 100)

    hook.Add("DrawOverlay", "WelcomeBackRandomatDrawNameOverlay", function()
        surface.SetAlphaMultiplier(alpha)

        for ply, XPos in SortedPairsByValue(overlayPositions) do
            if not IsPlayer(ply) then continue end
            -- surface.SetDrawColor(100, 100, 100)
            local roleColour = defaultColour
            local iconRole

            -- Reveal yourself, searched players, and detectives (when their roles aren't hidden) to everyone
            if ply == LocalPlayer() or ply:GetNWBool("WelcomeBackScoreboardRoleRevealed") or (ply:GetNWBool("WelcomeBackIsGoodDetectiveLike") and GetGlobalInt("ttt_detective_hide_special_mode", 0) == 0) then
                roleColour = ROLE_COLORS[ply:GetRole()]

                if roleIcons then
                    iconRole = ply:GetRole()
                end
                -- Reveal fellow traitors as plain traitors until they're searched, when there is a glitch
            elseif LocalPlayer():GetNWBool("WelcomeBackTraitor") and ply:GetNWBool("WelcomeBackTraitor") then
                if GetGlobalBool("WelcomeBackGlitchExists") then
                    roleColour = ROLE_COLORS[ROLE_TRAITOR]

                    if roleIcons then
                        iconRole = ROLE_TRAITOR
                    end
                else
                    roleColour = ROLE_COLORS[ply:GetRole()]

                    if roleIcons then
                        iconRole = ply:GetRole()
                    end
                end
            elseif (ply:GetNWBool("WelcomeBackIsDetectiveLike") and ply:GetNWBool("HasPromotion")) or (ply:GetNWBool("WelcomeBackIsGoodDetectiveLike") and GetGlobalInt("ttt_detective_hide_special_mode", 0) == 1) then
                -- Reveal promoted detective-like players like the impersonator, or special detectives while the hide convar is on, as ordinary detectives
                roleColour = ROLE_COLORS[ROLE_DETECTIVE]

                if roleIcons then
                    iconRole = ROLE_DETECTIVE
                end
            elseif LocalPlayer():GetNWBool("WelcomeBackTraitor") and ply:GetNWBool("WelcomeBackJester") then
                -- Reveal jesters only to traitors
                roleColour = ROLE_COLORS[ply:GetRole()]

                if roleIcons then
                    iconRole = ROLE_JESTER
                end
            end

            -- Box and player name
            draw.WordBox(16, XPos, YPos, playerNames[ply], "WelcomeBackRandomatOverlayFont", roleColour, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            -- Role icons
            if iconRole then
                surface.SetMaterial(roleIcons[iconRole])
                surface.SetDrawColor(255, 255, 255)
                surface.DrawTexturedRect(XPos - iconSize / 2, iconSize / 6, iconSize, iconSize)
            end

            -- Death X
            if not ply:Alive() or ply:IsSpec() then
                -- You have to set the font using surface.SetFont() to use surface.GetTextSize(), even though surface.SetFont() is not used for any drawing
                surface.SetFont("WelcomeBackRandomatOverlayFont")
                local textWidth, textHeight = surface.GetTextSize(playerNames[ply])
                surface.SetDrawColor(255, 255, 255)
                surface.DrawLine(XPos - (textWidth / 2), YPos - (textHeight / 2), XPos + (textWidth / 2), YPos + (textHeight / 2))
                surface.DrawLine(XPos - (textWidth / 2), YPos + (textHeight / 2), XPos + (textWidth / 2), YPos - (textHeight / 2))
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