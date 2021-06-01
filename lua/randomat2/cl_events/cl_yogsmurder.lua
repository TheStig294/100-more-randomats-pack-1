net.Receive("YogsMurderRandomat", function()
	yogsmurderpopup = vgui.Create("DFrame")
	local xSize = 958
	local ySize = 185
    local pos1 = (ScrW()-xSize)/2
    local pos2 = (ScrH()-ySize)/2
    yogsmurderpopup:SetPos(pos1,pos2)
    yogsmurderpopup:SetSize(xSize,ySize)
    yogsmurderpopup:ShowCloseButton(false)
    yogsmurderpopup:MakePopup()
	yogsmurderpopup.Paint = function(self, w, h) end
	
	local image = vgui.Create("DImage", yogsmurderpopup)
    image:SetImage("materials/vgui/ttt/yogsmurder/yogsmurder.png")
    image:SetPos(0,0)
    image:SetSize(xSize,ySize)   
end)

net.Receive("YogsMurderRandomatEnd", function()
	yogsmurderpopup:Close()
end)