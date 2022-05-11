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
    local alivePlayers = self:GetAlivePlayers(true)
    local playerCount = #alivePlayers
    local maxPlayersAnnounced = 7

    -- Displays this event's name in full and introduces up to 8 players names through randomat alerts
    timer.Create("WelcomeBackAlertStart", 3.031, 1, function()
        Randomat:EventNotify("Hello everyone and welcome back to Trouble in Terrorist Town!")

        timer.Create("WelcomeBackPlayerNameStart", 5, 1, function()
            self:SmallNotify("Today we're joined by...", 3)

            timer.Create("WelcomeBackIntroducePlayers", 3, playerCount, function()
                local namedPlayerCount = playerCount - timer.RepsLeft("WelcomeBackIntroducePlayers")

                -- Display the player's name if we're not over the cap on the amount of names displayed, and not on the last player
                if namedPlayerCount < maxPlayersAnnounced + 1 and namedPlayerCount ~= playerCount - 1 then
                    self:SmallNotify(alivePlayers[namedPlayerCount]:Nick() .. " and...", 3)
                else
                    -- But make the last alert always display "...did I forget anyone?" and not display that player's name
                    self:SmallNotify("...did I forget anyone?", 4)
                    timer.Remove("WelcomeBackIntroducePlayers")
                end
            end)
        end)
    end)
end

function EVENT:End()
    timer.Remove("WelcomeBackAlertStart")
    timer.Remove("WelcomeBackPlayerNameStart")
    timer.Remove("WelcomeBackIntroducePlayers")
end

Randomat:register(EVENT)