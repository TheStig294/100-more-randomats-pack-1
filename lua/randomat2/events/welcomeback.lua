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

    if CR_VERSION then
        SetGlobalInt("ttt_lootgoblin_announce", GetConVar("ttt_lootgoblin_announce"):GetInt())
        SetGlobalInt("ttt_lootgoblin_notify_mode", GetConVar("ttt_lootgoblin_notify_mode"):GetInt())
    end

    -- Continually checks for players' roles, in case roles change
    timer.Create("WelcomeBackRandomatCheckRoleChange", 1, 0, function()
        for _, ply in ipairs(self:GetAlivePlayers()) do
            ply:SetNWBool("WelcomeBackIsDetectiveLike", false)
            ply:SetNWBool("WelcomeBackIsGoodDetectiveLike", false)
            ply:SetNWBool("WelcomeBackJester", false)
            ply:SetNWBool("WelcomeBackTraitor", false)
            ply:SetNWBool("WelcomeBackCrossName", false)
        end

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
            elseif Randomat:IsTraitorTeam(ply) or ply.IsGlitch and ply:IsGlitch() then
                ply:SetNWBool("WelcomeBackTraitor", true)
            end

            if ply.IsGlitch and ply:IsGlitch() then
                SetGlobalBool("WelcomeBackGlitchExists", true)
            end
        end
    end)

    -- Crosses out player names after they die
    self:AddHook("PostPlayerDeath", function(ply)
        ply:SetNWBool("WelcomeBackCrossName", true)
    end)

    -- Reveals the role of a player when a corpse is searched
    self:AddHook("TTTCanIdentifyCorpse", function(_, ragdoll)
        local ply = CORPSE.GetPlayer(ragdoll)
        -- If the dead player has disconnected, they won't be on the scoreboard, so skip them
        if not IsPlayer(ply) then return end
        ply:SetNWInt("WelcomeBackScoreboardRoleRevealed", ragdoll.was_role)
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
    timer.Remove("WelcomeBackRandomatCheckRoleChange")
    net.Start("WelcomeBackRandomatEnd")
    net.Broadcast()

    -- Removes all flags set
    for _, ply in ipairs(player.GetAll()) do
        ply:SetNWBool("WelcomeBackIsDetectiveLike", false)
        ply:SetNWBool("WelcomeBackIsGoodDetectiveLike", false)
        ply:SetNWBool("WelcomeBackJester", false)
        ply:SetNWBool("WelcomeBackTraitor", false)
        ply:SetNWInt("WelcomeBackScoreboardRoleRevealed", -1)
        ply:SetNWBool("WelcomeBackCrossName", false)
    end

    SetGlobalBool("WelcomeBackGlitchExists", false)
end

-- Having too many alive players will result in the overlay overlapping names
function EVENT:Condition()
    return #self:GetAlivePlayers() < 10
end

Randomat:register(EVENT)