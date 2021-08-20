local EVENT = {}
EVENT.Title = "Ending Flair"
EVENT.Description = "Sound effect plays at the end of the round, depending on who wins"
EVENT.id = "flair"

local traitorMusic = {Sound("flair/pmd_fail.wav"), Sound("flair/mission_failed.wav"), Sound("flair/team_skull.wav"), Sound("flair/overwatch_defeat.wav"), Sound("flair/oh_no.wav"), Sound("flair/impostorwin.wav")}

local monstersMusic = {Sound("flair/zombies_round_start.wav"), Sound("flair/zombies_round_end.wav")}

local jesterMusic = {Sound("flair/old_man_laughing.wav"), Sound("flair/goteeem.wav"), Sound("flair/drawn_to_death.wav")}

local killerMusic = {Sound("flair/overwatch_team_kill.wav"), Sound("flair/valorant_team_kill.wav")}

local innocentMusic = {Sound("flair/ff_fanfare.wav"), Sound("flair/ff_simon_fanfare.wav"), Sound("flair/pmd_fanfare.wav"), Sound("flair/pmd_fanfare2.wav"), Sound("flair/pokemon_fanfare.wav"), Sound("flair/zelda_fanfare.wav"), Sound("flair/crewmatewin.wav")}

function EVENT:Begin()
    -- Not self:AddHook() because we want this to play throughout multiple rounds
    hook.Add("TTTEndRound", "EndingFlairFanfare", function(result)
        -- Music played depends on who wins
        if result == WIN_TRAITOR then
            chosenSound = table.Random(traitorMusic)
        elseif result == WIN_MONSTER then
            chosenSound = table.Random(monstersMusic)
        elseif result == WIN_JESTER then
            chosenSound = table.Random(jesterMusic)
        elseif (result == WIN_KILLER) or (result == WIN_CLOWN) then
            chosenSound = table.Random(killerMusic)
        else
            -- If innocents win, time runs out or some other win condition occurs, selects a random innocent win sound
            chosenSound = table.Random(innocentMusic)
        end

        -- Plays the sound for everyone
        timer.Simple(0.1, function()
            for i, ply in pairs(self:GetPlayers()) do
                ply:EmitSound(chosenSound)
            end
        end)
    end)
end

function EVENT:Condition()
    return not file.Exists("autorun/ttt_round_end_sounds.lua", "lsv")
end

Randomat:register(EVENT)