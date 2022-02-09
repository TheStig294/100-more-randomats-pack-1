local detectiveEquipmentItems
local traitorEquipmentItems
local detectiveWeaponsToRestore = {}
local traitorWeaponsToRestore = {}

net.Receive("BasicsRandomatClientStart", function()
    detectiveEquipmentItems = EquipmentItems[ROLE_DETECTIVE]
    traitorEquipmentItems = EquipmentItems[ROLE_TRAITOR]
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

    local defaultDetectiveItems = {"weapon_ttt_cse", "weapon_ttt_defuser", "weapon_ttt_teleport", "weapon_ttt_binoculars", "weapon_ttt_stungun", "weapon_ttt_health_station"}

    local defaultTraitorItems = {"weapon_ttt_flaregun", "weapon_ttt_knife", "weapon_ttt_teleport", "weapon_ttt_radio", "weapon_ttt_push", "weapon_ttt_sipistol", "weapon_ttt_decoy", "weapon_ttt_c4", "weapon_ttt_phammer"}

    for _, wepCopy in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(wepCopy)

        if istable(wepCopy.CanBuy) and isstring(classname) then
            local wep = weapons.GetStored(classname)
            local defaultDetectiveWep = false
            local defaultTraitorWep = false

            for _, defaultWep in ipairs(defaultDetectiveItems) do
                if classname == defaultWep then
                    defaultDetectiveWep = true
                end
            end

            for _, defaultWep in ipairs(defaultTraitorItems) do
                if classname == defaultWep then
                    defaultTraitorWep = true
                end
            end

            if not defaultDetectiveWep then
                table.RemoveByValue(wep.CanBuy, ROLE_DETECTIVE)
                table.insert(detectiveWeaponsToRestore, classname)
            end

            if not defaultTraitorWep then
                table.RemoveByValue(wep.CanBuy, ROLE_TRAITOR)
                table.insert(traitorWeaponsToRestore, classname)
            end
        end
    end

    RunConsoleCommand("ttt_reset_weapons_cache")
end)

net.Receive("BasicsRandomatClientEnd", function()
    EquipmentItems[ROLE_DETECTIVE] = detectiveEquipmentItems
    EquipmentItems[ROLE_TRAITOR] = traitorEquipmentItems

    for _, classname in ipairs(detectiveWeaponsToRestore) do
        local wep = weapons.GetStored(classname)
        table.insert(wep.CanBuy, ROLE_DETECTIVE)
    end

    for _, classname in ipairs(traitorWeaponsToRestore) do
        local wep = weapons.GetStored(classname)
        table.insert(wep.CanBuy, ROLE_TRAITOR)
    end

    RunConsoleCommand("ttt_reset_weapons_cache")
end)