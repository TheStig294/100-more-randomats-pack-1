local EVENT = {}
EVENT.Title = "It's time to go third-person!"
EVENT.Description = "Everyone is forced to stay in third-person"
EVENT.id = "thirdperson"

EVENT.Categories = {"largeimpact"}

function EVENT:Begin()
    util.AddNetworkString("ThirdPersonRandomat")

    timer.Simple(0.1, function()
        net.Start("ThirdPersonRandomat")
        net.Broadcast()
    end)
end

Randomat:register(EVENT)