local EVENT = {}
EVENT.Title = "What did WE find in our pockets?"
EVENT.Description = "Gives everyone the same random buyable weapon"
EVENT.id = "pockets"

EVENT.Categories = {"item", "moderateimpact"}

CreateConVar("randomat_pockets_blocklist", "", FCVAR_ARCHIVE, "The comma-separated list of weapon IDs to not give out")

function EVENT:Begin()
    local blocklist = {}

    for blocked_id in string.gmatch(GetConVar("randomat_pockets_blocklist"):GetString(), "([^,]+)") do
        table.insert(blocklist, blocked_id:Trim())
    end

    local players = self:GetAlivePlayers(true)
    local pocketsweptries = 0
    local testingPly = players[1]

    local searchShops = {ROLE_DETECTIVE, ROLE_TRAITOR}

    local item, _, swep_table = Randomat:GetShopEquipment(testingPly, searchShops, blocklist, false, pocketsweptries, function() return pocketsweptries end, function(value)
        pocketsweptries = value
    end)

    timer.Simple(0.1, function()
        for i, ply in ipairs(players) do
            if item then
                ply:Give(item.ClassName)
                Randomat:CallShopHooks(false, item.ClassName, ply)
            elseif swep_table then
                ply:Give(swep_table.ClassName)
                Randomat:CallShopHooks(false, swep_table.ClassName, ply)
            end
        end
    end)
end

function EVENT:GetConVars()
    local textboxes = {}

    for _, v in ipairs({"blocklist"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(textboxes, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return {}, {}, textboxes
end

Randomat:register(EVENT)