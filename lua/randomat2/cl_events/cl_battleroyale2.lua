local nextZoneX = nil
local nextZoneY = nil
local nextZoneR = nil

local zoneX = nil
local zoneY = nil
local zoneR = nil

local zoneEmitter = nil
local zoneNextPart = nil
local zoneDir = nil

local linkEmitter = nil
local linkNextPart = nil
local linkOffset = nil

net.Receive("RandomatBattleroyale2Begin", function()
    local customRolesInstalled = net.ReadBool()
    local playMusic = net.ReadBool()
    local zonesEnabled = net.ReadBool()

    if customRolesInstalled then
        local partners = {}

        timer.Create("BattleRoyale2RandomatGetPartners", 2, 1, function()
            for _, ply in ipairs(player.GetAll()) do
                local partner = ply:GetNWEntity("BattleRoyalePartner")

                if IsValid(partner) then
                    partners[ply] = partner
                end
            end
        end)

        hook.Add("TTTScoringWinTitle", "RandomatBattleRoyale2WinTitle", function(wintype, wintitles, title)
            local winner
            local winner2

            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() and not ply:IsSpec() then
                    winner = ply
                    winner2 = partners[ply]
                    break
                end
            end

            if not winner then return end
            local winString

            if IsValid(winner2) then
                winString = winner:Nick() .. " and " .. winner2:Nick() .. " win!"
            else
                winString = winner:Nick() .. "  wins!"
            end

            LANG.AddToLanguage("english", "win_battleroyale2", string.upper(winString))

            local newTitle = {
                txt = "win_battleroyale2",
                c = ROLE_COLORS[ROLE_INNOCENT],
                params = nil
            }

            return newTitle
        end)
    end

    if playMusic then
        hook.Add("TTTEndRound", "RandomatBattleRoyale2Music", function(result)
            timer.Simple(0.3, function()
                for i = 1, 2 do
                    surface.PlaySound("battleroyale/fortnite_victory_royale.mp3")
                end
            end)
        end)
    end

    hook.Add("PreDrawHalos", "RandomatBattleRoyale2Halos", function()
        local haloEnts = {LocalPlayer():GetNWEntity("BattleRoyalePartner")}

        if not IsValid(haloEnts[1]) then return end
        halo.Add(haloEnts, Color(0, 255, 0), 0, 0, 1, true, true)
    end)

    if zonesEnabled then
        nextZoneX = nil
        nextZoneY = nil
        nextZoneR = nil

        zoneX = nil
        zoneY = nil
        zoneR = nil

        hook.Add("Think", "RandomatBattleRoyaleZone2Particles", function()
            if not zoneR then return end

            local client = LocalPlayer()

            if zoneR > 5 then
                local pos = Vector(zoneX, zoneY, client:GetPos().z)
                if not zoneEmitter then zoneEmitter = ParticleEmitter(pos) end
                if not zoneNextPart then zoneNextPart = CurTime() end
                if not zoneDir then zoneDir = 0 end
                zoneEmitter:SetPos(pos)
                if zoneNextPart < CurTime() then
                    local count = math.Round(zoneR / 30)
                    for _ = 1, count do
                        zoneNextPart = CurTime() + 0.05
                        zoneDir = zoneDir + math.pi / (count / 2)
                        local vec = Vector(math.cos(zoneDir) * zoneR, math.sin(zoneDir) * zoneR, -300)
                        local particle = zoneEmitter:Add("particle/snow.vmt", pos + vec)
                        particle:SetVelocity(Vector(0, 0, 200))
                        particle:SetDieTime(3)
                        particle:SetStartAlpha(255)
                        particle:SetEndAlpha(0)
                        particle:SetStartSize(8)
                        particle:SetEndSize(5)
                        particle:SetRoll(math.Rand(0, 2*math.pi))
                        particle:SetRollDelta(math.Rand(-0.2, 0.2))
                        particle:SetColor(180, 23, 253)
                    end
                    zoneDir = zoneDir + ((2*math.pi) / (10*count))
                end
            elseif zoneEmitter then
                zoneEmitter:Finish()
                zoneEmitter = nil
                zoneNextPart = nil
                zoneDir = nil
            end

            local playerPos = client:GetPos()
            if client:Alive() and math.sqrt((playerPos.x - zoneX)^2 + (playerPos.y - zoneY)^2) > zoneR and zoneR > 5 then
                if not linkEmitter then linkEmitter = ParticleEmitter(playerPos) end
                if not linkNextPart then linkNextPart = CurTime() end
                if not linkOffset then linkOffset = 0 end
                local startPos = playerPos + Vector(0, 0, 30)
                local endPos = Vector(zoneX, zoneY, startPos.z)
                local dir = endPos - startPos
                dir:Normalize()
                endPos:Add(dir * -zoneR)
                dir = dir * 50
                if linkNextPart < CurTime() then
                    local pos = startPos + (dir * linkOffset)
                    while startPos:Distance(pos) <= 3000 and startPos:Distance(pos) <= startPos:Distance(endPos) do
                        linkEmitter:SetPos(pos)
                        linkNextPart = CurTime() + 0.02
                        local particle = linkEmitter:Add("particle/snow.vmt", pos)
                        particle:SetVelocity(Vector(0, 0, 0))
                        particle:SetDieTime(0.25)
                        particle:SetStartAlpha(200)
                        particle:SetEndAlpha(0)
                        particle:SetStartSize(2)
                        particle:SetEndSize(1)
                        particle:SetRoll(math.Rand(0, 2*math.pi))
                        particle:SetRollDelta(0)
                        particle:SetColor(255, 255, 255)
                        pos:Add(dir)
                    end
                    linkOffset = linkOffset + 0.04
                    if linkOffset > 1 then
                        linkOffset = 0
                    end
                end
            elseif linkEmitter then
                linkEmitter:Finish()
                linkEmitter = nil
                linkNextPart = nil
                linkOffset = nil
            end
        end)

        hook.Add("RenderScreenspaceEffects", "RandomatBattleRoyale2ZoneOverlay", function()
            if not zoneR then return end

            local client = LocalPlayer()

            if not IsPlayer(client) then return end
            if not client:Alive() then return end

            local playerPos = client:GetPos()
            if math.sqrt((playerPos.x - zoneX)^2 + (playerPos.y - zoneY)^2) > zoneR or zoneR < 5 then
                DrawColorModify({
                    ["$pp_colour_addr"] = 180/255 * 0.2,
                    ["$pp_colour_addg"] = 23/255 * 0.2,
                    ["$pp_colour_addb"] = 253/255 * 0.2,
                    ["$pp_colour_brightness"] = 0,
                    ["$pp_colour_contrast"] = 1,
                    ["$pp_colour_colour"] = 1,
                    ["$pp_colour_mulr"] = 0,
                    ["$pp_colour_mulg"] = 0,
                    ["$pp_colour_mulb"] = 0
                })
            end
        end)
    end
end)

