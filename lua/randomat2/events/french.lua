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

    for _, ply in ipairs(player.GetAll()) do
        ply:ConCommand("ttt_language FrançaisRandomat")
    end

    net.Start("FrenchRandomatBegin")
    net.Broadcast()
end

function EVENT:End()
    if eventRun then
        eventRun = false

        for _, ply in ipairs(player.GetAll()) do
            ply:ConCommand("ttt_language auto")
        end

        net.Start("FrenchRandomatEnd")
        net.Broadcast()
    end
end

Randomat:register(EVENT)