local client = LocalPlayer()

net.Receive("DogRoundRandomatBegin", function()
    local fogdist = net.ReadFloat()
    local additionDist = 1000000
    surface.PlaySound("doground/doground_begin.mp3")

    -- Draws fog in on players the player's view distance
    hook.Add("SetupWorldFog", "DogRoundRandomatFog", function()
        render.FogMode(MATERIAL_FOG_LINEAR)
        render.FogColor(255, 255, 255)
        render.FogMaxDensity(1)
        render.FogStart(300 * fogdist + additionDist)
        render.FogEnd(600 * fogdist + additionDist)

        return true
    end)

    -- If a map has a 3D skybox, apply a fog effect to that too
    hook.Add("SetupSkyboxFog", "DogRoundRandomatFog", function(scale)
        render.FogMode(MATERIAL_FOG_LINEAR)
        render.FogColor(255, 255, 255)
        render.FogMaxDensity(1)
        render.FogStart(300 * fogdist * scale + additionDist)
        render.FogEnd(600 * fogdist * scale + additionDist)

        return true
    end)

    timer.Create("DogRoundRandomatDrawInFog", 0.01, 420, function()
        additionDist = timer.RepsLeft("DogRoundRandomatDrawInFog") * 2 + 1
    end)
end)

net.Receive("DogRoundRandomatSpawnZombie", function()
    surface.PlaySound("doground/spawn.mp3")
end)

net.Receive("DogRoundRandomatEnd", function()
    hook.Remove("SetupWorldFog", "DogRoundRandomatFog")
    hook.Remove("SetupSkyboxFog", "DogRoundRandomatFog")
end)