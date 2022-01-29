local EVENT = {}
EVENT.Title = "Let's mix it up..."
EVENT.Description = "When you buy something, you get a random weapon instead"
EVENT.id = "mix"

function EVENT:Begin()
    -- TTT by default uses 8 different slots for weapons, if you're using TTT2 or something that adds more weapon slots where slots 100 and above become meaningful, this might cause unexpected behaviour... (But the randomat event itself should still work)
    local wepSlot = 100

    self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
        if not IsValid(ply) then return end
        -- Get all weapons
        local weps = weapons.GetList()
        local playerWeps = ply:GetWeapons()
        local give_weps = {}

        -- Filter out the un-buyable weapons
        for i = 1, #weps do
            local wep = weps[i]
            local weaponOwned = false

            -- Filter out all the weapons the player already owns
            for j, wepPly in ipairs(playerWeps) do
                if wepPly == wep then
                    weaponOwned = true
                end
            end

            if wep and (wep.CanBuy and #wep.CanBuy > 0) and not weaponOwned then
                give_weps[#give_weps + 1] = wep
            end
        end

        -- Select a random weapon and give it to the player
        if not table.IsEmpty(give_weps) then
            local item = give_weps[math.random(#give_weps)]
            local classname = WEPS.GetClass(item)
            -- Override the weapon's slot so one is always given
            item.Kind = wepSlot
            ply:Give(classname)
            Randomat:CallShopHooks(false, classname, ply)
            wepSlot = wepSlot + 1
        end

        ply:SubtractCredits(1)
        ply:ChatPrint("It's '" .. Randomat:GetEventTitle(EVENT) .. "'\nYou got a random item.")

        return false
    end)
end

Randomat:register(EVENT)