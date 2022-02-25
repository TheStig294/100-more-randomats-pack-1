local EVENT = {}
EVENT.Title = "100% Detective Winrate"
EVENT.Description = "Whoever has the highest detective winrate is now the detective!"
EVENT.id = "detectivewinrate"

function EVENT:Begin()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = randomatPlayerStats
    local alivePlayers = self:GetAlivePlayers(true)
    local detectiveWinrates = {}
    local zylusEasterEgg = false
    local chosenDetective

    -- Grabbing everyone's detective winrate
    for _, ply in ipairs(alivePlayers) do
        if ply:GetModel() == "models/player/jenssons/kermit.mdl" or ply:Nick() == "Zylus" then
            zylusEasterEgg = true
            chosenDetective = ply
            break
        end

        local ID = ply:SteamID()
        local detectiveWins = stats[ID]["DetectiveWins"]
        local detectiveRounds = stats[ID]["DetectiveRounds"]
        -- Can't have a detective winrate if you've played no rounds as detective! Also, that's dividing by zero, which is a no-no
        if detectiveRounds == 0 then continue end
        detectiveWinrates[ply] = detectiveWins / detectiveRounds
    end

    if not zylusEasterEgg then
        -- Grabbing the Steam nickname of the player with the highest detective winrate
        if table.IsEmpty(detectiveWinrates) then
            -- If the chosen player hasn't been a traitor with anyone yet, pick a random player
            chosenDetective = table.Random(alivePlayers)
        else
            -- Else, finding the chosen player's best partner
            chosenDetective = table.GetWinningKey(detectiveWinrates)
        end
    end

    local removedDetectiveRole

    -- Turn a current detective into an innocent, if there is one
    for _, ply in ipairs(alivePlayers) do
        if Randomat:IsGoodDetectiveLike(ply) then
            removedDetectiveRole = ply:GetRole()
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
            ply:SetDefaultCredits()
            break
        end
    end

    local traitorChanged = false

    -- Make the player with the highest winrate a detective
    for _, ply in ipairs(alivePlayers) do
        if ply == chosenDetective then
            if Randomat:IsTraitorTeam(ply) then
                traitorChanged = true
            end

            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, removedDetectiveRole or ROLE_DETECTIVE)
            ply:SetDefaultCredits()
        end
    end

    -- If a traitor was made the detective, change a random non-traitor, non-detective into traitor
    for _, ply in ipairs(alivePlayers) do
        if traitorChanged and not Randomat:IsTraitorTeam(ply) and not Randomat:IsDetectiveLike(ply) then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:SetDefaultCredits()

            if Randomat:GetRoundCompletePercent() > 5 then
                timer.Simple(0.1, function()
                    ply:ChatPrint("You were changed to a traitor, \nbecause the detective was originally a traitor")
                end)
            end

            break
        end
    end

    SendFullStateUpdate()
    local winrate

    if zylusEasterEgg then
        winrate = 100

        self:AddHook("PostPlayerDeath", function(ply)
            if ply == chosenDetective then
                timer.Create("DetectiveWinrateEasterEggMessage", 1, 3, function()
                    ply:PrintMessage(HUD_PRINTCENTER, "This was a non-cannon round...")
                end)
            end
        end)
    else
        winrate = math.Round((detectiveWinrates[chosenDetective] or 1) * 100)
    end

    --Notifying everyone of the detective's winrate
    timer.Simple(5, function()
        self:SmallNotify(chosenDetective:Nick() .. " is the detective with a " .. winrate .. "% win rate!")
    end)
end

Randomat:register(EVENT)