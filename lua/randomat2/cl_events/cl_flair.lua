net.Receive("FlairRandomatPlay", function()
    local snd = net.ReadString()
    surface.PlaySound(snd)
end)

-- Play the win sound, if any, on the client so only that player hears it
net.Receive("FlairRandomatWin", function()
    local winningTeam = net.ReadString()
    local winSound = net.ReadString()
    local lossSound = net.ReadString()
    local chosenSound = net.ReadString()
    local oldmanWinSound = net.ReadString()
    local oldmanLossSound = net.ReadString()
    local result = net.ReadInt(8)
    -- Hook to let user-made roles define their own win/loss sounds, or other manipulations
    local hookChosenSound = hook.Call("TTTChooseRoundEndSound", nil, LocalPlayer(), result)

    if hookChosenSound then
        chosenSound = hookChosenSound
    end

    -- If a special role won, play one of that role's special win sounds
    if chosenSound ~= "nosound" then
        surface.PlaySound(chosenSound)
        -- Old man win/loss
    elseif LocalPlayer():GetNWBool("OldManWinSound", false) and oldmanWinSound ~= "nosound" then
        surface.PlaySound(oldmanWinSound)
    elseif LocalPlayer():GetNWBool("OldManLossSound", false) and oldmanLossSound ~= "nosound" then
        surface.PlaySound(oldmanLossSound)
    elseif winSound ~= "nosound" and lossSound ~= "nosound" and CR_VERSION then
        -- When Custom roles is installed
        if (winningTeam == "innocent" or winningTeam == "time") and LocalPlayer():IsInnocentTeam() then
            surface.PlaySound(winSound)
        elseif winningTeam == "traitor" and LocalPlayer():IsTraitorTeam() then
            surface.PlaySound(winSound)
        elseif LocalPlayer():GetNWBool("OldManWinSound", false) then
            -- If there's no oldmanwin sounds, play an ordinary win sound
            surface.PlaySound(winSound)
        else
            surface.PlaySound(lossSound)
        end
    elseif winSound ~= "nosound" and lossSound ~= "nosound" then
        -- When Custom roles isn't installed
        if (winningTeam == "innocent" or winningTeam == "time") and (LocalPlayer():GetRole() == ROLE_INNOCENT or LocalPlayer():GetRole() == ROLE_DETECTIVE) then
            surface.PlaySound(winSound)
        elseif winningTeam == "traitor" and LocalPlayer():GetRole() == ROLE_TRAITOR then
            surface.PlaySound(winSound)
        else
            surface.PlaySound(lossSound)
            -- If WIN_NONE was the win result, chosenSound, winSound and lossSound are all "nosound", so nothing is played
        end
    end
end)