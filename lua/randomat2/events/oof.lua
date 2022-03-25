local EVENT = {}
EVENT.Title = "Oof"
EVENT.Description = "Everyone hears an 'Oof' sound after someone takes damage"
EVENT.id = "oof"

EVENT.Categories = {"fun", "smallimpact"}

function EVENT:Begin()
    self:AddHook("PostEntityTakeDamage", function(ent, dmginfo, took)
        if IsPlayer(ent) and took then
            timer.Create("OofRandomatSoundCooldown", 0.1, 1, function()
                BroadcastLua("surface.PlaySound(\"oof/oof.mp3\")")
            end)
        end
    end)
end

Randomat:register(EVENT)