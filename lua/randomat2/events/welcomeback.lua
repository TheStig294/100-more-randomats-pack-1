local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Welcome back to TTT!"
EVENT.ExtDescription = "Introduces everyone and adds a role overlay on the screen"
EVENT.id = "welcomeback"
-- Can only trigger at the start of the round
EVENT.MaxRoundCompletePercent = 5

EVENT.Categories = {"moderateimpact"}

util.AddNetworkString("WelcomeBackRandomatPopup")
util.AddNetworkString("WelcomeBackRandomatCreateOverlay")
util.AddNetworkString("WelcomeBackRandomatEnd")

function EVENT:Begin()
    -- Puts the intro popup on the screen for all players
    local randomIntroSound = "welcomeback/intro" .. math.random(1, 3) .. ".mp3"
    net.Start("WelcomeBackRandomatPopup")
    net.WriteString(randomIntroSound)
    net.Broadcast()

    -- Sets flags on players using randomat functions only available on the server
    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsDetectiveLike(ply) then
            ply:SetNWBool("WelcomeBackIsDetectiveLike", true)
        elseif Randomat:IsJesterTeam(ply) then
            ply:SetNWBool("WelcomeBackJester", true)
        elseif Randomat:IsTraitorTeam(ply) or (ROLE_GLITCH and ply:GetRole() == ROLE_GLITCH) then
            ply:SetNWBool("WelcomeBackTraitor", true)
        end
    end

    self:AddHook("TTTCanIdentifyCorpse", function(_, corpse)
        local ply = player.GetBySteamID(corpse.sid)
        ply:SetNWBool("WelcomeBackScoreboardRoleRevealed", true)
    end)

    -- Displays this event's name in full and introduces up to 8 players names through randomat alerts
    timer.Create("WelcomeBackRandomatDrawOverlay", 3.031, 1, function()
        net.Start("WelcomeBackRandomatCreateOverlay")
        net.Broadcast()
    end)
end

function EVENT:End()
    -- Removes all popups on the screen
    timer.Remove("WelcomeBackRandomatDrawOverlay")
    net.Start("WelcomeBackRandomatEnd")
    net.Broadcast()

    -- Removes all flags set
    for _, ply in ipairs(player.GetAll()) do
        ply:SetNWBool("WelcomeBackIsDetectiveLike", false)
        ply:SetNWBool("WelcomeBackJester", false)
        ply:SetNWBool("WelcomeBackTraitor", false)
        ply:SetNWBool("WelcomeBackScoreboardRoleRevealed", false)
    end
end

Randomat:register(EVENT)