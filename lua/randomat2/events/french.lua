local EVENT = {}
EVENT.Title = "Événement Aléatoire" -- "Random Event"
EVENT.AltTitle = "French Randomat"
EVENT.Description = "Change la majeure partie du jeu en français"
EVENT.ExtDescription = "Changes most of the game to French"
EVENT.id = "french"

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("FrenchRandomatBegin")
util.AddNetworkString("FrenchRandomatEnd")
local eventRun = false

function EVENT:Begin()
    eventRun = true
    net.Start("FrenchRandomatBegin")
    net.Broadcast()

    if CR_VERSION then
        local assassinMessageDelay = GetConVar("ttt_assassin_next_target_delay"):GetInt()

        self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
            if not IsValid(ply) then return end

            if IsPlayer(attacker) and attacker:IsAssassin() and ply ~= attacker then
                -- Overriding the usual assassin messages with nonsense ones.
                -- But they're in French, no one will be able to tell right?
                -- CR can't use the TTT language system for everything, anything server-side would need to be networked, so I can't actually translate these messages properly
                -- Also, it's just a thing in Gmod that HUD_PRINTCENTER does nothing client-side so :P
                attacker:PrintMessage(HUD_PRINTCENTER, "Vous avez tué quelqu'un en tant qu'assassin. Bravo.")

                if assassinMessageDelay > 0 then
                    timer.Simple(assassinMessageDelay + 0.1, function()
                        attacker:PrintMessage(HUD_PRINTCENTER, "Vous avez peut-être reçu votre prochaine cible.")
                    end)
                end
            end
        end)
    end
end

function EVENT:End()
    if eventRun then
        eventRun = false
        net.Start("FrenchRandomatEnd")
        net.Broadcast()
    end
end

Randomat:register(EVENT)