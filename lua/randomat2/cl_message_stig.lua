-- Randomat base code from Malivil's randomat mod
-- Does not run if a convar added by Malivil's randomat mod is detected to ensure a potentially newer version of the randomat base isn't overridden
if not GetGlobalBool("DisableStigRandomatBase", false) then
    -- Handles the message popup at the centre of the screen every time a randomat is activated
    surface.CreateFont("RandomatHeader", {
        font = "Roboto",
        size = 48
    })

    surface.CreateFont("RandomatSmallMsg", {
        font = "Roboto",
        size = 32
    })

    local function ShowMessage(big, msg, length)
        if length == 0 then
            length = 5
        end

        local panel = vgui.Create("DNotify")
        panel:SetLife(length)

        if big then
            surface.SetFont("RandomatHeader")
        else
            surface.SetFont("RandomatSmallMsg")
        end

        panel:SetSize(surface.GetTextSize(msg))
        panel:Center()

        if not big then
            panel:CenterVertical(0.55)
        end

        local bg = vgui.Create("DPanel", panel)
        bg:SetBackgroundColor(Color(0, 0, 0, 200))
        bg:Dock(FILL)
        local lbl = vgui.Create("DLabel", bg)
        lbl:SetText(msg)

        if big then
            lbl:SetFont("RandomatHeader")
        else
            lbl:SetFont("RandomatSmallMsg")
        end

        lbl:SetTextColor(Color(255, 200, 0))
        lbl:SetWrap(true)
        lbl:Dock(FILL)
        lbl:SetText(msg)
        panel:AddItem(bg)
    end

    net.Receive("randomat_message", function()
        local big = net.ReadBool()
        local msg = net.ReadString()
        local length = net.ReadUInt(8)
        ShowMessage(big, msg, length)
        surface.PlaySound("weapons/c4_initiate.wav")
    end)

    net.Receive("randomat_message_silent", function()
        local big = net.ReadBool()
        local msg = net.ReadString()
        local length = net.ReadUInt(8)
        ShowMessage(big, msg, length)
    end)
end