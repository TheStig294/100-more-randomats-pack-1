net.Receive("RandomatBattleroyale2Begin", function()
    local customRolesInstalled = net.ReadBool()
    local playMusic = net.ReadBool()

    if customRolesInstalled then
        hook.Add("TTTScoringWinTitle", "RandomatBattleRoyale2WinTitle", function(wintype, wintitles, title)
            local winner
            local winner2

            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() and not ply:IsSpec() then
                    winner = ply
                    winner2 = winner:GetNWEntity("BattleRoyalePartner")
                    break
                end
            end

            if not winner then return end
            local winString

            if winner2 ~= NULL then
                winString = winner:Nick() .. " and " .. winner2:Nick() .. " win!"
            else
                winString = winner:Nick() .. "  wins!"
            end

            LANG.AddToLanguage("english", "win_battleroyale2", string.upper(winString))

            local newTitle = {
                txt = "win_battleroyale2",
                c = ROLE_COLORS[ROLE_INNOCENT],
                params = nil
            }

            return newTitle
        end)
    end

    if playMusic then
        hook.Add("TTTEndRound", "RandomatBattleRoyale2Music", function(result)
            timer.Simple(0.3, function()
                for i = 1, 2 do
                    surface.PlaySound("battleroyale/fortnite_victory_royale.mp3")
                end
            end)
        end)
    end

    hook.Add("PreDrawHalos", "RandomatBattleRoyale2Halos", function()
        local haloEnts = {LocalPlayer():GetNWEntity("BattleRoyalePartner")}

        if not IsValid(haloEnts[1]) then return end
        halo.Add(haloEnts, Color(0, 255, 0), 0, 0, 1, true, true)
    end)
end)

net.Receive("RandomatBattleroyale2End", function()
    hook.Remove("TTTScoringWinTitle", "RandomatBattleRoyale2WinTitle")
    hook.Remove("TTTEndRound", "RandomatBattleRoyale2Music")
    hook.Remove("PreDrawHalos", "RandomatBattleRoyale2Halos")
end)