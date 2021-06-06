local EVENT = {}
EVENT.Title = "How dreary"
EVENT.Description = "Turns nearly everything black and white"
EVENT.id = "dreary"
util.AddNetworkString("randomat_dreary")
util.AddNetworkString("randomat_dreary_end")

function EVENT:Begin()
    drearyRandomat = true
    net.Start("randomat_dreary")
    net.Broadcast()
end

function EVENT:End()
    -- Checking if the randomat has run before trying to remove the greyscale effect, else causes an error
    if drearyRandomat then
        net.Start("randomat_dreary_end")
        net.Broadcast()
    end
end

Randomat:register(EVENT)