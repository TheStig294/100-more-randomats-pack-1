local EVENT = {}
EVENT.Title = "Stop Ghosting!"
EVENT.Description = "T-Posing ghosts follow spectators"
EVENT.id = "ghosting"

EVENT.Categories = {"spectator", "fun", "biased_innocent", "biased", "moderateimpact"}

CreateConVar("randomat_ghosting_stay_upright", 0, FCVAR_NONE, "Whether ghosts should stay upright when looking up/down", 0, 1)
local ghostents = {}
local eventActive = false

local function SpawnGhost(ply)
    if not eventActive then return end
    -- Create the ghost entity using the player's model
    ghostents[ply:Nick()] = ents.Create("npc_kleiner")
    local ghostent = ghostents[ply:Nick()]
    ghostent:SetModel(ply:GetModel())
    ghostent:SetSkin(ply:GetSkin())

    for _, value in pairs(ply:GetBodyGroups()) do
        ghostent:SetBodygroup(value.id, ply:GetBodygroup(value.id))
    end

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
end

function EVENT:Begin()
    eventActive = true

    for _, ply in ipairs(player.GetAll()) do
        if ply:IsSpec() then
            SpawnGhost(ply)
        end
    end

    self:AddHook("PostPlayerDeath", function(ply)
        Randomat:SpectatorRandomatAlert(ply, EVENT)

        -- After the player has finished spectating, spawn their ghost
        timer.Simple(3, function()
            SpawnGhost(ply)
        end)
    end)

    -- Continually, for every player, 
    self:AddHook("Think", function()
        local plys = player.GetAll()

        for i = 1, #plys do
            local ply = plys[i]

            -- That is alive, remove their ghost
            if not ply:IsSpec() then
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
                local pos = ply:GetPos()
                ghostent:SetPos(pos)

                if GetConVar("randomat_ghosting_stay_upright"):GetBool() then
                    ghostent:SetAngles(ply:GetAngles())
                else
                    ghostent:SetAngles(ply:EyeAngles())
                end
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
    eventActive = false
    hook.Remove("Think", "ghostRandomatUpdate")

    for i, ply in pairs(player.GetAll()) do
        ply:SetNWBool("IsSpooky", false)
    end

    for _, ent in pairs(ghostents) do
        SafeRemoveEntity(ent)
    end

    table.Empty(ghostents)
end

function EVENT:GetConVars()
    local checkboxes = {}

    for _, v in pairs({"stay_upright"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checkboxes, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return {}, checkboxes
end

Randomat:register(EVENT)