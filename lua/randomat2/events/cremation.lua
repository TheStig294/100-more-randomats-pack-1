local EVENT = {}
EVENT.Title = "Cremation"
EVENT.Description = "Bodies burn after a player dies."
EVENT.id = "cremation"

local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

function EVENT:Begin()
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        return timer.Simple(2, function()
            corpse = findcorpse(ply)
            corpse:Ignite(20, 10)

            timer.Simple(15, function()
                corpse = findcorpse(ply)

                if IsValid(corpse) then
                    if corpse:IsOnFire() then
                        corpse:Remove()
                    end
                end
            end)
        end)
    end)
end

Randomat:register(EVENT)