net.Receive("RandomatBattleRoyaleBegin", function()
    local customRolesInstalled = net.ReadBool()
    local playMusic = net.ReadBool()

    if customRolesInstalled then
        hook.Add("TTTScoringWinTitle", "RandomatBattleRoyalWinTitle", function(wintype, wintitles, title)
            local winner

            for i, ply in ipairs(player.GetAll()) do
                if ply:Alive() and not ply:IsSpec() then
                    winner = ply
                end
            end

            if not winner then return end
            LANG.AddToLanguage("english", "win_battleroyale", string.upper(winner:Nick() .. " wins!"))

            local newTitle = {
                txt = "win_battleroyale",
                c = ROLE_COLORS[ROLE_INNOCENT],
                params = nil
            }

            return newTitle
        end)
    end

    if playMusic then
        hook.Add("TTTEndRound", "RandomatVictoryRoyaleMusic", function(result)
            timer.Simple(0.3, function()
                for i = 1, 2 do
                    surface.PlaySound("battleroyale/fortnite_victory_royale.mp3")
                end
            end)
        end)
    end
end)

net.Receive("RandomatBattleRoyaleEnd", function()
    hook.Remove("TTTScoringWinTitle", "RandomatBattleRoyalWinTitle")
    hook.Remove("TTTEndRound", "RandomatVictoryRoyaleMusic")
end)