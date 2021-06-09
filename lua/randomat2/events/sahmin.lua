local EVENT = {}
EVENT.Title = "Sahmin"
EVENT.Description = "Gun sounds replaced with 'Sahmin'"
EVENT.id = "sahmin"
-- Going to need to mute regular shooting sounds on the client
util.AddNetworkString("TriggerSahmin")
util.AddNetworkString("EndSahmin")
-- The new sounds
util.PrecacheSound("weapons/sahmin1.wav")
util.PrecacheSound("weapons/sahmin2.wav")
util.PrecacheSound("weapons/sahmin3.wav")
util.PrecacheSound("weapons/sahmin4.wav")
util.PrecacheSound("weapons/sahmin5.wav")
-- Client-side shooting sounds will be replaced with a silent sound file
util.PrecacheSound("weapons/silence.wav")

-- Unlike the old 'sosig' randomat, this one plays one of many sounds
local sahmin_sound_table = {"weapons/sahmin1.wav", "weapons/sahmin2.wav", "weapons/sahmin3.wav", "weapons/sahmin4.wav", "weapons/sahmin5.wav"}

local sahmin_sound = "weapons/silence.wav"

-- Silences the regular shooting sound from a gun, on the server
local function FixWeapon(wep)
    if not IsValid(wep) or not wep.Primary then return end
    wep.Primary.OriginalSound = wep.Primary.Sound
    wep.Primary.Sound = sahmin_sound
end

function EVENT:Begin()
    -- Mutes regular shooting sounds on the client
    net.Start("TriggerSahmin")
    net.Broadcast()

    -- Mutes regular shooting sounds on the server
    for _, ply in pairs(self:GetPlayers()) do
        for _, wep in pairs(ply:GetWeapons()) do
            FixWeapon(wep)
        end
    end

    -- Do it again if the player obtains a new weapon
    self:AddHook("WeaponEquip", function(wep, ply)
        timer.Create("SahminDelay", 0.1, 1, function()
            net.Start("TriggerSahmin")
            net.Send(ply)
            FixWeapon(wep)
        end)
    end)

    -- Some weapons may still play shooting sounds, such as TFA guns, so performing a different muting method to be sure
    self:AddHook("EntityEmitSound", function(data)
        local owner = data.Entity
        if not IsValid(owner) then return end
        local sound = data.SoundName:lower()
        local weap_start, _ = string.find(sound, "weapons/")
        local fire_start, _ = string.find(sound, "fire")
        local shot_start, _ = string.find(sound, "shot")

        if weap_start and (fire_start or shot_start) then
            data.SoundName = sahmin_sound

            return true
        end
    end)

    -- And finally, play the 'sahmin' sound for every bullet anything shoots
    self:AddHook("EntityFireBullets", function(entity, data)
        -- Play a random sound for every bullet
        local sahmin_sound = sahmin_sound_table[math.random(1, #sahmin_sound_table)]
        entity:EmitSound(sahmin_sound)
    end)
end

function EVENT:End()
    -- Unmute client-side gun sounds
    net.Start("EndSahmin")
    net.Broadcast()
    -- Unmute server-side gun sounds
    timer.Remove("SahminDelay")
end

Randomat:register(EVENT)