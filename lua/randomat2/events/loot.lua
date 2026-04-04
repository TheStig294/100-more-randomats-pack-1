local EVENT = {}
EVENT.Title = "Shoot and Loot!"
EVENT.Description = "Killed players drop buyable weapons!"
EVENT.id = "loot"

EVENT.Categories = {"deathtrigger", "entityspawn", "largeimpact"}

CreateConVar("randomat_loot_drop_number", "8", FCVAR_NONE, "Number of weapons dropped", 1, 20)

function EVENT:Begin()
    -- Code taken from the "Loot Goblin" role from Custom Roles for TTT
    local lootTable = {}

    self:AddHook("PlayerDeath", function(victim)
        timer.Create("LootRandomatWeaponDrop", 0.05, GetConVar("randomat_loot_drop_number"):GetInt(), function()
            -- Rebuild the loot table if we run out
            if table.IsEmpty(lootTable) then
                for _, SWEP in RandomPairs(weapons.GetList()) do
                    -- Specifically check AllowDrop for `false` because weapons in `weapons.GetList` don't have the base table
                    -- applied and the base table has AllowDrop defaulting to `true`
                    if not SWEP or SWEP.AutoSpawnable or not SWEP.CanBuy or SWEP.AllowDrop == false then continue end
                    table.insert(lootTable, WEPS.GetClass(SWEP))
                end
            end

            local ragdoll = victim.server_ragdoll or victim:GetRagdollEntity()
            local pos

            if IsValid(ragdoll) then
                pos = ragdoll:GetPos() + Vector(0, 0, 25)
            else
                pos = victim:GetPos() + Vector(0, 0, 25)
            end

            local idx = math.random(#lootTable)
            local wep = lootTable[idx]
            table.remove(lootTable, idx)
            local ent = ents.Create(wep)
            ent:SetPos(pos)
            ent:Spawn()
            local phys = ent:GetPhysicsObject()

            if phys:IsValid() then
                phys:ApplyForceCenter(Vector(math.Rand(-100, 100), math.Rand(-100, 100), 300) * phys:GetMass())
            end
        end)
    end)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"drop_number"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)