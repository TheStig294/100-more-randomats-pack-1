local EVENT = {}
EVENT.Title = "Back to Basics"
EVENT.Description = "Strips everything back to original TTT"
EVENT.id = "basics"
util.AddNetworkString("BasicsRandomatClientStart")
util.AddNetworkString("BasicsRandomatClientEnd")
local eventTriggered = false
local detectiveEquipmentItems
local traitorEquipmentItems
local detectiveWeaponsToRestore = {}
local traitorWeaponsToRestore = {}

local defaultPistols = {"weapon_zm_revolver", "weapon_zm_pistol", "weapon_ttt_glock"}

local defaultHeavys = {"weapon_zm_sledge", "weapon_zm_shotgun", "weapon_zm_rifle", "weapon_zm_mac10", "weapon_ttt_m16"}

local defaultNades = {"weapon_zm_molotov", "weapon_ttt_smokegrenade", "weapon_ttt_confgrenade"}

function EVENT:Begin()
    eventTriggered = true
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

    for _, ply in pairs(player.GetAll()) do
        local credits = 0
        ply:ConCommand("cl_playermodel_selector_force 0")
        self:StripRoleWeapons(ply)

        for _, wep in ipairs(ply:GetWeapons()) do
            if wep.Kind == WEAPON_MELEE then
                ply:StripWeapon(wep:GetClass())
                ply:Give("weapon_zm_improvised")
            elseif wep.Kind == WEAPON_PISTOL then
                ply:StripWeapon(wep:GetClass())
                ply:Give(defaultPistols[math.random(1, #defaultPistols)])
            elseif wep.Kind == WEAPON_HEAVY then
                ply:StripWeapon(wep:GetClass())
                ply:Give(defaultHeavys[math.random(1, #defaultHeavys)])
            elseif wep.Kind == WEAPON_NADE then
                ply:StripWeapon(wep:GetClass())
                ply:Give(defaultNades[math.random(1, #defaultNades)])
            elseif wep.Kind == WEAPON_EQUIP1 or wep.Kind == WEAPON_EQUIP2 or wep.Kind > WEAPON_ROLE then
                credits = credits + 1
                ply:StripWeapon(wep:GetClass())
            end
        end

        ply:Give("weapon_zm_carry")
        ply:Give("weapon_ttt_unarmed")

        if Randomat:IsTraitorTeam(ply) or Randomat:IsGoodDetectiveLike(ply) then
            local i = 1
            local equip = {}

            while i <= EQUIP_MAX do
                if ply:HasEquipmentItem(i) then
                    -- Remove and refund the specific equipment item we're removing
                    if i ~= EQUIP_ARMOR or i ~= EQUIP_RADAR or i ~= EQUIP_DISGUISE then
                        credits = credits + 1
                    else
                        table.insert(equip, i)
                    end
                end

                -- Double the index since this is a bit-mask
                i = i * 2
            end

            if Randomat:IsTraitorTeam(ply) then
                Randomat:SetRole(ply, ROLE_TRAITOR)
            elseif Randomat:IsGoodDetectiveLike(ply) then
                Randomat:SetRole(ply, ROLE_DETECTIVE)
            end

            ply:AddCredits(credits)
            ply:ResetEquipment()

            -- Add back the others (since we only want to remove the given item)
            for _, id in ipairs(equip) do
                ply:GiveEquipmentItem(id)
            end
        else
            Randomat:SetRole(ply, ROLE_INNOCENT)
            ply:ResetEquipment()
            ply:SetCredits(0)
        end
    end

    net.Start("BasicsRandomatClientStart")
    net.Broadcast()

    -- Wait a second before giving everyone default TTT playermodels as the "cl_playermodel_selector_force" command needs to be networked
    timer.Simple(1, function()
        SendFullStateUpdate()
    end)
end

function EVENT:End()
    if eventTriggered then
        eventTriggered = false
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

        for i, ply in ipairs(player.GetAll()) do
            ply:ConCommand("cl_playermodel_selector_force 1")
        end

        net.Start("BasicsRandomatClientEnd")
        net.Broadcast()
    end
end

Randomat:register(EVENT)