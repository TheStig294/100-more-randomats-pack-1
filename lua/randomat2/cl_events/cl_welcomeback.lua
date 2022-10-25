local introPopup
local overlayPositions = {}
local YPos = 50
local alpha = 0
local iconSize = 32
local playerNames = {}
local minBoxWidth = 100

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

local function WordBox(bordersize, x, y, text, font, color, fontcolor, xalign, yalign)
    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)

    if (xalign == TEXT_ALIGN_CENTER) then
        x = x - (bordersize + w / 2)
    elseif (xalign == TEXT_ALIGN_RIGHT) then
        x = x - (bordersize * 2 + w)
    end

    if (yalign == TEXT_ALIGN_CENTER) then
        y = y - (bordersize + h / 2)
    elseif (yalign == TEXT_ALIGN_BOTTOM) then
        y = y - (bordersize * 2 + h)
    end

    local boxWidth = w + bordersize * 2
    boxWidth = math.max(minBoxWidth, boxWidth)
    local xDiff = boxWidth - (w + bordersize * 2)
    draw.RoundedBox(bordersize, x - xDiff / 2, y, boxWidth, h + bordersize * 2, color)
    surface.SetTextColor(fontcolor.r, fontcolor.g, fontcolor.b, fontcolor.a)
    surface.SetTextPos(x + bordersize, y + bordersize)
    surface.DrawText(text)

    return boxWidth
end

-- Creates the table of players to be displayed in the role overlay
-- net.Receive("WelcomeBackRandomatCreateOverlay", function()
local playerCount = 0
local screenWidth = ScrW()

-- Grabbing player names and the number of them
for i, ply in ipairs(player.GetAll()) do
    playerCount = playerCount + 1
    playerNames[ply] = ply:Nick()

    if i == 1 then
        playerNames[ply] = "Lewis"
    elseif i == 2 then
        playerNames[ply] = "Ben"
    elseif i == 3 then
        playerNames[ply] = "Ravs"
    elseif i == 4 then
        playerNames[ply] = "Pedguin"
    elseif i == 5 then
        playerNames[ply] = "Boba"
    elseif i == 6 then
        playerNames[ply] = "Kirsty"
    elseif i == 7 then
        playerNames[ply] = "Gee"
    end
end

-- Sets all overlay positions to 0, so after the wordboxes are first drawn in the overlay hook, we can get the boxes' width
for _, ply in ipairs(player.GetAll()) do
    overlayPositions[ply] = 0
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

local defaultColour = Color(100, 100, 100)

-- alpha = 0
timer.Create("WelcomeBackFadeIn", 0.01, 100, function()
    alpha = alpha + 0.01
end)

local boxWidths = {}

timer.Simple(1, function()
    local boxPadding = 5
    local overlayWidth = 0

    for playerIndex, ply in ipairs(player.GetAll()) do
        overlayWidth = overlayWidth + boxPadding + boxWidths[ply]
    end

    local leftMargin = screenWidth / 2 - overlayWidth / 2
    local boxOffset = 0

    for playerIndex, ply in ipairs(player.GetAll()) do
        boxOffset = boxOffset + boxWidths[ply] / 2
        overlayPositions[ply] = leftMargin + boxOffset
        boxOffset = boxOffset + boxPadding + boxWidths[ply] / 2
    end
end)

local boxBorderSize = 16

hook.Add("DrawOverlay", "WelcomeBackRandomatDrawNameOverlay", function()
    -- surface.SetAlphaMultiplier(alpha)
    for ply, XPos in SortedPairsByValue(overlayPositions) do
        if not IsPlayer(ply) then continue end
        local roleColour = defaultColour
        local iconRole

        -- Reveal yourself, searched players, detectives (when their roles aren't hidden) to everyone, loot goblins (when they are shown to everyone), revealed turncoats and revealed beggars
        if ply == LocalPlayer() or ply:GetNWInt("WelcomeBackScoreboardRoleRevealed", -1) ~= -1 or ply:GetNWBool("WelcomeBackIsGoodDetectiveLike") or (ply.IsLootGoblin and ply:IsLootGoblin() and ply:IsRoleActive() and GetGlobalInt("ttt_lootgoblin_announce") == 4) or (ply.IsTurncoat and ply:IsTurncoat() and ply:IsTraitorTeam()) or ply.IsBeggar and ply:IsBeggar() and ply:ShouldRevealBeggar() then
            local role = ply:GetRole()

            if ply:GetNWInt("WelcomeBackScoreboardRoleRevealed", -1) ~= -1 then
                role = ply:GetNWInt("WelcomeBackScoreboardRoleRevealed", -1)
            elseif ply:GetNWBool("WelcomeBackIsGoodDetectiveLike") and GetGlobalInt("ttt_detective_hide_special_mode", 0) ~= 0 then
                role = ROLE_DETECTIVE
            end

            roleColour = ROLE_COLORS[role]

            if roleIcons then
                iconRole = role
            end
            -- Reveal fellow traitors as plain traitors until they're searched, when there is a glitch
        elseif LocalPlayer():GetNWBool("WelcomeBackTraitor") and ply:GetNWBool("WelcomeBackTraitor") and not (LocalPlayer().IsGlitch and LocalPlayer():IsGlitch()) then
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
        elseif LocalPlayer():GetNWBool("WelcomeBackTraitor") and ply:GetNWBool("WelcomeBackJester") and not (LocalPlayer().IsGlitch and LocalPlayer():IsGlitch()) then
            -- Reveal jesters only to traitors
            roleColour = ROLE_COLORS[ply:GetRole()]

            if roleIcons then
                iconRole = ROLE_JESTER
            end
        end

        -- Grabbing the name of the player again if they don't have a name yet, but were connected enough to the server to be given an overlay position
        if not playerNames[ply] then
            playerNames[ply] = ply:Nick()
        end

        -- But if the player still doesn't have a name yet, skip them
        if not playerNames[ply] then continue end
        -- Box and player name
        local boxWidth = WordBox(boxBorderSize, XPos, YPos, playerNames[ply], "WelcomeBackRandomatOverlayFont", roleColour, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if not boxWidths[ply] then
            boxWidths[ply] = boxWidth
        end

        -- Role icons
        if iconRole then
            surface.SetMaterial(roleIcons[iconRole])
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(XPos - iconSize / 2, iconSize / 6, iconSize, iconSize)
        end

        -- Death X
        if ply:GetNWBool("WelcomeBackBodyFound") then
            -- You have to set the font using surface.SetFont() to use surface.GetTextSize(), even though surface.SetFont() is not used for any drawing
            surface.SetFont("WelcomeBackRandomatOverlayFont")
            local textWidth, textHeight = surface.GetTextSize(playerNames[ply])
            surface.SetDrawColor(255, 255, 255)
            surface.DrawLine(XPos - (textWidth / 2), YPos - (textHeight / 2), XPos + (textWidth / 2), YPos + (textHeight / 2))
            surface.DrawLine(XPos - (textWidth / 2), YPos + (textHeight / 2), XPos + (textWidth / 2), YPos - (textHeight / 2))
        end
    end
end)

-- end)
-- Cleans up everything and slowly fades out the overlay
net.Receive("WelcomeBackRandomatEnd", function()
    timer.Remove("WelcomeBackCloseIntroPopup")
    timer.Remove("WelcomeBackFadeIn")
    table.Empty(boxWidths)

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