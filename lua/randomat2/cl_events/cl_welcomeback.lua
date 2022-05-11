local introPopup

-- Displays the intro popup and plays the intro sound chosen by the server
net.Receive("WelcomeBackRandomatPopup", function()
    local randomIntroSound = net.ReadString()
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

    timer.Simple(3.031, function()
        introPopup:Close()
    end)
end)