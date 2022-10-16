local function GetDescription(copiedPlayer, copycat)
    local desc

    if IsValid(copiedPlayer) and IsValid(copycat) then
        desc = copycat:Nick() .. " is copying " .. copiedPlayer:Nick() .. "'s model, "

        if CR_VERSION then
            desc = desc .. "name, "
        end

        desc = desc .. "role, health and inventory!"
    else
        desc = "Someone copies someone else's player model, "

        if CR_VERSION then
            desc = desc .. "name, "
        end

        desc = desc .. "role, health and inventory"
    end

    return desc
end

local EVENT = {}
EVENT.Title = "Copycat!"
EVENT.Description = GetDescription()
EVENT.id = "copycat"

EVENT.Categories = {"rolechange", "item", "moderateimpact"}

util.AddNetworkString("CopycatRandomatBegin")
util.AddNetworkString("CopycatRandomatEnd")

function EVENT:Begin()
    local alivePlayers = self:GetAlivePlayers(true)
    local copiedPlayer = alivePlayers[1]
    local copycat = alivePlayers[2]
    self.Description = GetDescription(copiedPlayer, copycat)
    -- Name
    net.Start("CopycatRandomatBegin")
    net.WriteEntity(copiedPlayer)
    net.WriteEntity(copycat)
    net.Broadcast()
    -- Model
    local modelData = GetPlayerModelData(copiedPlayer)
    ForceSetPlayermodel(copycat, modelData)

    self:AddHook("PlayerSpawn", function(ply)
        if ply ~= copycat then return end

        timer.Simple(1, function()
            ForceSetPlayermodel(ply, modelData)
        end)
    end)

    -- Role
    Randomat:SetRole(copycat, copiedPlayer:GetRole())
    SendFullStateUpdate()
    -- Health
    copycat:SetHealth(copiedPlayer:Health())
    copycat:SetMaxHealth(copiedPlayer:GetMaxHealth())
    -- Inventory
    local copycatWeps
    local copiedWeps

    self:AddHook("PlayerPostThink", function(ply)
        if not IsValid(copycat) or not IsValid(copiedPlayer) or ply ~= copycat or not copycat:Alive() or copycat:IsSpec() then return end
        copycatWeps = copycat:GetWeapons()
        copiedWeps = copiedPlayer:GetWeapons()

        for _, heldWep in ipairs(copycatWeps) do
            heldWep.AllowDrop = false
            local found = false

            for _, wep in ipairs(copiedWeps) do
                if wep:GetClass() == heldWep:GetClass() then
                    found = true
                    break
                end
            end

            if not found then
                heldWep:Remove()
            end
        end

        -- The copycat cannot drop the weapons they are copying from the copied player
        for _, wep in ipairs(copiedWeps) do
            local givenWep = copycat:Give(wep:GetClass())

            if givenWep then
                givenWep.AllowDrop = false
            end
        end
    end)
end

function EVENT:End()
    -- Reset description for stuff like the randomat admin menu or the Randoman
    self.Description = GetDescription()
    net.Start("CopycatRandomatEnd")
    net.Broadcast()
end

-- This event uses custom roles hooks to work
function EVENT:Condition()
    return #self:GetAlivePlayers() > 1
end

Randomat:register(EVENT)