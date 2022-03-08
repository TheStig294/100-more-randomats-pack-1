local EVENT = {}
EVENT.Title = "Stop Ghosting!"
EVENT.Description = "T-Posing ghosts follow spectators"
EVENT.id = "ghosting"

EVENT.Categories = {"spectator", "biased_innocent", "biased", "moderateimpact"}

function EVENT:Begin()
    local ghostents = {}

    self:AddHook("PostPlayerDeath", function(ply)
        -- After the player has finished spectating,
        timer.Simple(3, function()
            -- Create the ghost entity using the player's model
            ghostents[ply:Nick()] = ents.Create("npc_kleiner")
            local ghostent = ghostents[ply:Nick()]
            ghostent:SetModel(ply:GetModel())
            -- Spawn it on the player
            ghostent:SetPos(ply:GetPos())
            ghostent:Spawn()
            -- Make it non-solid
            ghostent:SetNotSolid(true)
            -- Make it ghostly
            ghostent:SetColor(Color(245, 245, 245, 100))
            ghostent:SetRenderMode(RENDERMODE_GLOW)
            -- Make it invincible
            ghostent:SetNWBool("IsSpookyInv", true)
            ply:SetNWBool("IsSpooky", true)
        end)
    end)

    -- Continually, for every player, 
    self:AddHook("Think", function()
        local plys = player.GetAll()

        for i = 1, #plys do
            local ply = plys[i]

            -- That is alive, remove their ghost
            if ply:Alive() or not ply:IsSpec() then
                if IsValid(ghostents[ply:Nick()]) then
                    ghostent = ghostents[ply:Nick()]
                    ghostent:Remove()
                end

                continue
            end

            -- That doesn't have the spooky tag, ignore
            if not ply:GetNWBool("IsSpooky") then continue end
            -- Else, get their ghost entity
            ghostent = ghostents[ply:Nick()]

            -- Check it's valid and update the ghost's position
            if IsValid(ghostent) then
                ghostent:SetPos(ply:GetPos())
                -- ghostent:SetAngles(ply:GetAngles())
                ghostent:SetAngles(ply:EyeAngles())
            end
        end
    end)

    self:AddHook("PlayerDisconnected", function(ply)
        SafeRemoveEntity(ghostents[ply:Nick()])
    end)

    -- Ghosts don't take damage
    self:AddHook("EntityTakeDamage", function(ent, dmginfo)
        if ent:GetNWBool("IsSpookyInv") then return true end
    end)
end

-- Remove the ghost position update hook and remove the spooky tag from all players,
-- which signifies the player has a ghost spawned on them
function EVENT:End()
    hook.Remove("Think", "ghostRandomatUpdate")

    for i, ply in pairs(player.GetAll()) do
        ply:SetNWBool("IsSpooky", false)
    end
end

Randomat:register(EVENT)