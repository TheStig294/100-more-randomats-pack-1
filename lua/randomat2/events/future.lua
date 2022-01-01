local EVENT = {}
EVENT.Title = "Future Proofing"
EVENT.Description = "Buy menu items aren't given until the next round"
EVENT.id = "future"
local futureRandomatEquipment = {}

function EVENT:Begin()
    -- Let the weapon giving hook know the randomat has activated
    local futureRandomat = true

    -- Clear bought equipment table
    for i, ply in ipairs(player.GetAll()) do
        futureRandomatEquipment[ply] = {}
    end

    -- Add bought equipment to the table and remove it from the player
    self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
        if is_item then
            id = math.floor(id)
        end

        if table.HasValue(futureRandomatEquipment[ply], id) then
            ply:PrintMessage(HUD_PRINTCENTER, "You've already bought that!")
        else
            table.insert(futureRandomatEquipment[ply], id)
            ply:SubtractCredits(1)
            ply:PrintMessage(HUD_PRINTCENTER, "You'll get that on the next round")
        end

        return false
    end)

    -- Give everyone's bought equipment at the start of the next round
    hook.Add("TTTBeginRound", "FutureRandomatGiveEquipment", function()
        timer.Simple(0.1, function()
            local weaponKind = 10

            for i, ply in pairs(player.GetAll()) do
                for j, item in ipairs(futureRandomatEquipment[ply]) do
                    local is_item = isnumber(item)

                    if is_item then
                        ply:GiveEquipmentItem(tonumber(item))
                    else
                        -- Increment the weapon's kind by 1 to ensure every player receives all weapons even if some take the same slot (kind) as each other
                        weaponKind = weaponKind + 1
                        ply:Give(item).Kind = weaponKind

                        if item.WasBought then
                            item:WasBought(ply)
                        end
                    end

                    Randomat:CallShopHooks(is_item, item, ply)
                end
            end
        end)

        -- Let removal hook know the weapons have been given
        futureRandomat = false
    end)

    -- At the end of the next round, remove the weapon giving hook
    hook.Add("TTTEndRound", "FutureRandomatStopGiveEquipment", function()
        if futureRandomat == false then
            hook.Remove("TTTBeginRound", "FutureRandomatGiveEquipment")
        end
    end)
end

Randomat:register(EVENT)