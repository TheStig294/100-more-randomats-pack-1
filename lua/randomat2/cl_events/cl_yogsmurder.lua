--Shows the Yogscast Murder popup for the 'Murder (Yogscast Intro)' randomat
net.Receive("YogsMurderRandomat", function()
    yogsmurderpopup = vgui.Create("DFrame")
    --Resolution of the popup image file, so the popup frame is covered by the popup itself
    local xSize = 958
    local ySize = 185
    --Sets the centre of the frame at the centre of the screen
    local pos1 = (ScrW() - xSize) / 2
    local pos2 = (ScrH() - ySize) / 2
    yogsmurderpopup:SetPos(pos1, pos2)
    yogsmurderpopup:SetSize(xSize, ySize)
    --Hide the close button and the frame is completely hidden
    yogsmurderpopup:ShowCloseButton(false)
    --Create the frame
    yogsmurderpopup:MakePopup()
    --Placing the popup image on the frame
    yogsmurderpopup.Paint = function(self, w, h) end
    local image = vgui.Create("DImage", yogsmurderpopup)
    image:SetImage("materials/vgui/ttt/yogsmurder/yogsmurder.png")
    image:SetPos(0, 0)
    image:SetSize(xSize, ySize)
end)

--Remove the popup after the Yogscast Murder jingle has finished playing
net.Receive("YogsMurderRandomatEnd", function()
    yogsmurderpopup:Close()
end)