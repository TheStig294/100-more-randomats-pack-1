local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Welcome back to TTT!"
EVENT.ExtDescription = "Adds a role overlay on the screen"
EVENT.id = "welcomeback"

EVENT.Categories = {"largeimpact", "deathtrigger"}

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
        if Randomat:IsGoodDetectiveLike(ply) then
            ply:SetNWBool("WelcomeBackIsGoodDetectiveLike", true)
            ply:SetNWBool("WelcomeBackIsDetectiveLike", true)
        elseif Randomat:IsEvilDetectiveLike(ply) then
            ply:SetNWBool("WelcomeBackTraitor", true)
            ply:SetNWBool("WelcomeBackIsDetectiveLike", true)
        elseif Randomat:IsDetectiveLike(ply) then
            ply:SetNWBool("WelcomeBackIsDetectiveLike", true)
        elseif Randomat:IsJesterTeam(ply) then
            ply:SetNWBool("WelcomeBackJester", true)
        elseif Randomat:IsTraitorTeam(ply) or (ROLE_GLITCH and ply:GetRole() == ROLE_GLITCH) then
            ply:SetNWBool("WelcomeBackTraitor", true)
        end

        if ROLE_GLITCH and ply:GetRole() == ROLE_GLITCH then
            SetGlobalBool("WelcomeBackGlitchExists", true)
        end
    end

    -- Reveals the role of a player when a corpse is searched
    self:AddHook("TTTCanIdentifyCorpse", function(_, ragdoll)
        local ply = CORPSE.GetPlayer(ragdoll)
        ply:SetNWBool("WelcomeBackScoreboardRoleRevealed", true)
    end)

    -- Starts fading in the role overlay and displays the event's name without making the randomat alert sound
    timer.Create("WelcomeBackRandomatDrawOverlay", 3.031, 1, function()
        net.Start("WelcomeBackRandomatCreateOverlay")
        net.Broadcast()
        Randomat:EventNotifySilent(self.AltTitle)
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
        ply:SetNWBool("WelcomeBackIsGoodDetectiveLike", false)
        ply:SetNWBool("WelcomeBackJester", false)
        ply:SetNWBool("WelcomeBackTraitor", false)
        ply:SetNWBool("WelcomeBackScoreboardRoleRevealed", false)
    end

    SetGlobalBool("WelcomeBackGlitchExists", false)
end

-- More than 8 alive players will result in the overlay going off the screen and causing lag eventually
function EVENT:Condition()
    return #self:GetAlivePlayers() <= 8
end

Randomat:register(EVENT)