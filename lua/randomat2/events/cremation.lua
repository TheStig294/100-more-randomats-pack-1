local EVENT = {}
EVENT.Title = "Cremation"
EVENT.Description = "Bodies burn after a player dies."
EVENT.id = "cremation"

-- Takes any dead player and returns their ragdoll, else returns false
local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

function EVENT:Begin()
    -- After a player dies
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmg)
        -- After 2 seconds
        return timer.Simple(2, function()
            -- Find their ragdoll and ignite it
            corpse = findcorpse(ply)
            corpse:Ignite(20, 10)

            -- After 15 seconds,
            timer.Simple(15, function()
                -- Find their ragdoll
                corpse = findcorpse(ply)

                -- If the round hasn't ended or the ragdoll otherwise hasn't been removed,
                if IsValid(corpse) then
                    -- And the ragdoll hasn't been put out (e.g. placed in water),
                    if corpse:IsOnFire() then
                        -- Remove it
                        corpse:Remove()
                    end
                    -- NOTE: Ragdolls on fire can't be searched, this functionality is from the base TTT gamemode
                    -- (Used for the flare gun)
                end
            end)
        end)
    end)
end

Randomat:register(EVENT)