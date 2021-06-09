local EVENT = {}
EVENT.Title = ""
EVENT.id = "yogsmurder"
EVENT.AltTitle = "Murder (Yogscast intro)"
util.AddNetworkString("YogsMurderRandomat")
util.AddNetworkString("YogsMurderRandomatEnd")
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:Begin()
    -- Trigger the murder randomat
    Randomat:SilentTriggerEvent("murder", self.owner)

    -- After 1 second, start the special popup and sound for all players
    timer.Simple(1, function()
        net.Start("YogsMurderRandomat")
        net.Broadcast()

        for i, ply in pairs(self:GetPlayers()) do
            ply:EmitSound(Sound("yogsmurder/murder.wav"))
        end
    end)

    -- After 5 seconds, remove the popup
    timer.Simple(5, function()
        net.Start("YogsMurderRandomatEnd")
        net.Broadcast()

        -- And give a hint to all players on what to do during the murder randomat
        for i, ply in pairs(self:GetPlayers()) do
            ply:ChatPrint("Gather guns for a revolver! \nAll traitors have knives...")
        end
    end)
end

-- Do not trigger if the murder randomat doesn't exist or isn't turned on
function EVENT:Condition()
    if Randomat:CanEventRun("murder") then return true end

    return false
end

Randomat:register(EVENT)

-- If this randomat is on, but the murder randomat isn't, turn the murder randomat on
hook.Add("TTTPrepareRound", "YogsMurderRandomatConvarCheck", function()
    if ConVarExists("ttt_randomat_murder") and GetConVar("ttt_randomat_yogsmurder"):GetBool() then
        GetConVar("ttt_randomat_murder"):SetBool(true)
    end
end)