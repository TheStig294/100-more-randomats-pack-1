local EVENT = {}
EVENT.Title = "Future Proofing"
EVENT.Description = "Buy menu items aren't given until the next round"
EVENT.id = "future"

EVENT.Categories = {"biased_innocent", "biased", "item", "largeimpact"}

local futureRandomatEquipment = {}

local function SetWeaponGiveHook()
    -- Prevent weapon override events like 'Harpooooon!' from triggering and removing the weapons you would have otherwise been given
    hook.Add("TTTRandomatCanEventRun", "FutureRandomatBlockWeaponOverrideEvents", function(event)
        if isnumber(event.Type) and event.Type == EVENT_TYPE_WEAPON_OVERRIDE then return false, "'Future Proofing' event blocked a weapon override event from triggering" end
    end)

    -- Only remove the block at the end of the round so players have a chance to use their weapons
    hook.Add("TTTEndRound", "FutureRandomatCheckAllWeaponsGiven", function()
        if (not istable(futureRandomatEquipment)) or table.IsEmpty(futureRandomatEquipment) then
            hook.Remove("TTTRandomatCanEventRun", "FutureRandomatBlockWeaponOverrideEvents")
            hook.Remove("TTTEndRound", "FutureRandomatCheckAllWeaponsGiven")
        end
    end)

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
                        local is_item = tonumber(item)

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

                        timer.Simple(0.1, function()
                            Randomat:CallShopHooks(is_item, item, ply)
                        end)
                    end

                    -- Don't display weapons given message if no weapons were given
                    if not table.IsEmpty(futureRandomatEquipment[ply:SteamID()]) then
                        ply:PrintMessage(HUD_PRINTCENTER, "Weapons from 'Future Proofing'!")
                        ply:PrintMessage(HUD_PRINTTALK, "You got weapons from the 'Future Proofing' randomat!")
                    end

                    -- Clear equipment table as equipment has been given
                    futureRandomatEquipment[ply:SteamID()] = nil
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
    -- If it is at the start of the round, turn any beggar into a jester, if enabled, else turn them into an innocent
    for _, ply in ipairs(self:GetAlivePlayers()) do
        if ply.IsBeggar and ply:IsBeggar() then
            if GetConVar("ttt_jester_enabled"):GetBool() then
                Randomat:SetRole(ply, ROLE_JESTER)
            else
                Randomat:SetRole(ply, ROLE_INNOCENT)
            end
        end
    end

    SendFullStateUpdate()

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

-- Checking if no-one is a beggar or if it is the start of the round, let the event run
function EVENT:Condition()
    local beggar = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if ply.IsBeggar and ply:IsBeggar() then
            beggar = true
            break
        end
    end

    return Randomat:GetRoundCompletePercent() < 5 and not beggar
end

Randomat:register(EVENT)