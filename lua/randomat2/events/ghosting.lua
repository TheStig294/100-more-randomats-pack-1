local EVENT = {}
EVENT.Title = "Stop Ghosting!"
EVENT.Description = "T-Posing ghosts follow spectators"
EVENT.id = "ghosting"

function EVENT:Begin()
    local ghostents = {}

    hook.Add("PostPlayerDeath", "HauntingRandomat", function(ply)
        timer.Simple(3, function()
            ghostents[ply:Nick()] = ents.Create("npc_kleiner")
            local ghostent = ghostents[ply:Nick()]
            ghostent:SetModel(ply:GetModel())
            ghostent:SetPos(ply:GetPos())
            ghostent:Spawn()
            ghostent:SetNotSolid(true)
            ghostent:SetColor(Color(245, 245, 245, 100))
            ghostent:SetRenderMode(RENDERMODE_GLOW)
            ghostent:SetNWBool("IsSpookyInv", true)
            ply:SetNWBool("IsSpooky", true)

            hook.Add("Think", "ghostRandomatUpdate", function()
                local plys = player.GetAll()

                for i = 1, #plys do
                    local ply = plys[i]

                    if ply:Alive() or not ply:IsSpec() then
                        if IsValid(ghostents[ply:Nick()]) then
                            ghostent = ghostents[ply:Nick()]
                            ghostent:Remove()
                        end

                        continue
                    end

                    if not ply:GetNWBool("IsSpooky") then continue end
                    --local hasUpdated = false
                    --if CurTime() >= tick_delay and not hasUpdated then
                    ghostent = ghostents[ply:Nick()]

                    if IsValid(ghostent) then
                        ghostent:SetPos(ply:GetPos())
                        --tick_delay = CurTime() + 5
                        --hasUpdated = true
                        --end
                    end
                end
            end)
        end)
    end)

    local tick_delay = CurTime() + 3

    hook.Add("EntityTakeDamage", "IsSpookyInvincible", function(ent, dmginfo)
        if ent:GetNWBool("IsSpookyInv") then return true end
    end)
end

function EVENT:End()
    hook.Remove("Think", "ghostRandomatUpdate")
    hook.Remove("PostPlayerDeath", "HauntingRandomat")
    hook.Remove("EntityTakeDamage", "IsSpookyInvincible")
    local plys = player.GetAll()

    for i = 1, #plys do
        plys[i]:SetNWBool("IsSpooky", false)
    end
end

Randomat:register(EVENT)