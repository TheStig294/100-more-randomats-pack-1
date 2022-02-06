local EVENT = {}
EVENT.Title = "Future Proofing"
EVENT.Description = "Buy menu items aren't given until the next round you play"
EVENT.id = "future"
local futureRandomatEquipment = {}

local function SetWeaponGiveHook()
    hook.Add("TTTBeginRound", "FutureRandomatGiveEquipment", function()
        timer.Simple(0.1, function()
            local weaponKind = 10

            for i, ply in pairs(player.GetAll()) do
                -- If someone doesn't have an entry in the equipment table, add a blank one, which will prevent the below loop from erroring
                if not futureRandomatEquipment[ply:SteamID()] then
                    futureRandomatEquipment[ply:SteamID()] = {}
                end

                if ply:Alive() and not ply:IsSpec() then
                    for j, item in ipairs(futureRandomatEquipment[ply:SteamID()]) do
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

                    -- Don't display weapons given message if no weapons were given
                    if not table.IsEmpty(futureRandomatEquipment[ply:SteamID()]) then
                        ply:PrintMessage(HUD_PRINTCENTER, "Weapons from 'Future Proofing'!")
                        ply:PrintMessage(HUD_PRINTTALK, "You got weapons from the 'Future Proofing' randomat!")
                    end

                    -- Clear equipment table as equipment has been given
                    futureRandomatEquipment[ply:SteamID()] = {}
                end
            end
        end)
    end)
end

-- If the randomat triggered on the last round of the map, give players weapons from a text file
if file.Exists("randomat/future.txt", "DATA") then
    futureRandomatEquipment = util.JSONToTable(file.Read("randomat/future.txt", "DATA"))
    SetWeaponGiveHook()
    file.Delete("randomat/future.txt")
end

function EVENT:Begin()
    -- Add bought equipment to the table and remove it from the player
    self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
        if is_item then
            id = math.floor(id)
        end

        if table.HasValue(futureRandomatEquipment[ply], id) then
            ply:PrintMessage(HUD_PRINTCENTER, "You've already bought that!")
        else
            if futureRandomatEquipment[ply:SteamID()] == nil then
                futureRandomatEquipment[ply:SteamID()] = {}
            end

            table.insert(futureRandomatEquipment[ply:SteamID()], id)
            ply:SubtractCredits(1)
            ply:PrintMessage(HUD_PRINTCENTER, "You'll get that on the next round")
        end

        return false
    end)

    -- Set this hook to write the equipment table to a file in case the next round happens on the next map (Server is changing maps/shutting down)
    hook.Add("ShutDown", "FutureRandomatGiveNextMapWeapons", function()
        file.CreateDir("randomat")
        file.Write("randomat/future.txt", util.TableToJSON(futureRandomatEquipment))
    end)

    -- Give everyone's bought equipment at the start of the next round
    -- Delay this by a split second so if weapons are being given between maps, they are given before this randomat triggers and overrides the weapon giving hook
    timer.Simple(0.5, function()
        SetWeaponGiveHook()
    end)
end

Randomat:register(EVENT)