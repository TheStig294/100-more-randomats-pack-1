local EVENT = {}
EVENT.Title = "Prop Confusion"
EVENT.Description = "Someone sees everyone else as props!"
EVENT.id = "propconfusion"
EVENT.StartSecret = true

EVENT.Categories = {"modelchange", "fun", "moderateimpact"}

util.AddNetworkString("PropConfusionRandomatBegin")
util.AddNetworkString("PropConfusionRandomatEnd")
local randomPly

function EVENT:Begin()
    randomPly = self:GetAlivePlayers(true)[1]
    net.Start("PropConfusionRandomatBegin")
    net.Send(randomPly)
end

function EVENT:End()
    if not IsPlayer(randomPly) then return end
    net.Start("PropConfusionRandomatEnd")
    net.Send(randomPly)
end

Randomat:register(EVENT)