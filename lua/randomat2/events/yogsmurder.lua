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
            ply:EmitSound(Sound("yogsmurder/murder.mp3"))
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

function EVENT:Condition()
    -- Only triggers if the 'Murder' randomat can
    return Randomat.Events["murder"] ~= nil and Randomat.Events["murder"]:Condition()
end

Randomat:register(EVENT)