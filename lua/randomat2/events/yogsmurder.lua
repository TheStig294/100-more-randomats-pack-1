local EVENT = {}
EVENT.Title = ""
EVENT.id = "yogsmurder"
EVENT.AltTitle = "Murder (Yogscast intro)"
util.AddNetworkString("YogsMurderRandomat")
util.AddNetworkString("YogsMurderRandomatEnd")

function EVENT:Begin()
    Randomat:SilentTriggerEvent("murder", self.owner)

    timer.Simple(1, function()
        net.Start("YogsMurderRandomat")
        net.Broadcast()

        for i, ply in pairs(player.GetAll()) do
            ply:EmitSound(Sound("yogsmurder/murder.wav"))
        end
    end)

    timer.Simple(5, function()
        net.Start("YogsMurderRandomatEnd")
        net.Broadcast()

        for i, ply in pairs(player.GetAll()) do
            ply:ChatPrint("Gather guns for a revolver! \nAll traitors have knives...")
        end
    end)
end

function EVENT:Condition()
    if not ConVarExists("ttt_randomat_murder") then return false end
    if Randomat:CanEventRun("murder") then return true end

    return false
end

Randomat:register(EVENT)

hook.Add("TTTPrepareRound", "YogsMurderRandomatConvarCheck", function()
    if ConVarExists("ttt_randomat_murder") and GetConVar("ttt_randomat_yogsmurder"):GetBool() then
        GetConVar("ttt_randomat_murder"):SetBool(true)
    end
end)