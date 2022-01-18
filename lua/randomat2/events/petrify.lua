local EVENT = {}
EVENT.Title = "Petrify!"
EVENT.Description = "Turns players into a stone like figure, playing a quite annoying sound when they move."
EVENT.id = "petrify"

-- Turn player to stone
local function petrify(ply)
    if IsPlayer(ply) and ply:Alive() then
        FindMetaTable("Entity").SetModel(ply, "models/player.mdl")
    end
end

function EVENT:Begin()
    self:AddHook("PlayerSpawn", function(ply)
        -- Petrify on spawn
        if ply then
            timer.Simple(0.5, petrify, ply)
        end
    end)

    -- Petrify all players
    for i, ply in pairs(self:GetPlayers()) do
        petrify(ply)
        ply.soundPlaying = false
    end

    -- Player sound when moving
    self:AddHook("Move", function(ply, mv)
        if ply and ply:Alive() then
            if mv:GetVelocity():Length() > 10 and not ply.soundPlaying and ply:IsOnGround() then
                ply:EmitSound("physics\\concrete\\concrete_scrape_smooth_loop1.wav", 30)
                ply.soundPlaying = true
            elseif (mv:GetVelocity():Length() < 10 or not ply:IsOnGround()) and ply.soundPlaying then
                ply:StopSound("physics\\concrete\\concrete_scrape_smooth_loop1.wav")
                ply.soundPlaying = false
            end
        end
    end)

    -- Stop sound on death
    self:AddHook("DoPlayerDeath", function(ply)
        if ply.soundPlaying then
            ply:StopSound("physics\\concrete\\concrete_scrape_smooth_loop1.wav")
        end
    end)
end

function EVENT:End()
    -- Stop Sound
    for i, ply in ipairs(self:GetPlayers()) do
        ply:StopSound("physics\\concrete\\concrete_scrape_smooth_loop1.wav")
    end
end

Randomat:register(EVENT)