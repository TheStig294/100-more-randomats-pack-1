local pingPositions = {}
local pingEntities = {}

net.Receive("PingRandomatBegin", function()
    local spriteMaterial = Material("VGUI/ttt/ping_randomat")
    local color = Color(0, 0, 0, 150)

    hook.Add("HUDPaint", "PingRandomatDrawSprites", function()
        cam.Start3D()
        render.SetMaterial(spriteMaterial)

        for _, pos in ipairs(pingPositions) do
            render.DrawSprite(pos, 16, 16, color)
        end

        cam.End3D()
    end)

    hook.Add("PreDrawHalos", "PingRandomatHalos", function()
        halo.Add(pingEntities, Color(0, 255, 0), 0, 0, 1, true, true)
    end)
end)

net.Receive("PingRandomatPressedF", function()
    local pos = net.ReadVector()
    local ent = net.ReadEntity()
    surface.PlaySound("ping/ping.mp3")

    if IsValid(ent) and ent ~= game.GetWorld() then
        table.insert(pingEntities, ent)

        timer.Simple(10, function()
            table.RemoveByValue(pingEntities, ent)
        end)
    else
        table.insert(pingPositions, pos)

        timer.Simple(10, function()
            table.RemoveByValue(pingPositions, pos)
        end)
    end
end)

net.Receive("PingRandomatEnd", function()
    hook.Remove("HUDPaint", "PingRandomatDrawSprites")
    hook.Remove("PreDrawHalos", "PingRandomatHalos")
    table.Empty(pingPositions)
    table.Empty(pingEntities)
end)