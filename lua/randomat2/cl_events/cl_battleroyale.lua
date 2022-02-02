net.Receive("RandomatBattleRoyaleWinTitle", function()
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
end)

net.Receive("RandomatBattleRoyaleWinTitleRemove", function()
    hook.Remove("TTTScoringWinTitle", "RandomatBattleRoyalWinTitle")
end)