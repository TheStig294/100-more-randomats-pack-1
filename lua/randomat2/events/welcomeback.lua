local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Welcome back to TTT!"
EVENT.ExtDescription = "Introduces everyone and adds a role overlay on the screen"
EVENT.id = "welcomeback"
-- Can only trigger at the start of the round
EVENT.MaxRoundCompletePercent = 5

EVENT.Categories = {"moderateimpact"}

util.AddNetworkString("WelcomeBackRandomatPopup")

function EVENT:Begin()
    local randomIntroSound = "welcomeback/intro" .. math.random(1, 3) .. ".mp3"
    net.Start("WelcomeBackRandomatPopup")
    net.WriteString(randomIntroSound)
    net.Broadcast()
end

function EVENT:End()
end

Randomat:register(EVENT)