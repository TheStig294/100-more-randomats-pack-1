local EVENT = {}
EVENT.Title = "100% Detective Winrate"
EVENT.Description = "Whoever has the highest detective winrate is now the detective!"
EVENT.id = "detectivewinrate"

EVENT.Categories = {"biased_innocent", "biased", "stats", "smallimpact"}

if util.IsValidModel("models/player/jenssons/kermit.mdl") then
    table.insert(EVENT.Categories, 1, "modelchange")
end

function EVENT:Begin()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = GetRandomatPlayerStats()
    local alivePlayers = self:GetAlivePlayers(true)
    local detectiveWinrates = {}
    local chosenDetective

    -- Grabbing everyone's detective winrate
    for _, ply in ipairs(alivePlayers) do
        local ID = ply:SteamID()
        local detectiveWins = stats[ID]["DetectiveWins"]
        local detectiveRounds = stats[ID]["DetectiveRounds"]
        -- Can't have a detective winrate if you've played no rounds as detective! Also, that's dividing by zero, which is a no-no
        if detectiveRounds == 0 then continue end
        detectiveWinrates[ply] = detectiveWins / detectiveRounds
    end

    -- Grabbing the Steam nickname of the player with the highest detective winrate
    if table.IsEmpty(detectiveWinrates) then
        -- If the chosen player hasn't been a traitor with anyone yet, pick a random player
        chosenDetective = alivePlayers[math.random(#alivePlayers)]
    else
        -- Else, finding the chosen player's best partner
        chosenDetective = table.GetWinningKey(detectiveWinrates)
    end

    local removedDetectiveRole
    local roleWeapons = {}

    -- Turn a current detective into an innocent, if there is one
    for _, ply in ipairs(alivePlayers) do
        if Randomat:IsGoodDetectiveLike(ply) then
            removedDetectiveRole = ply:GetRole()

            for _, wep in ipairs(ply:GetWeapons()) do
                if wep.Kind == WEAPON_ROLE then
                    table.insert(roleWeapons, wep:GetClass())
                end
            end

            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
            ply:SetDefaultCredits()
            break
        end
    end

    local traitorChanged = false

    -- Make the player with the highest winrate a detective
    for _, ply in ipairs(alivePlayers) do
        if ply == chosenDetective then
            if Randomat:IsTraitorTeam(ply) then
                traitorChanged = true
            end

            self:StripRoleWeapons(ply)

            for _, wep in ipairs(roleWeapons) do
                ply:Give(wep)
            end

            Randomat:SetRole(ply, removedDetectiveRole or ROLE_DETECTIVE)
            ply:SetDefaultCredits()

            if util.IsValidModel("models/player/jenssons/kermit.mdl") then
                Randomat:ForceSetPlayermodel(ply, "models/player/jenssons/kermit.mdl")
            end
        end
    end

    -- If a traitor was made the detective, change a random non-traitor, non-detective into traitor
    for _, ply in ipairs(alivePlayers) do
        if traitorChanged and not Randomat:IsTraitorTeam(ply) and not Randomat:IsDetectiveLike(ply) then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:SetDefaultCredits()

            if Randomat:GetRoundCompletePercent() > 5 then
                timer.Simple(0.1, function()
                    ply:ChatPrint("You were changed to a traitor, \nbecause the detective was originally a traitor")
                end)
            end

            break
        end
    end

    SendFullStateUpdate()

    -- If someone has the detective frog playermodel, say this was a non-canon round...
    self:AddHook("PostPlayerDeath", function(ply)
        if Randomat:IsGoodDetectiveLike(ply) and ply:GetModel() == "models/player/jenssons/kermit.mdl" then
            timer.Create("DetectiveWinrateEasterEggMessage", 1, 3, function()
                ply:PrintMessage(HUD_PRINTCENTER, "This was a non-canon round...")
            end)
        end
    end)

    --Notifying everyone of the detective's winrate
    timer.Simple(5, function()
        self:SmallNotify(chosenDetective:Nick() .. " is the detective with a " .. math.Round((detectiveWinrates[chosenDetective] or 1) * 100) .. "% win rate!")
    end)
end

function EVENT:End()
    Randomat:ForceResetAllPlayermodels()
end

Randomat:register(EVENT)