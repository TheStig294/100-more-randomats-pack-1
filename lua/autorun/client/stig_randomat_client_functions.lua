Randomat = Randomat or {}
-- Disabling fg addon's chat message to clear up chat box for randomat alerts (if installed)
RunConsoleCommand("ttt_fgaddons_textmessage", "0")

-- Just to catch any poorly written randomat packs that call the register function on the client somehow
function Randomat:register(tbl)
end

-- Getting the print names of all weapons and equipment
net.Receive("RandomatGetEquipmentPrintNames", function()
    for _, SWEP in ipairs(weapons.GetList()) do
        if SWEP.PrintName then
            net.Start("RandomatReceiveEquipmentPrintName")
            net.WriteString(SWEP.ClassName)
            net.WriteString(LANG.TryTranslation(SWEP.PrintName))
            net.SendToServer()
        end
    end

    for role, equTable in pairs(EquipmentItems) do
        for _, equ in ipairs(equTable) do
            net.Start("RandomatReceiveEquipmentPrintName")
            net.WriteString(tostring(equ.id))
            local name = LANG.TryTranslation(equ.name)
            net.WriteString(name)
            net.SendToServer()
        end
    end
end)

local nextZoneX = nil
local nextZoneY = nil
local nextZoneRadius = nil
local zoneX = nil
local zoneY = nil
local zoneRadius = nil

net.Receive("RandomatStormBegin", function()
    nextZoneX = nil
    nextZoneY = nil
    nextZoneRadius = nil
    zoneX = nil
    zoneY = nil
    zoneRadius = nil
    local stormColor = Color(180, 23, 253, 60)

    local stormColorModifyTable = {
        ["$pp_colour_addr"] = 180 / 255 * 0.2,
        ["$pp_colour_addg"] = 23 / 255 * 0.2,
        ["$pp_colour_addb"] = 253 / 255 * 0.2,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    }

    local stormMaterial = Material("vgui/ttt/battleroyale/storm.png", "nocull")

    hook.Add("PostDrawTranslucentRenderables", "RandomatStormDrawZone", function(depth, skybox)
        if not zoneRadius then return end
        local client = LocalPlayer()
        if not IsValid(client) then return end
        local count = math.Round(zoneRadius / 30)
        local segmentWidth = 2 * zoneRadius * math.tan(math.pi / count)
        render.SetMaterial(stormMaterial)

        for i = 1, count do
            local segmentNormal = Vector(math.sin(math.pi * 2 * (i / count)), math.cos(math.pi * 2 * (i / count)), 0)
            render.DrawQuadEasy(Vector(zoneX, zoneY, client:GetPos().z) - (segmentNormal * zoneRadius), segmentNormal, segmentWidth, 10000, stormColor)
        end
    end)

    hook.Add("RenderScreenspaceEffects", "RandomatStormZoneOverlay", function()
        if not zoneRadius then return end
        local client = LocalPlayer()
        if not IsPlayer(client) then return end
        if not client:Alive() then return end
        local playerPos = client:GetPos()

        if math.sqrt((playerPos.x - zoneX) ^ 2 + (playerPos.y - zoneY) ^ 2) > zoneRadius or zoneRadius < 5 then
            DrawColorModify(stormColorModifyTable)
        end
    end)
end)

net.Receive("RandomatStormZone", function()
    nextZoneX = net.ReadFloat()
    nextZoneY = net.ReadFloat()
    nextZoneRadius = net.ReadFloat()

    if zoneX == nil then
        zoneX = nextZoneX
        zoneY = nextZoneY
        zoneRadius = nextZoneRadius * 2
    end
end)

net.Receive("RandomatStormShrinkZone", function()
    local moveTime = net.ReadFloat()
    local xIncrement = (nextZoneX - zoneX) / (moveTime * 10)
    local yIncrement = (nextZoneY - zoneY) / (moveTime * 10)
    local radiusIncrement = (nextZoneRadius - zoneRadius) / (moveTime * 10)

    timer.Create("RandomatZoneShrinkTimer", 0.1, moveTime * 10, function()
        if zoneX then
            zoneX = zoneX + xIncrement
        end

        if zoneY then
            zoneY = zoneY + yIncrement
        end

        if zoneRadius then
            zoneRadius = zoneRadius + radiusIncrement
        end
    end)
end)

net.Receive("RandomatStormEnd", function()
    hook.Remove("PostDrawTranslucentRenderables", "RandomatStormDrawZone")
    hook.Remove("RenderScreenspaceEffects", "RandomatStormZoneOverlay")
    timer.Remove("RandomatZoneShrinkTimer")
    nextZoneX = nil
    nextZoneY = nil
    nextZoneRadius = nil
    zoneX = nil
    zoneY = nil
    zoneRadius = nil
end)