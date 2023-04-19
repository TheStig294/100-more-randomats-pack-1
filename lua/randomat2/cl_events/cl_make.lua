-- All of the possible randomat causes and effects, to make a custom randomat from
local Causes = {}
Causes.death = "After you die"
Causes.near = "After you're near a player"
Causes.buy = "After you buy something"
Causes.damage = "After you take damage"
Causes.weapon = "After you switch weapons"
Causes.chat = "After you send a chat message"
Causes.footstep = "After you walk"
Causes.bodysearch = "After you search a body"
-- All of the possible effects a custom randomat effect can be paired with
local Effects = {}
Effects.sound = "you make a sound"
Effects.bighead = "your head gets bigger"
Effects.randomat = "a randomat triggers!"
Effects.fling = "you get flung away!"
Effects.fov = "your FOV is randomly changed!"
Effects.model = "you randomly change playermodel"
Effects.health = "your health is randomly changed"
Effects.meme = "you see a random meme"
local makeTables = {}
local frames = 0

local function closeFrame(frame, idx)
    if frame ~= nil then
        frame:Close()
        makeTables[idx] = nil
    end
end

local function closeAllMakeFrames()
    for k, v in pairs(makeTables) do
        closeFrame(v, k)
    end
end

net.Receive("MakeRandomatEnd", function()
    closeAllMakeFrames()
end)

local function openFrame(noOfChoices)
    frames = frames + 1
    local frame = vgui.Create("DFrame")
    frame:SetPos(10, ScrH() - 500)
    frame:SetSize(200, 17 * noOfChoices + 51)
    frame:SetTitle("Make a randomat! (Hold " .. string.lower(Key("+showscores", "tab")) .. ")")
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:SetVisible(true)
    frame:SetDeleteOnClose(true)

    return frame
end

local function makeRandomat(causeID, effectID)
    timer.Remove("MakeRandomatEffectsTimer")
    closeAllMakeFrames()
    local ply = LocalPlayer()
    -- Fade out the screen
    ply:ScreenFade(SCREENFADE.STAYOUT, Color(0, 0, 0, 200), 1, 1)
    -- Create basic frame
    local Frame = vgui.Create("DFrame")
    local width = 500
    local height = 100
    Frame:SetPos(ScrW() / 2 - width / 2, ScrH() / 2 - height / 2)
    Frame:SetSize(width, height)
    Frame:SetTitle("Name your randomat! (Press 'Enter' when done)")
    Frame:SetVisible(true)
    Frame:MakePopup()
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:MakePopup()
    -- Create the name input
    local randomatName
    local NameEntry = vgui.Create("DTextEntry", Frame)
    local nameWidth = 450
    local nameHeight = 25
    NameEntry:SetPos(width / 2 - nameWidth / 2, height / 2 - nameHeight / 2)
    NameEntry:SetSize(nameWidth, nameHeight)
    NameEntry:SetText("(Enter name here)")

    -- Make the text field clear when you click into it.
    NameEntry.OnGetFocus = function(self)
        self:SetText("")
    end

    NameEntry.OnEnter = function(self)
        randomatName = self:GetValue()
        net.Start("PlayerMadeRandomat")
        net.WriteString(causeID)
        net.WriteString(effectID)
        net.WriteString(randomatName)
        net.SendToServer()
        Frame:Close()
        ply:ScreenFade(SCREENFADE.PURGE, Color(0, 0, 0, 200), 0, 0)
    end
end

local function makeEffectsList(frame, noOfLines, noOfChoices, secsToMakeChoice, causeID)
    timer.Remove("MakeRandomatCausesTimer")
    -- Effects List
    local effectsList = vgui.Create("DListView", frame)
    effectsList:Dock(FILL)
    effectsList:SetMultiSelect(false)
    effectsList:AddColumn("Effects")
    noOfLines = 0
    local effectsChoices = {}

    for id, desc in RandomPairs(Effects) do
        -- Preventing incompatible effects from being paired with the chosen cause
        if causeID == "near" and (id == "randomat" or id == "fling") then
            continue
        elseif causeID == "death" and id == "fling" then
            continue
        end

        effectsList:AddLine(desc)
        table.insert(effectsChoices, id)
        noOfLines = noOfLines + 1
        if noOfLines == noOfChoices then break end
    end

    makeTables[frames] = frame

    effectsList.OnRowSelected = function(_, rowIndex, _)
        local effectID = effectsChoices[rowIndex]
        makeRandomat(causeID, effectID)
    end

    -- If the time to choose an effect runs out, pick a random choice
    timer.Create("MakeRandomatEffectsTimer", secsToMakeChoice, 1, function()
        chat.AddText(COLOR_RED, "Took too long to choose! An effect was chosen randomly.")
        makeRandomat(causeID, effectsChoices[math.random(1, #effectsChoices)])
    end)
end

net.Receive("MakeRandomatTrigger", function()
    local noOfChoices = net.ReadInt(8)
    local secsToMakeChoice = net.ReadInt(8)
    local frame = openFrame(noOfChoices)
    -- Causes List
    local causesList = vgui.Create("DListView", frame)
    causesList:Dock(FILL)
    causesList:SetMultiSelect(false)
    causesList:AddColumn("Causes")
    local noOfLines = 0
    local causesChoices = {}

    for id, desc in RandomPairs(Causes) do
        causesList:AddLine(desc)
        table.insert(causesChoices, id)
        noOfLines = noOfLines + 1
        if noOfLines == noOfChoices then break end
    end

    makeTables[frames] = frame

    causesList.OnRowSelected = function(_, rowIndex, _)
        local causeID = causesChoices[rowIndex]
        makeEffectsList(frame, noOfLines, noOfChoices, secsToMakeChoice, causeID)
    end

    -- If the time to choose a cause runs out, pick a random choice
    timer.Create("MakeRandomatCausesTimer", secsToMakeChoice, 1, function()
        chat.AddText(COLOR_RED, "Took too long to choose! A cause was chosen randomly.")
        makeEffectsList(frame, noOfLines, noOfChoices, secsToMakeChoice, causesChoices[math.random(1, #causesChoices)])
    end)
end)