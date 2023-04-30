local banTables = {}
local frames = 0

local function closeFrame(frame, idx)
    if frame ~= nil then
        frame:Close()
        banTables[idx] = nil
    end
end

local function closeBanFrame()
    if #banTables == 0 then return end
    local lastidx

    -- Frames not not necessarily stored in order when multiple are shown at once
    -- Find that last index since that will be the frame on top (visually)
    for i, _ in pairs(banTables) do
        lastidx = i
    end

    local frame = banTables[lastidx]
    closeFrame(frame, lastidx)
end

local function closeAllBanFrames()
    for k, v in pairs(banTables) do
        closeFrame(v, k)
    end
end

local function openFrame(x)
    frames = frames + 1
    local frame = vgui.Create("DFrame")
    frame:SetPos(10, ScrH() - 500)
    frame:SetSize(200, 17 * x + 51)
    frame:SetTitle("Ban an Event (Hold " .. string.lower(Key("+showscores", "tab")) .. ")")
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:SetVisible(true)
    frame:SetDeleteOnClose(true)

    return frame
end

net.Receive("BanEventTrigger", function()
    local x = net.ReadInt(8)
    local tbl = net.ReadTable()
    local frame = openFrame(x)
    --Event List
    local list = vgui.Create("DListView", frame)
    list:Dock(FILL)
    list:SetMultiSelect(false)
    list:AddColumn("Events")

    for _, v in pairs(tbl) do
        list:AddLine(v)
    end

    banTables[frames] = frame

    list.OnRowSelected = function(lst, index, pnl)
        net.Start("PlayerBannedEvent")
        net.WriteString(pnl:GetColumnText(1))
        net.SendToServer()
        closeBanFrame()
    end

    net.Receive("BanEventEnd", function()
        closeAllBanFrames()
    end)
end)

net.Receive("BanVoteTrigger", function()
    local x = net.ReadInt(32)
    local tbl = net.ReadTable()
    local frame = openFrame(x)
    --Event List
    local list = vgui.Create("DListView", frame)
    list:Dock(FILL)
    list:SetMultiSelect(false)
    list:AddColumn("Events")
    list:AddColumn("Votes")

    for _, v in pairs(tbl) do
        list:AddLine(v, 0)
    end

    banTables[frames] = frame

    list.OnRowSelected = function(lst, index, pnl)
        net.Start("BanPlayerVoted")
        net.WriteString(pnl:GetColumnText(1))
        net.SendToServer()
    end

    net.Receive("BanEventEnd", function()
        closeAllBanFrames()
    end)

    net.Receive("BanPlayerVoted", function()
        local votee = net.ReadString()

        for _, v in pairs(list:GetLines()) do
            if v:GetColumnText(1) == votee then
                v:SetColumnText(2, v:GetColumnText(2) + 1)
            end
        end
    end)

    net.Receive("BanVoteEnd", function()
        closeAllBanFrames()
    end)
end)