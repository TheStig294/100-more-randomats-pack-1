local EVENT = {}
EVENT.Title = "Sharky and Palp!"
EVENT.Description = "Puts someone with their best traitor partner!"
EVENT.id = "sharky"

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
    for _, ply in pairs(self:GetAlivePlayers()) do
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
        -- Else, finding the chosen player's best partner
        chosenPartner = table.GetWinningKey(traitorWinRates)
    end

    -- Setting the chosen player and their best partner to be traitors
    -- First, re-select everyone's roles so a player not being a detective anymore isn't suspicious
    SelectRoles()
    -- Now counting the number of traitors alive, so their number is preserved
    local originalTraitorCount = 0

    for _, ply in ipairs(alivePlayers) do
        if Randomat:IsTraitorTeam(ply) then
            originalTraitorCount = originalTraitorCount + 1
        end
    end

    -- Set the role of the chosen traitors to ordinary traitors, if they aren't a traitor already
    for _, ply in ipairs({chosenTraitor, chosenPartner}) do
        if not Randomat:IsTraitorTeam(ply) then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:SetDefaultCredits()
        end
    end

    -- Setting the roles of everyone else to innocent, if there are now more traitors than when everyone's roles were re-selected
    local traitorCount = 2

    for _, ply in ipairs(alivePlayers) do
        if Randomat:IsTraitorTeam(ply) and ply ~= chosenTraitor and ply ~= chosenPartner then
            traitorCount = traitorCount + 1

            if traitorCount > originalTraitorCount then
                self:StripRoleWeapons(ply)
                Randomat:SetRole(ply, ROLE_INNOCENT)
                ply:SetDefaultCredits()
            end
        end
    end

    -- Updating everyone's displayed roles
    SendFullStateUpdate()

    -- Displaying the traitors' winrate
    timer.Simple(5, function()
        -- If a random player was chosen, display a 100% winrate as a fallback
        self:SmallNotify("The traitors have a " .. math.Round((traitorWinRates[chosenPartner] or 1) * 100) .. "% win rate!")
    end)
end

function EVENT:Condition()
    return #self:GetAlivePlayers() >= 3
end

Randomat:register(EVENT)