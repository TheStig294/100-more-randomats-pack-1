local detectiveEquipmentItems
local traitorEquipmentItems
local detectiveExcludeWeapons
local traitorExcludeWeapons

net.Receive("BasicsRandomatClientStart", function()
    -- Default passive buy menu items only
    detectiveEquipmentItems = EquipmentItems[ROLE_DETECTIVE]
    traitorEquipmentItems = EquipmentItems[ROLE_TRAITOR]
    detectiveExcludeWeapons = WEPS.ExcludeWeapons[ROLE_DETECTIVE]
    traitorExcludeWeapons = WEPS.ExcludeWeapons[ROLE_TRAITOR]
    local mat_dir = "vgui/ttt/"

    EquipmentItems[ROLE_DETECTIVE] = {
        {
            id = EQUIP_ARMOR,
            loadout = true,
            type = "item_passive",
            material = mat_dir .. "icon_armor",
            name = "item_armor",
            desc = "item_armor_desc"
        },
        {
            id = EQUIP_RADAR,
            type = "item_active",
            material = mat_dir .. "icon_radar",
            name = "item_radar",
            desc = "item_radar_desc"
        }
    }

    EquipmentItems[ROLE_TRAITOR] = {
        {
            id = EQUIP_ARMOR,
            type = "item_passive",
            material = mat_dir .. "icon_armor",
            name = "item_armor",
            desc = "item_armor_desc"
        },
        {
            id = EQUIP_RADAR,
            type = "item_active",
            material = mat_dir .. "icon_radar",
            name = "item_radar",
            desc = "item_radar_desc"
        },
        {
            id = EQUIP_DISGUISE,
            type = "item_active",
            material = mat_dir .. "icon_disguise",
            name = "item_disg",
            desc = "item_disg_desc"
        }
    }

    RunConsoleCommand("ttt_reset_weapons_cache")

    -- Displays a message if the sprint key is pressed while sprinting is disabled 
    hook.Add("PlayerBindPress", "BasicsRandomatDisableSprinting", function(ply, bind, pressed)
        if string.find(bind, "+speed") then
            ply:PrintMessage(HUD_PRINTCENTER, "Sprinting is disabled")

            return true
        end
    end)

    -- Disabling sprinting
    hook.Remove("Think", "TTTSprintThink")
    hook.Remove("Think", "TTTSprint4Think")

    -- Default active buy menu items only
    timer.Simple(1, function()
        local defaultDetectiveItems = {"weapon_ttt_cse", "weapon_ttt_defuser", "weapon_ttt_teleport", "weapon_ttt_binoculars", "weapon_ttt_stungun", "weapon_ttt_health_station"}

        local defaultTraitorItems = {"weapon_ttt_flaregun", "weapon_ttt_knife", "weapon_ttt_teleport", "weapon_ttt_radio", "weapon_ttt_push", "weapon_ttt_sipistol", "weapon_ttt_decoy", "weapon_ttt_c4", "weapon_ttt_phammer"}

        WEPS.ExcludeWeapons[ROLE_DETECTIVE] = {}
        WEPS.ExcludeWeapons[ROLE_TRAITOR] = {}

        for _, wepCopy in ipairs(weapons.GetList()) do
            local classname = WEPS.GetClass(wepCopy)

            if istable(wepCopy.CanBuy) and isstring(classname) then
                local wep = weapons.GetStored(classname)
                wep.CanBuyOrig = wep.CanBuy
                wep.CanBuy = {}

                if wep.BlockShopRandomization == nil then
                    wep.BlockShopRandomizationOrig = false
                else
                    wep.BlockShopRandomizationOrig = wep.BlockShopRandomization
                end

                wep.BlockShopRandomization = true

                for _, defaultWep in ipairs(defaultDetectiveItems) do
                    if classname == defaultWep then
                        table.insert(wep.CanBuy, ROLE_DETECTIVE)
                        break
                    end
                end

                for _, defaultWep in ipairs(defaultTraitorItems) do
                    if classname == defaultWep then
                        table.insert(wep.CanBuy, ROLE_TRAITOR)
                        break
                    end
                end
            end
        end
    end)
end)

net.Receive("BasicsRandomatClientEnd", function()
    -- Resetting everything that was changed on the client
    EquipmentItems[ROLE_DETECTIVE] = detectiveEquipmentItems
    EquipmentItems[ROLE_TRAITOR] = traitorEquipmentItems

    if detectiveExcludeWeapons then
        WEPS.ExcludeWeapons[ROLE_DETECTIVE] = detectiveExcludeWeapons
    end

    if traitorExcludeWeapons then
        WEPS.ExcludeWeapons[ROLE_TRAITOR] = traitorExcludeWeapons
    end

    for _, wepCopy in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(wepCopy)

        if istable(wepCopy.CanBuy) and isstring(classname) then
            local wep = weapons.GetStored(classname)
            wep.CanBuy = wep.CanBuyOrig
            wep.BlockShopRandomization = wep.BlockShopRandomizationOrig
        end
    end

    RunConsoleCommand("ttt_reset_weapons_cache")
    hook.Remove("PlayerBindPress", "BasicsRandomatDisableSprinting")
end)