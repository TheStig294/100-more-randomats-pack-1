local EVENT = {}
EVENT.Title = "Ending Flair"
EVENT.Description = "Win/lose sounds now play at the end of each round, until the next map!"
EVENT.id = "flair"

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("FlairRandomatWin")
util.AddNetworkString("FlairRandomatPlay")
local eventTriggered = false
local sounds = {}
local convarNames = {}
local _, foundDirectories = file.Find("sound/flair/*", "GAME")

-- Initialising all sound files located in the "sound/flair" folder, including custom added sounds
for i, dir in ipairs(foundDirectories) do
    local disabledSounds = {}
    sounds[dir] = file.Find("sound/flair/" .. dir .. "/*", "GAME")

    -- Pre-caching all sounds as they are found, and forcing connecting clients to download them
    for j, fileName in ipairs(sounds[dir]) do
        Sound("sound/flair/" .. dir .. "/" .. fileName)
        resource.AddSingleFile("sound/flair/" .. dir .. "/" .. fileName)

        -- Creating a convar for each sound to turn it off
        local convar = CreateConVar("randomat_flair_" .. dir .. "_" .. fileName, "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether this sound can play: " .. dir .. "/" .. fileName, 0, 1)

        table.insert(convarNames, dir .. "_" .. fileName)

        -- Adding a console command to play the sound
        concommand.Add("randomat_flair_" .. dir .. "_" .. fileName .. "_playsound", function(plyexe, cc, arg)
            net.Start("FlairRandomatPlay")
            net.WriteString("flair/" .. dir .. "/" .. fileName)
            net.Send(plyexe)
        end)

        -- Removing any round end sounds that have been turned off
        if not convar:GetBool() then
            table.insert(disabledSounds, fileName)
        end
    end

    for k, fileName in ipairs(disabledSounds) do
        table.RemoveByValue(sounds[dir], fileName)
    end
end

function EVENT:Begin()
    eventTriggered = true

    -- Note: hook.Add() is used not self:AddHook() to ensure this event persists between rounds once triggered, until the server is restarted or the map is changed
    hook.Add("TTTEndRound", "TTTFlairRandomat", function(result)
        if GetGlobalBool("StopEndingFlairRandomat") then return end
        -- Hard-coded list of win condition names and their enumerators cause idk how to dynamically get them
        local wins = {}
        wins["time"] = WIN_TIMELIMIT
        wins["innocent"] = WIN_INNOCENT
        wins["traitor"] = WIN_TRAITOR
        wins["jester"] = WIN_JESTER
        wins["killer"] = WIN_KILLER
        wins["zombie"] = WIN_ZOMBIE
        wins["clown"] = WIN_CLOWN
        wins["monster"] = WIN_MONSTER
        wins["lover"] = WIN_LOVER
        wins["vampire"] = WIN_VAMPIRE
        wins["bees"] = WIN_BEES
        wins["bee"] = WIN_BEE
        wins["boxer"] = WIN_BOXER
        wins["communist"] = WIN_COMMUNIST
        -- Sound played depends on who wins
        local winningTeam = "noteam"
        local chosenSound = "nosound"
        local winSound = "nosound"
        local lossSound = "nosound"
        local oldmanWinSound = "nosound"
        local oldmanLossSound = "nosound"
        local oldman = false

        -- Getting the name of the team that won
        for i, winNumber in pairs(wins) do
            if result == winNumber then
                winningTeam = table.KeyFromValue(wins, winNumber)
            end
        end

        -- Handling an old man win/loss, which can have its own set of win/loss sounds
        for i, ply in ipairs(player.GetAll()) do
            if ply:GetRole() == ROLE_OLDMAN and ply:Alive() and not ply:IsSpec() then
                ply:SetNWBool("OldManWinSound", true)
                oldman = true
            elseif ply:GetRole() == ROLE_OLDMAN and ply:IsSpec() and not ply:Alive() then
                ply:SetNWBool("OldManLossSound", true)
                oldman = true
            end
        end

        if sounds["oldmanwin"][1] ~= nil and oldman then
            oldmanWinSound = "flair/oldmanwin/" .. sounds["oldmanwin"][math.random(1, #sounds["oldmanwin"])]
        elseif sounds["oldmanloss"][1] ~= nil and oldman then
            oldmanLossSound = "flair/oldmanloss/" .. sounds["oldmanloss"][math.random(1, #sounds["oldmanloss"])]
        end

        if winningTeam == "innocent" or winningTeam == "traitor" or winningTeam == "time" then
            -- Choose a win/lose sound if the innocents or traitors win, or the time runs out (because it is its own win condition, but displays as an innocent win)
            winSound = "flair/win/" .. sounds["win"][math.random(1, #sounds["win"])]
            lossSound = "flair/loss/" .. sounds["loss"][math.random(1, #sounds["loss"])]
        elseif winningTeam ~= "noteam" and sounds[winningTeam] ~= nil then
            -- Choose a random sound from the winning team's pool of sounds
            chosenSound = "flair/" .. winningTeam .. "/" .. sounds[winningTeam][math.random(1, #sounds[winningTeam])]
        elseif winningTeam == "monster" then
            -- If the monster team wins, and there are no monster team sounds, choose a random zombies sound
            chosenSound = "flair/zombie/" .. sounds["zombie"][math.random(1, #sounds["zombie"])]
        elseif winningTeam == "bee" then
            -- If it's a bee win, and there are no bee win sounds, choose a random bees win sound
            chosenSound = "flair/bees/" .. sounds["bees"][math.random(1, #sounds["bees"])]
        elseif sounds["loss"][1] ~= nil and result ~= WIN_NONE then
            -- If a win condition happens that's not in the "wins" table, (E.g. a new role's win), choose a random 'loss' sound to play for everyone
            chosenSound = "flair/loss/" .. sounds["loss"][math.random(1, #sounds["loss"])]
        end

        -- Play the sound for everyone
        timer.Simple(0.1, function()
            net.Start("FlairRandomatWin")
            net.WriteString(winningTeam)
            net.WriteString(winSound)
            net.WriteString(lossSound)
            net.WriteString(chosenSound)
            net.WriteString(oldmanWinSound)
            net.WriteString(oldmanLossSound)
            net.WriteInt(result, 8)
            net.Broadcast()
        end)

        -- Reset the old man win/loss sound
        timer.Simple(5, function()
            for i, ply in ipairs(player.GetAll()) do
                ply:SetNWBool("OldManWinSound", false)
                ply:SetNWBool("OldManLossSound", false)
            end
        end)
    end)
end

function EVENT:Condition()
    -- This event cannot trigger more than once a map, and cannot trigger at all if the round end sounds mod is installed as that makes this event redundant
    return not (eventTriggered or file.Exists("autorun/_round_end_sounds.lua", "lsv"))
end

function EVENT:GetConVars()
    local checks = {}

    for _, v in pairs(convarNames) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks
end

Randomat:register(EVENT)