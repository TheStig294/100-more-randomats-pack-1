local EVENT = {}
EVENT.Title = "Événement Aléatoire" -- "Random Event"
EVENT.AltTitle = "French Randomat"
EVENT.Description = "Change la majeure partie du jeu en français"
EVENT.ExtDescription = "Changes most of the game to French"
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