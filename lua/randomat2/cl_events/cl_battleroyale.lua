net.Receive("BattleRoyaleRandomat", function()
    local playMusic = net.ReadBool()

    if CR_VERSION then
        hook.Add("TTTScoringWinTitle", "BattleRoyaleRandomatWinTitle", function(wintype, wintitles, title)
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

    hook.Add("TTTPrepareRound", "BattleRoyaleRandomatEnd", function()
        hook.Remove("TTTScoringWinTitle", "BattleRoyaleRandomatWinTitle")
        hook.Remove("TTTEndRound", "RandomatVictoryRoyaleMusic")
        hook.Remove("TTTPrepareRound", "BattleRoyaleRandomatEnd")
    end)
end)