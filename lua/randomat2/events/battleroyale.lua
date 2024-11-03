local EVENT = {}

local zonesCvar = CreateConVar("randomat_battleroyale_storm_zones", 4, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The number of zones until the storm covers the map (Set to 0 to disable)", 0, 10)

local waitTimeCvar = CreateConVar("randomat_battleroyale_storm_wait_time", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds after the next zone is announced before the storm moves", 0, 120)

local moveTimeCvar = CreateConVar("randomat_battleroyale_storm_move_time", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds it takes for the storm to move", 0, 120)

local musicCvar = CreateConVar("randomat_battleroyale_music", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Play victory royale music when someone wins", 0, 1)

EVENT.Title = "LAST ONE STANDING WINS! BATTLE ROYALE!"
EVENT.Description = ""
EVENT.ExtDescription = "Everyone is turned into an innocent, and turns the game into a free-for-all!"
EVENT.id = "battleroyale"

EVENT.Categories = {"gamemode", "largeimpact"}

util.AddNetworkString("BattleRoyaleRandomat")

function EVENT:Begin()
    -- Giving everyone a Fortnite building tool, if it exists
    local fortniteToolExists = weapons.Get("weapon_ttt_fortnite_building") ~= nil

    if fortniteToolExists then
        EVENT.Description = "Press 'F' to change platform shape"

        for _, ply in player.Iterator() do
            ply:Give("weapon_ttt_fortnite_building")
        end
    end

    -- Turning everyone into an innocent
    for _, ply in player.Iterator() do
        self:StripRoleWeapons(ply)
        Randomat:SetRole(ply, ROLE_INNOCENT)
    end

    SendFullStateUpdate()
    -- Plays the Fortnite alert sound as an extra warning this randomat has started
    BroadcastLua("surface.PlaySound(\"battleroyale/alert.mp3\")")

    -- Preventing the round from ending if more than 1 person is alive
    self:AddHook("TTTCheckForWin", function()
        local playerAlive = false

        for _, ply in player.Iterator() do
            if ply:Alive() and not ply:IsSpec() then
                if playerAlive then return WIN_NONE end
                playerAlive = true
            end
        end
    end)

    -- Disabling giving karma penalties
    self:AddHook("TTTKarmaGivePenalty", function(ply, penalty, victim) return true end)
    local playMusic = musicCvar:GetBool()
    net.Start("BattleRoyaleRandomat")
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