local function PlayNiceSound()
    for i = 1, 2 do
        surface.PlaySound("nice/nice.mp3")
    end
end

local hitMarkerSound

net.Receive("RandomatNiceBegin", function()
    PlayNiceSound()
    hitMarkerSound = GetConVar("hm_hitsound"):GetBool()
    GetConVar("hm_hitsound"):SetBool(false)

    hook.Add("ScalePlayerDamage", "RandomatNiceSound", function(ply, hitgroup, dmg)
        local attacker = dmg:GetAttacker()

        if IsPlayer(attacker) and attacker == LocalPlayer() then
            PlayNiceSound()
        end
    end)
end)

net.Receive("RandomatNiceEnd", function()
    if hitMarkerSound then
        RunConsoleCommand("hm_hitsound", "1")
    end

    hook.Remove("ScalePlayerDamage", "RandomatNiceSound")
end)