local EVENT = {}
EVENT.Title = "Triggered"
EVENT.Description = "After someone dies, everyone gets 'triggered' for a split second"
EVENT.id = "triggered"
EVENT.IsEnabled = false

EVENT.Categories = {"biased_innocent", "biased", "largeimpact"}

util.AddNetworkString("TriggeredRandomatSound")

function EVENT:Begin()
    self:AddHook("PostPlayerDeath", function(deadPly)
        for _, ply in ipairs(player.GetAll()) do
            -- Plays a sound
            net.Start("TriggeredRandomatSound")
            net.Send(ply)
            -- Shakes the screen and applies a red colour filter for the length of the sound
            local soundEffectLength = 1
            util.ScreenShake(deadPly:GetPos(), 30, 100, soundEffectLength, 5000)
            ply:ScreenFade(SCREENFADE.STAYOUT, Color(255, 0, 0, 50), 0, soundEffectLength)

            timer.Simple(soundEffectLength, function()
                ply:ScreenFade(SCREENFADE.PURGE, Color(255, 0, 0, 50), 0, soundEffectLength)
            end)
        end
    end)
end

Randomat:register(EVENT)