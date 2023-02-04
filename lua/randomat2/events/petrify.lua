local EVENT = {}
EVENT.Title = "Petrify!"
EVENT.Description = "Turns players into a stone like figure, playing a quite annoying sound when they move."
EVENT.id = "petrify"

EVENT.Categories = {"fun", "moderateimpact"}

function EVENT:Begin()
    -- Petrify all players
    for i, ply in pairs(self:GetAlivePlayers()) do
        Randomat:ForceSetPlayermodel(ply, "models/player.mdl")
        ply.soundPlaying = false

        if Randomat:IsBodyDependentRole(ply) then
            self:StripRoleWeapons(ply)
            Randomat:SetToBasicRole(ply)
        end
    end

    SendFullStateUpdate()

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

    -- Sets someone's playermodel again when respawning
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            Randomat:ForceSetPlayermodel(ply, "models/player.mdl")
            ply.soundPlaying = false
        end)
    end)
end

function EVENT:End()
    -- Stop Sound
    for i, ply in ipairs(self:GetPlayers()) do
        ply:StopSound("physics\\concrete\\concrete_scrape_smooth_loop1.wav")
    end

    Randomat:ForceResetAllPlayermodels()
end

-- Checking if someone is a body dependent role and if it isn't at the start of the round, prevent the event from running
function EVENT:Condition()
    local bodyDependentRoleExists = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsBodyDependentRole(ply) then
            bodyDependentRoleExists = true
            break
        end
    end

    return Randomat:GetRoundCompletePercent() < 5 or not bodyDependentRoleExists
end

Randomat:register(EVENT)