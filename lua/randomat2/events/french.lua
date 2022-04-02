local EVENT = {}
EVENT.Title = "Événement Aléatoire" -- "Random Event"
EVENT.AltTitle = "French Randomat"
EVENT.Description = "Parlez-vous Français?" -- "Do you speak French?"
EVENT.ExtDescription = "Changes the game language to French"
EVENT.id = "french"

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("FrenchRandomatBegin")
util.AddNetworkString("FrenchRandomatEnd")
local eventRun = false

function EVENT:Begin()
    eventRun = true
    net.Start("FrenchRandomatBegin")
    net.Broadcast()
end

function EVENT:End()
    if eventRun then
        eventRun = false
        net.Start("FrenchRandomatEnd")
        net.Broadcast()
    end
end

Randomat:register(EVENT)