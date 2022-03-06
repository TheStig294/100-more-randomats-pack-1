local EVENT = {}
EVENT.Title = "Oof"
EVENT.Description = "After taking damage, you make a Roblox 'oof' sound"
EVENT.id = "oof"

EVENT.Categories = {"fun", "smallimpact"}

function EVENT:Begin()
    self:AddHook("PostEntityTakeDamage", function(ent, dmginfo, took)
        if IsPlayer(ent) and took then
            timer.Create("OofRandomatSoundCooldown", 0.1, 1, function()
                ent:EmitSound("oof/oof.mp3", 100, 100, 1)
            end)
        end
    end)
end

Randomat:register(EVENT)