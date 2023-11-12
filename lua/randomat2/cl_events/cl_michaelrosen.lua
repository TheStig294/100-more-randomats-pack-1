local hooked = false

local reload_sounds = {"michaelrosen/reload/reload1.mp3", "michaelrosen/reload/reload2.mp3", "michaelrosen/reload/reload3.mp3", "michaelrosen/reload/reload4.mp3"}

local death_sounds = {"michaelrosen/death/death1.mp3", "michaelrosen/death/death2.mp3", "michaelrosen/death/death3.mp3", "michaelrosen/death/death4.mp3", "michaelrosen/death/death5.mp3", "michaelrosen/death/death6.mp3"}

local gunshot_sounds = {"michaelrosen/gunshot/gunshot1.mp3", "michaelrosen/gunshot/gunshot2.mp3", "michaelrosen/gunshot/gunshot3.mp3", "michaelrosen/gunshot/gunshot4.mp3", "michaelrosen/gunshot/gunshot5.mp3", "michaelrosen/gunshot/gunshot6.mp3"}

local jump_sounds = {"michaelrosen/jump/jump1.mp3", "michaelrosen/jump/jump2.mp3", "michaelrosen/jump/jump3.mp3"}

local trigger_sounds = {"michaelrosen/trigger/trigger1.mp3", "michaelrosen/trigger/trigger2.mp3", "michaelrosen/trigger/trigger3.mp3", "michaelrosen/trigger/trigger4.mp3", "michaelrosen/trigger/trigger5.mp3", "michaelrosen/trigger/trigger6.mp3"}

local sound_mapping = {
    -- Explosions
    [".*weapons/.*explode.*%..*"] = {"michaelrosen/explosion/explosion1.mp3", "michaelrosen/explosion/explosion2.mp3", "michaelrosen/explosion/explosion3.mp3"},
    -- C4 Beeps
    [".*weapons/.*beep.*%..*"] = {"michaelrosen/beeping/beeping1.mp3", "michaelrosen/beeping/beeping2.mp3", "michaelrosen/beeping/beeping3.mp3", "michaelrosen/beeping/beeping4.mp3", "michaelrosen/beeping/beeping5.mp3", "michaelrosen/beeping/beeping6.mp3"},
    -- Glass breaking
    [".*physics/glass/.*break.*%..*"] = {"michaelrosen/smashing_glass/smashing_glass1.mp3", "michaelrosen/smashing_glass/smashing_glass2.mp3"},
    -- Fall damage (which don't work when converted to MP3 for some reason)
    [".*player/damage*."] = {"michaelrosen/bones_cracking/bones_cracking1.wav"},
    -- Player death
    [".*player/death.*"] = death_sounds,
    [".*vo/npc/male01/pain*."] = death_sounds,
    [".*vo/npc/barney/ba_pain*."] = death_sounds,
    [".*vo/npc/barney/ba_ohshit03.*"] = death_sounds,
    [".*vo/npc/barney/ba_no01.*"] = death_sounds,
    [".*vo/npc/male01/no02.*"] = death_sounds,
    [".*hostage/hpain/hpain.*"] = death_sounds,
    -- Reload
    [".*weapons/.*out%..*"] = reload_sounds,
    [".*weapons/.*in%..*"] = reload_sounds,
    [".*weapons/.*reload.*%..*"] = reload_sounds,
    [".*weapons/.*boltcatch.*%..*"] = reload_sounds,
    [".*weapons/.*insertshell.*%..*"] = reload_sounds,
    [".*weapons/.*selectorswitch.*%..*"] = reload_sounds,
    [".*weapons/.*rattle.*%..*"] = reload_sounds,
    [".*weapons/.*lidopen.*%..*"] = reload_sounds,
    [".*weapons/.*fetchmag.*%..*"] = reload_sounds,
    [".*weapons/.*beltjingle.*%..*"] = reload_sounds,
    [".*weapons/.*beltalign.*%..*"] = reload_sounds,
    [".*weapons/.*lidclose.*%..*"] = reload_sounds,
    [".*weapons/.*magslap.*%..*"] = reload_sounds
}

local eventTriggered = false

net.Receive("TriggerMichaelRosen", function()
    eventTriggered = true
    -- Play a random sound on trigger, after the randomat trigger sound
    local triggerSound = net.ReadString()

    timer.Simple(1, function()
        if triggerSound ~= "nosound" then
            surface.PlaySound(triggerSound)
        end
    end)

    -- This event can be called multiple times but we only want to add the hook once
    if not hooked then
        hook.Add("EntityEmitSound", "MichaelRosenOverrideHook", function(data)
            local current_sound = data.SoundName:lower()
            local new_sound = nil

            for pattern, sounds in pairs(sound_mapping) do
                if string.find(current_sound, pattern) then
                    new_sound = sounds[math.random(#sounds)]
                end
            end

            if new_sound then
                data.SoundName = new_sound

                return true
            else
                local chosen_sound = gunshot_sounds[math.random(#gunshot_sounds)]

                return Randomat:OverrideWeaponSoundData(data, chosen_sound)
            end
        end)

        hooked = true
    end

    local client = LocalPlayer()
    if not IsValid(client) then return end

    for _, wep in ipairs(client:GetWeapons()) do
        local chosen_sound = gunshot_sounds[math.random(#gunshot_sounds)]
        Randomat:OverrideWeaponSound(wep, chosen_sound)
    end
end)

net.Receive("EndMichaelRosen", function()
    hook.Remove("EntityEmitSound", "MichaelRosenOverrideHook")
    hooked = false
    local client = LocalPlayer()
    if not IsValid(client) then return end

    for _, wep in ipairs(client:GetWeapons()) do
        Randomat:RestoreWeaponSound(wep)
    end

    if eventTriggered then
        eventTriggered = false

        timer.Simple(5, function()
            surface.PlaySound("michaelrosen/end.mp3")
        end)
    end
end)