local additionalFogDist = 1000000
local fogDensity = 0.01

net.Receive("DogRoundRandomatBegin", function()
    local fogdist = net.ReadFloat()
    additionalFogDist = 1000000
    fogDensity = 0.001
    surface.PlaySound("doground/doground_begin.mp3")

    -- Draws fog in on players the player's view distance
    hook.Add("SetupWorldFog", "DogRoundRandomatFog", function()
        render.FogMode(MATERIAL_FOG_LINEAR)
        render.FogColor(255, 255, 255)
        render.FogMaxDensity(fogDensity)
        render.FogStart(300 * fogdist + additionalFogDist)
        render.FogEnd(600 * fogdist + additionalFogDist)

        return true
    end)

    -- If a map has a 3D skybox, apply a fog effect to that too
    hook.Add("SetupSkyboxFog", "DogRoundRandomatSkyboxFog", function(scale)
        render.FogMode(MATERIAL_FOG_LINEAR)
        render.FogColor(255, 255, 255)
        render.FogMaxDensity(fogDensity)
        render.FogStart(300 * fogdist * scale + additionalFogDist)
        render.FogEnd(600 * fogdist * scale + additionalFogDist)

        return true
    end)

    local Mat = Material("dev/graygrid")

    hook.Add("PostDraw2DSkyBox", "DogRoundRandomat2DSkyboxFog", function()
        render.OverrideDepthEnable(true, false) -- ignore Z to prevent drawing over 3D skybox
        -- Start 3D cam centered at the origin
        cam.Start3D(Vector(0, 0, 0), EyeAngles())
        render.SetMaterial(Mat)
        render.DrawQuadEasy(Vector(1, 0, 0) * 200, Vector(-1, 0, 0), 64, 64, Color(255, 255, 255), 0)
        cam.End3D()
        render.OverrideDepthEnable(false, false)
    end)

    timer.Create("DogRoundRandomatDrawInFog", 0.01, 420, function()
        additionalFogDist = timer.RepsLeft("DogRoundRandomatDrawInFog") * 2 + 1
        fogDensity = fogDensity + 0.003
    end)
end)

net.Receive("DogRoundRandomatRemoveFog", function()
    timer.Create("DogRoundRandomatDrawOutFog", 0.01, 420, function()
        additionalFogDist = (420 - timer.RepsLeft("DogRoundRandomatDrawOutFog")) * 2 + 1
        fogDensity = fogDensity - 0.003

        if timer.RepsLeft("DogRoundRandomatDrawOutFog") == 0 then
            hook.Remove("SetupWorldFog", "DogRoundRandomatFog")
            hook.Remove("SetupSkyboxFog", "DogRoundRandomatSkyboxFog")
            hook.Remove("PostDraw2DSkyBox", "DogRoundRandomat2DSkyboxFog")
        end
    end)
end)

net.Receive("DogRoundRandomatEnd", function()
    hook.Remove("SetupWorldFog", "DogRoundRandomatFog")
    hook.Remove("SetupSkyboxFog", "DogRoundRandomatSkyboxFog")
    hook.Remove("PostDraw2DSkyBox", "DogRoundRandomat2DSkyboxFog")
end)