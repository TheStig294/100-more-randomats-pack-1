net.Receive("PistolsDrawHalos", function()
    hook.Add("PreDrawHalos", "PistolsRandomatHalos", function()
        local alivePlys = {}

        for k, v in ipairs(player.GetAll()) do
            if v:Alive() and not v:IsSpec() then
                alivePlys[k] = v
            end
        end

        halo.Add(alivePlys, Color(0, 255, 0), 0, 0, 1, true, true)
    end)
end)

net.Receive("PistolsRandomatWinTitle", function()
    hook.Add("TTTScoringWinTitle", "RandomatPistolsWinTitle", function(wintype, wintitles, title)
        local winner

        for i, ply in ipairs(player.GetAll()) do
            if ply:Alive() and not ply:IsSpec() then
                winner = ply
            end
        end

        if not winner then return end
        LANG.AddToLanguage("english", "win_pistols", string.upper(winner:Nick() .. " wins!"))

        local newTitle = {
            txt = "win_pistols",
            c = ROLE_COLORS[winner:GetRole()],
            params = nil
        }

        return newTitle
    end)
end)

net.Receive("PistolsRemoveHalos", function()
    hook.Remove("PreDrawHalos", "PistolsRandomatHalos")
    hook.Remove("TTTScoringWinTitle", "RandomatPistolsWinTitle")
end)