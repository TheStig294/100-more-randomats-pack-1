local EVENT = {}
EVENT.Title = "Événement Aléatoire" -- "Random Event"
EVENT.AltTitle = "French Randomat"
EVENT.Description = "Parlez-vous Français?" -- "Do you speak French?"
EVENT.ExtDescription = "Changes the game language to French"
EVENT.id = "french"

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("FrenchRandomatBegin")
util.AddNetworkString("FrenchRandomatEnd")

function EVENT:Begin()
    net.Start("FrenchRandomatBegin")
    net.Broadcast()

    for _, ply in ipairs(player.GetAll()) do
        ply:ConCommand("ttt_language FrançaisRandomat")
    end
end

function EVENT:End()
    net.Start("FrenchRandomatEnd")
    net.Broadcast()

    for _, ply in ipairs(player.GetAll()) do
        ply:ConCommand("ttt_language auto")
    end
end

Randomat:register(EVENT)