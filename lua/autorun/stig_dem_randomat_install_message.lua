if engine.ActiveGamemode() == "terrortown" then
    if SERVER and file.Exists("sound/weapons/randomat_revolver.wav", "GAME") and file.Exists("randomat2/randomat_shared.lua", "lsv") then
        util.AddNetworkString("StigDemRandomatInstallNet")
        local roundCount = 0

        hook.Add("TTTBeginRound", "StigDemRandomatInstallMessage", function()
            roundCount = roundCount + 1

            if (roundCount == 1) or (roundCount == 2) then
                timer.Simple(4, function()
                    PrintMessage(HUD_PRINTTALK, "Server has 2 incompatible randomat mods installed!\nPRESS 'Y', TYPE /2randomat AND ONLY INSTALL ONE OR THE OTHER\nor see the workshop pages for 'Randomat 2.0',\nand 'Randomat 2.0 for Custom Roles for TTT'.")
                end)
            end
        end)

        hook.Add("PlayerSay", "StigDemRandomatInstallCommand", function(ply, text)
            if string.lower(text) == "/2randomat" then
                net.Start("StigDemRandomatInstallNet")
                net.Send(ply)

                return ""
            end
        end)
    elseif CLIENT then
        net.Receive("StigDemRandomatInstallNet", function()
            steamworks.ViewFile("1406495040")
        end)
    end
end