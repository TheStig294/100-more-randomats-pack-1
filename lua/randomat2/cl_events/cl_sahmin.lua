-- local sahmin_sounds = {Sound("weapons/sahmin1.mp3"), Sound("weapons/sahmin2.mp3"), Sound("weapons/sahmin3.mp3"), Sound("weapons/sahmin4.mp3"), Sound("weapons/sahmin5.mp3")}
-- local sahmin_index = 1
local sahmin_sound = Sound("weapons/sahmin1.mp3")
local hooked = false

net.Receive("TriggerSahmin", function()
    -- timer.Create("RandomatSahminSoundClient", 1, 0, function()
    --     sahmin_index = util.SharedRandom("RandomatSahminSound", 1, #sahmin_sounds, CurTime())
    -- end)
    -- This event can be called multiple times but we only want to add the hook once
    if not hooked then
        hook.Add("EntityEmitSound", "SahminOverrideHook", function(data) return Randomat:OverrideWeaponSoundData(data, sahmin_sound) end)
        hooked = true
    end

    local client = LocalPlayer()
    if not IsValid(client) then return end

    for _, wep in ipairs(client:GetWeapons()) do
        Randomat:OverrideWeaponSound(wep, sahmin_sound)
    end
end)

net.Receive("EndSahmin", function()
    hook.Remove("EntityEmitSound", "SahminOverrideHook")

    if timer.Exists("RandomatSahminSoundClient") then
        timer.Remove("RandomatSahminSoundClient")
    end

    hooked = false
    local client = LocalPlayer()
    if not IsValid(client) then return end

    for _, wep in ipairs(client:GetWeapons()) do
        Randomat:RestoreWeaponSound(wep)
    end
end)