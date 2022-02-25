local EVENT = {}
EVENT.Title = "Redemption Time"
EVENT.Description = "Puts someone with their worst traitor partner"
EVENT.id = "redemption"

function EVENT:Begin()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = randomatPlayerStats
    local alivePlayers = self:GetAlivePlayers(true)
    local chosenTraitor = alivePlayers[1]
    local ID = chosenTraitor:SteamID()
    local traitorPartnerWins = table.Copy(stats[ID]["TraitorPartnerWins"])
    local traitorPartnerRounds = table.Copy(stats[ID]["TraitorPartnerRounds"])
    local traitorWinRates = {}

    -- Getting the winrates of everyone but the chosen player, while they were partnered with the chosen player
    for i, ply in pairs(self:GetAlivePlayers()) do
        local plyID = ply:SteamID()

        if traitorPartnerWins[plyID] and traitorPartnerRounds[plyID] and plyID ~= ID then
            traitorWinRates[ply] = traitorPartnerWins[plyID] / traitorPartnerRounds[plyID]
        end
    end

    local chosenPartner

    if table.IsEmpty(traitorWinRates) then
        -- If the chosen player hasn't been a traitor with anyone yet, pick a random player
        chosenPartner = alivePlayers[2]
    else
        -- Else, finding the chosen player's worst partner
        chosenPartner = table.SortByKey(traitorWinRates, true)[1]
    end

    for _, ply in ipairs(alivePlayers) do
        -- Setting the chosen player and their worst partner to be ordinary traitors
        if ply == chosenTraitor or ply == chosenPartner then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:SetDefaultCredits()
        else
            -- Setting everyone else to be ordinary innocents, to give the traitors more of a chance to win
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
            ply:SetDefaultCredits()
        end
    end

    -- Updating everyone's displayed roles
    SendFullStateUpdate()

    -- Displaying the traitors' winrate
    timer.Simple(5, function()
        -- If a random player was chosen, display a 42% winrate as a fallback... 
        self:SmallNotify("The traitors have a " .. math.Round((traitorWinRates[chosenPartner] or 0.42) * 100) .. "% win rate!")
    end)
end

function EVENT:Condition()
    return #self:GetAlivePlayers() >= 3
end

Randomat:register(EVENT)