local EVENT = {}
local zonesCvar = CreateConVar("randomat_battleroyale2_storm_zones", 4, FCVAR_NONE, "The number of zones until the storm covers the map (Set to 0 to disable)", 0, 10)
local waitTimeCvar = CreateConVar("randomat_battleroyale2_storm_wait_time", 30, FCVAR_NONE, "Seconds after the next zone is announced before the storm moves", 0, 120)
local moveTimeCvar = CreateConVar("randomat_battleroyale2_storm_move_time", 30, FCVAR_NONE, "Seconds it takes for the storm to move", 0, 120)
local musicCvar = CreateConVar("randomat_battleroyale2_music", 1, FCVAR_NONE, "Play victory royale music when someone wins", 0, 1)
EVENT.Title = "LAST *PAIR* ALIVE WINS! Duos battle royale!"
EVENT.ExtDescription = "Everyone is turned into an innocent, and turns the game into a duos free-for-all!"
EVENT.id = "battleroyale2"

EVENT.Categories = {"gamemode", "largeimpact"}

util.AddNetworkString("BattleRoyale2Randomat")

function EVENT:Begin()
    local fortniteToolExists = weapons.Get("weapon_ttt_fortnite_building") ~= nil
    -- Players are in random order
    local plys = self:GetPlayers(true)

    if fortniteToolExists then
        EVENT.Description = "Press 'F' to change platform shape"

        for _, ply in ipairs(plys) do
            ply:Give("weapon_ttt_fortnite_building")
        end
    end

    -- Turning everyone into an innocent
    for _, ply in ipairs(plys) do
        self:StripRoleWeapons(ply)
        Randomat:SetRole(ply, ROLE_INNOCENT)
        ply:SetNWEntity("BattleRoyalePartner", NULL)
    end

    SendFullStateUpdate()
    -- Plays the Fortnite alert sound as an extra warning this randomat has started
    BroadcastLua("surface.PlaySound(\"battleroyale/alert.mp3\")")
    -- Putting players into pairs
    local partners = {}
    local partnerIndex = 0

    for _, ply in ipairs(plys) do
        for _, ply2 in ipairs(plys) do
            if ply:GetNWEntity("BattleRoyalePartner") ~= NULL then break end
            if ply2:GetNWEntity("BattleRoyalePartner") ~= NULL or ply2 == ply then continue end
            partnerIndex = partnerIndex + 1

            partners[partnerIndex] = {ply, ply2}

            ply:SetNWEntity("BattleRoyalePartner", ply2)
            ply2:SetNWEntity("BattleRoyalePartner", ply)
            local plyMessage = "Your partner is: " .. ply2:Nick()
            local ply2Message = "Your partner is: " .. ply:Nick()

            timer.Simple(2, function()
                ply:PrintMessage(HUD_PRINTTALK, plyMessage)
                ply2:PrintMessage(HUD_PRINTTALK, ply2Message)
            end)

            timer.Create("BattleRoyale2PartnerMessage" .. ply:SteamID64(), 1.9, 4, function()
                ply:PrintMessage(HUD_PRINTCENTER, plyMessage)
                ply2:PrintMessage(HUD_PRINTCENTER, ply2Message)
            end)
        end

        if ply:GetNWEntity("BattleRoyalePartner") == NULL then
            local plyMessage = "You have no partner :( here's x2 health!"
            ply:SetHealth(ply:Health() * 2)

            timer.Simple(2, function()
                ply:PrintMessage(HUD_PRINTTALK, plyMessage)
            end)

            timer.Create("BattleRoyale2PartnerMessage" .. ply:SteamID64(), 1.9, 4, function()
                ply:PrintMessage(HUD_PRINTCENTER, plyMessage)
            end)
        end
    end

    self:AddHook("TTTCheckForWin", function()
        local alivePlys = self:GetAlivePlayers()
        local alivePlysCount = #alivePlys
        -- If there are 2 players left and they're on the same team then they win
        if alivePlysCount == 2 and alivePlys[1]:GetNWEntity("BattleRoyalePartner") == alivePlys[2] then return WIN_INNOCENT end
        -- Else, block any win while there is more than 1 player alive
        if alivePlysCount > 1 then return WIN_NONE end
    end)

    -- Disabling giving karma penalties
    self:AddHook("TTTKarmaGivePenalty", function(ply, penalty, victim) return true end)

    -- Disabling damage on your partner
    self:AddHook("EntityTakeDamage", function(ent, dmg)
        local attacker = dmg:GetAttacker()
        if not IsPlayer(ent) or not IsPlayer(attacker) then return end

        if attacker == ent:GetNWEntity("BattleRoyalePartner") then
            attacker:PrintMessage(HUD_PRINTCENTER, "Don't hurt your partner!")

            return true
        end
    end)

    local playMusic = musicCvar:GetBool()
    net.Start("BattleRoyale2Randomat")
    net.WriteBool(playMusic)
    net.Broadcast()

    -- Disable round end sounds and 'Ending Flair' event so victory royale music can play
    if playMusic then
        self:DisableRoundEndSounds()
    end

    Randomat:BattleRoyaleStorm(zonesCvar:GetInt(), waitTimeCvar:GetInt(), moveTimeCvar:GetInt())
end

-- Prevent 'Contagious Morality' prevents only 1 player being alive at the end of the round
function EVENT:Condition()
    return not Randomat:IsEventActive("contagiousmorality")
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"storm_zones", "storm_wait_time", "storm_move_time"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    local checkboxes = {}

    for _, v in pairs({"music"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checkboxes, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders, checkboxes
end

Randomat:register(EVENT)