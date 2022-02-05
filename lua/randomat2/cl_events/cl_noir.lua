local color_tbl = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 0,
    ["$pp_colour_mulr"] = 0.05,
    ["$pp_colour_mulg"] = 0.05,
    ["$pp_colour_mulb"] = 0.05
}

local upgradeFrame
local upgradeFrame2

net.Receive("randomat_noir", function()
    local playMusic = net.ReadBool()
    local chosenMusic = net.ReadString()

    hook.Add("RenderScreenspaceEffects", "GrayscaleRandomatEffect", function()
        local client = LocalPlayer()
        -- if not client:Alive() or client:IsSpec() then return end
        DrawColorModify(color_tbl)
        cam.Start3D(EyePos(), EyeAngles())
        render.SuppressEngineLighting(true)
        render.SetColorModulation(1, 1, 1)
        render.SuppressEngineLighting(false)
        cam.End3D()
    end)

    if playMusic then
        for i = 1, 2 do
            surface.PlaySound(chosenMusic)
        end
    end

    -- Draws a lettebox on the screen
    upgradeFrame = vgui.Create("DFrame")
    upgradeFrame:SetSize(ScrW(), ScrH() / 7)
    upgradeFrame:SetPos(0, 0)
    upgradeFrame:SetTitle("")
    upgradeFrame:SetDraggable(false)
    upgradeFrame:ShowCloseButton(false)
    upgradeFrame:SetVisible(true)
    upgradeFrame:SetDeleteOnClose(true)
    upgradeFrame:SetZPos(-32768)

    upgradeFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    upgradeFrame2 = vgui.Create("DFrame")
    upgradeFrame2:SetSize(ScrW(), ScrH() / 6)
    upgradeFrame2:SetPos(0, ScrH() - (ScrH() / 7))
    upgradeFrame2:SetTitle("")
    upgradeFrame2:SetDraggable(false)
    upgradeFrame2:ShowCloseButton(false)
    upgradeFrame2:SetVisible(true)
    upgradeFrame2:SetDeleteOnClose(true)
    upgradeFrame2:SetZPos(-32768)

    upgradeFrame2.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end
end)

net.Receive("randomat_noir_end", function()
    hook.Remove("RenderScreenspaceEffects", "GrayscaleRandomatEffect")

    if upgradeFrame ~= nil then
        upgradeFrame:Close()
        upgradeFrame = nil
    end

    if upgradeFrame2 ~= nil then
        upgradeFrame2:Close()
        upgradeFrame2 = nil
    end
end)