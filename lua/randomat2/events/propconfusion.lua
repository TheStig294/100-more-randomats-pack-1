local EVENT = {}
EVENT.Title = "Prop Confusion"
EVENT.Description = "Someone sees everyone else as props!"
EVENT.id = "propconfusion"
EVENT.StartSecret = true

EVENT.Categories = {"fun", "moderateimpact"}

util.AddNetworkString("PropConfusionRandomatBegin")
util.AddNetworkString("PropConfusionRandomatEnd")
local randomPly

function EVENT:Begin()
    for _, ply in ipairs(self:GetAlivePlayers(true)) do
        randomPly = ply
        -- If someone is using the "Lewis" playermodel, force the chosen player to be them
        if ply:GetModel() == "models/bradyjharty/yogscast/lewis.mdl" then break end
    end

    net.Start("PropConfusionRandomatBegin")
    net.Send(randomPly)
end

function EVENT:End()
    if not IsPlayer(randomPly) then return end
    net.Start("PropConfusionRandomatEnd")
    net.Send(randomPly)
    randomPly:PrintMessage(HUD_PRINTTALK, "You can now see who was what prop!")
end

Randomat:register(EVENT)