net.Receive("RandomatBattleroyale2Zone", function()
    nextZoneX = net.ReadFloat()
    nextZoneY = net.ReadFloat()
    nextZoneR = net.ReadFloat()
    if zoneX == nil then
        zoneX = nextZoneX
        zoneY = nextZoneY
        zoneR = nextZoneR * 2
    end
end)

net.Receive("RandomatBattleroyale2ShrinkZone", function()
    local moveTime = net.ReadFloat()
    local xIncrement = (nextZoneX - zoneX) / (moveTime * 10)
    local yIncrement = (nextZoneY - zoneY) / (moveTime * 10)
    local rIncrement = (nextZoneR - zoneR) / (moveTime * 10)
    timer.Create("BattleRoyal2eRandomatZoneShrinkTimer", 0.1, moveTime * 10, function()
        zoneX = zoneX + xIncrement
        zoneY = zoneY + yIncrement
        zoneR = zoneR + rIncrement
    end)
end)

net.Receive("RandomatBattleroyale2End", function()
    hook.Remove("TTTScoringWinTitle", "RandomatBattleRoyale2WinTitle")
    hook.Remove("TTTEndRound", "RandomatBattleRoyale2Music")
    hook.Remove("PreDrawHalos", "RandomatBattleRoyale2Halos")
    hook.Remove("Think", "RandomatBattleRoyale2ZoneParticles")
    hook.Remove("RenderScreenspaceEffects", "RandomatBattleRoyale2ZoneOverlay")
    timer.Remove("BattleRoyale2RandomatZoneShrinkTimer")

    nextZoneX = nil
    nextZoneY = nil
    nextZoneR = nil

    zoneX = nil
    zoneY = nil
    zoneR = nil

    if zoneEmitter then
        zoneEmitter:Finish()
        zoneEmitter = nil
        zoneNextPart = nil
        zoneDir = nil
    end

    if linkEmitter then
        linkEmitter:Finish()
        linkEmitter = nil
        linkNextPart = nil
        linkOffset = nil
    end
end)