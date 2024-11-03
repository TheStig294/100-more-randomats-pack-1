local EVENT = {}
CreateConVar("randomat_michaelrosen_trigger_sound", "1", FCVAR_ARCHIVE, "Play a sound on trigger?", 0, 1)
EVENT.Title = "The Michael Rosen Rap"
EVENT.Description = "Replaces game sounds with Michael Rosen sounds!"
EVENT.id = "michaelrosen"
EVENT.Type = EVENT_TYPE_GUNSOUNDS

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("TriggerMichaelRosen")
util.AddNetworkString("EndMichaelRosen")

local reload_sounds = {"michaelrosen/reload/reload1.mp3", "michaelrosen/reload/reload2.mp3", "michaelrosen/reload/reload3.mp3", "michaelrosen/reload/reload4.mp3"}

local death_sounds = {"michaelrosen/death/death1.mp3", "michaelrosen/death/death2.mp3", "michaelrosen/death/death3.mp3", "michaelrosen/death/death4.mp3", "michaelrosen/death/death5.mp3", "michaelrosen/death/death6.mp3"}

local gunshot_sounds = {"michaelrosen/gunshot/gunshot1.mp3", "michaelrosen/gunshot/gunshot2.mp3", "michaelrosen/gunshot/gunshot3.mp3", "michaelrosen/gunshot/gunshot4.mp3", "michaelrosen/gunshot/gunshot5.mp3", "michaelrosen/gunshot/gunshot6.mp3"}

local door_opening_sounds = {"michaelrosen/door_opening/door_opening1.mp3"}

local door_closing_sounds = {"michaelrosen/door_closing/door_closing1.mp3"}

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

local function DoorIsOpen(door)
    if not IsValid(door) then return false end
    local doorClass = door:GetClass()

    if doorClass == "func_door" or doorClass == "func_door_rotating" then
        return door:GetInternalVariable("m_toggle_state") == 0
    elseif doorClass == "prop_door_rotating" then
        return door:GetInternalVariable("m_eDoorState") ~= 0
    end

    return false
end

function EVENT:Begin()
    -- Choose a random sound to be played on all clients and run the client-side functions
    local triggerSound

    if GetConVar("randomat_michaelrosen_trigger_sound"):GetBool() then
        triggerSound = trigger_sounds[math.random(#trigger_sounds)]
    else
        triggerSound = "nosound"
    end

    net.Start("TriggerMichaelRosen")
    net.WriteString(triggerSound)
    net.Broadcast()

    for _, ply in ipairs(player.GetAll()) do
        for _, wep in ipairs(ply:GetWeapons()) do
            local chosen_sound = gunshot_sounds[math.random(#gunshot_sounds)]
            Randomat:OverrideWeaponSound(wep, chosen_sound)
        end
    end

    self:AddHook("WeaponEquip", function(wep, ply)
        timer.Create("MichaelRosenDelay", 0.1, 1, function()
            net.Start("TriggerMichaelRosen")
            net.Send(ply)
            local chosen_sound = gunshot_sounds[math.random(#gunshot_sounds)]
            Randomat:OverrideWeaponSound(wep, chosen_sound)
        end)
    end)

    self:AddHook("EntityEmitSound", function(data)
        local current_sound = data.SoundName:lower()
        local new_sound = nil

        for pattern, sounds in pairs(sound_mapping) do
            if string.find(current_sound, pattern) then
                new_sound = sounds[math.random(#sounds)]
            end
        end

        if new_sound then
            data.SoundName = new_sound
            -- Door opening/closing

            return true
        elseif current_sound == "doors/default_move.wav" then
            if DoorIsOpen(data.Entity) then
                data.SoundName = door_closing_sounds[math.random(#door_closing_sounds)]
            else
                data.SoundName = door_opening_sounds[math.random(#door_opening_sounds)]
            end

            -- Increase the volume of these so they can be heard
            data.Volume = 2
            data.SoundLevel = 100

            return true
        else
            local chosen_sound = gunshot_sounds[math.random(#gunshot_sounds)]

            return Randomat:OverrideWeaponSoundData(data, chosen_sound)
        end
    end)
end

function EVENT:End()
    net.Start("EndMichaelRosen")
    net.Broadcast()
    timer.Remove("MichaelRosenDelay")

    for _, ply in ipairs(player.GetAll()) do
        for _, wep in ipairs(ply:GetWeapons()) do
            Randomat:RestoreWeaponSound(wep)
        end
    end
end

function EVENT:GetConVars()
    local checks = {}

    for _, v in pairs({"trigger_sound"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return {}, checks
end

Randomat:register(EVENT)