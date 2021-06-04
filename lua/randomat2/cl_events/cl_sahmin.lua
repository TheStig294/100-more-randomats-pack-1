--Replaces all gun sounds with silence (plays a silent sound file)
--In the server-side of this randomat, a hook adds the 'sahmin' sound
--This new method of replacing the gun sound allows it to play for every bullet shot
--Rather than just the first bullet shot after the mouse is held down
local sahmin_sound = "weapons/silence.wav"
local hooked = false

local function FixWeapon(wep)
    if not IsValid(wep) or not wep.Primary then return end
    wep.Primary.OriginalSound = wep.Primary.Sound
    wep.Primary.Sound = sahmin_sound
end

net.Receive("TriggerSahmin", function()
    for _, wep in pairs(LocalPlayer():GetWeapons()) do
        FixWeapon(wep)
    end

    -- This even can be called multiple times but we only want to add the hook once
    -- [Doesn't actually matter now since we're only adding silence, adding more silence won't make anything louder ;)]
    if hooked then return end

    hook.Add("EntityEmitSound", "SahminOverrideHook", function(data)
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

    hooked = true
end)

net.Receive("EndSahmin", function()
    for _, wep in pairs(LocalPlayer():GetWeapons()) do
        if wep.Primary and wep.Primary.OriginalSound then
            wep.Primary.Sound = wep.Primary.OriginalSound
        end
    end

    hook.Remove("EntityEmitSound", "SahminOverrideHook")
    hooked = false
end)