local EVENT = {}
EVENT.Title = "Crab Walk"
EVENT.Description = "You can only walk sideways"
EVENT.id = "crabwalk"

EVENT.Categories = {"largeimpact"}

util.AddNetworkString("CrabWalkRandomatBegin")
util.AddNetworkString("CrabWalkRandomatEnd")

function EVENT:Begin()
    net.Start("CrabWalkRandomatBegin")
    net.Broadcast()
end

function EVENT:End()
    net.Start("CrabWalkRandomatEnd")
    net.Broadcast()
end

Randomat:register(EVENT)