local EVENT = {}
EVENT.Title = "Nice"
EVENT.Description = "Adds a new hitmarker sound"
EVENT.id = "nice"

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("RandomatNiceBegin")
util.AddNetworkString("RandomatNiceEnd")

function EVENT:Begin()
    net.Start("RandomatNiceBegin")
    net.Broadcast()
end

function EVENT:End()
    net.Start("RandomatNiceEnd")
    net.Broadcast()
end

Randomat:register(EVENT)