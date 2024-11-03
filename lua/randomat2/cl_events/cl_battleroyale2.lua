net.Receive("BattleRoyale2Randomat", function()
    local playMusic = net.ReadBool()

    if CR_VERSION then
        local partners = {}

        timer.Create("BattleRoyale2RandomatGetPartners", 2, 1, function()
            for _, ply in ipairs(player.GetAll()) do
                local partner = ply:GetNWEntity("BattleRoyalePartner")

                if IsValid(partner) then
                    partners[ply] = partner
                end
            end
        end)

        hook.Add("TTTScoringWinTitle", "BattleRoyale2RandomatWinTitle", function(wintype, wintitles, title)
            local winner
            local winner2

            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() and not ply:IsSpec() then
                    winner = ply
                    winner2 = partners[ply]
                    break
                end
            end

            if not winner then return end
            local winString

            if IsValid(winner2) then
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
        hook.Add("TTTEndRound", "BattleRoyale2RandomatMusic", function(result)
            timer.Simple(0.3, function()
                for i = 1, 2 do
                    surface.PlaySound("battleroyale/fortnite_victory_royale.mp3")
                end
            end)
        end)
    end

    hook.Add("PreDrawHalos", "BattleRoyale2RandomatHalos", function()
        local haloEnts = {LocalPlayer():GetNWEntity("BattleRoyalePartner")}

        if not IsValid(haloEnts[1]) then return end
        halo.Add(haloEnts, Color(0, 255, 0), 0, 0, 1, true, true)
    end)

    hook.Add("TTTPrepareRound", "BattleRoyale2RandomatEnd", function()
        hook.Remove("TTTScoringWinTitle", "BattleRoyale2RandomatWinTitle")
        hook.Remove("TTTEndRound", "BattleRoyale2RandomatMusic")
        hook.Remove("PreDrawHalos", "BattleRoyale2RandomatHalos")
        hook.Remove("TTTPrepareRound", "BattleRoyale2RandomatEnd")
    end)
end)