local EVENT = {}
EVENT.Title = "Ending Flair"
EVENT.Description = "Sound effect plays at the end of the round, until the next map"
EVENT.id = "flair"

traitorMusic = {Sound("flair/pmd_fail.wav"), Sound("flair/mission_failed.wav"), Sound("flair/team_skull.wav"), Sound("flair/overwatch_defeat.wav"), Sound("flair/oh_no.wav"), Sound("flair/impostorwin.wav")}

monstersMusic = {Sound("flair/zombies_round_start.wav"), Sound("flair/zombies_round_end.wav")}

jesterMusic = {Sound("flair/old_man_laughing.wav"), Sound("flair/goteeem.wav"), Sound("flair/drawn_to_death.wav")}

killerMusic = {Sound("flair/overwatch_team_kill.wav"), Sound("flair/valorant_team_kill.wav")}

innocentMusic = {Sound("flair/ff_fanfare.wav"), Sound("flair/ff_simon_fanfare.wav"), Sound("flair/pmd_fanfare.wav"), Sound("flair/pmd_fanfare2.wav"), Sound("flair/pokemon_fanfare.wav"), Sound("flair/zelda_fanfare.wav"), Sound("flair/crewmatewin.wav")}

function EVENT:Begin()
    hook.Add("TTTEndRound", "EndingFlairFanfare", function(result)
        if result == WIN_TRAITOR then
            chosenSound = table.Random(traitorMusic)
        else
            if result == WIN_MONSTER then
                chosenSound = table.Random(monstersMusic)
            else
                if result == WIN_JESTER then
                    chosenSound = table.Random(jesterMusic)
                else
                    if result == WIN_KILLER then
                        chosenSound = table.Random(killerMusic)
                    else
                        chosenSound = table.Random(innocentMusic)
                    end
                end
            end
        end

        timer.Simple(0.1, function()
            for i, ply in pairs(player.GetAll()) do
                ply:EmitSound(chosenSound)
            end
        end)
    end)
end

Randomat:register(EVENT)