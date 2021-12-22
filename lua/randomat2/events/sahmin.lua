local EVENT = {}
EVENT.Title = "Sahmin"
EVENT.Description = "Gun sounds replaced with 'Sahmin'"
EVENT.id = "sahmin"
-- Going to need to mute regular shooting sounds on the client
util.AddNetworkString("TriggerSahmin")
util.AddNetworkString("EndSahmin")
-- Unlike the old 'sosig' randomat, this one plays one of many sounds
-- local sahmin_sounds = {Sound("weapons/sahmin1.mp3"), Sound("weapons/sahmin2.mp3"), Sound("weapons/sahmin3.mp3"), Sound("weapons/sahmin4.mp3"), Sound("weapons/sahmin5.mp3")}
-- local sahmin_index = 1
local sahmin_sound = Sound("weapons/sahmin1.mp3")

function EVENT:Begin()
    -- timer.Create("RandomatSahminSoundServer", 1, 0, function()
    --     sahmin_index = util.SharedRandom("RandomatSahminSound", 1, #sahmin_sounds, CurTime())
    -- end)
    net.Start("TriggerSahmin")
    net.Broadcast()

    for _, ply in ipairs(player.GetAll()) do
        for _, wep in ipairs(ply:GetWeapons()) do
            Randomat:OverrideWeaponSound(wep, sahmin_sound)
        end
    end

    self:AddHook("WeaponEquip", function(wep, ply)
        timer.Create("SahminDelay", 0.1, 1, function()
            net.Start("TriggerSahmin")
            net.Send(ply)
            Randomat:OverrideWeaponSound(wep, sahmin_sound)
        end)
    end)

    self:AddHook("EntityEmitSound", function(data) return Randomat:OverrideWeaponSoundData(data, sahmin_sound) end)
end

function EVENT:End()
    net.Start("EndSahmin")
    net.Broadcast()
    timer.Remove("SahminDelay")
    timer.Remove("RandomatSahminSoundServer")

    for _, ply in ipairs(player.GetAll()) do
        for _, wep in ipairs(ply:GetWeapons()) do
            Randomat:RestoreWeaponSound(wep)
        end
    end
end

Randomat:register(EVENT)