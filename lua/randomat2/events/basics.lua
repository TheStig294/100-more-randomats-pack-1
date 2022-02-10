local EVENT = {}
EVENT.Title = "Back to Basics"
EVENT.Description = "Strips everything back to original TTT"
EVENT.id = "basics"
util.AddNetworkString("BasicsRandomatClientStart")
util.AddNetworkString("BasicsRandomatClientEnd")
local eventTriggered = false
-- All the things we're changing that are going to need to be reset once the event ends
local detectiveEquipmentItems
local traitorEquipmentItems
local detectiveExcludeWeapons
local traitorExcludeWeapons
local playerModels = {}
local summaryTabs = "summary,hilite,events,scores"
local orginalJumps = 1
local detectiveOnlySearch = true
local traitorHalos = true

function EVENT:Begin()
    eventTriggered = true
    -- First, save the current passive items detectives/traitors have
    detectiveEquipmentItems = EquipmentItems[ROLE_DETECTIVE]
    traitorEquipmentItems = EquipmentItems[ROLE_TRAITOR]
    detectiveExcludeWeapons = WEPS.ExcludeWeapons[ROLE_DETECTIVE]
    traitorExcludeWeapons = WEPS.ExcludeWeapons[ROLE_TRAITOR]
    -- Now, add just the default passive items for the detective/traitor
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

    -- Now setting all detective/traitor active items to just what they have by default
    -- Set SWEP.CanBuy to an empty table to all weapons that aren't the default ones for detective/traitor
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

            if wep.BlockShopRandomization then
                wep.BlockShopRandomizationOrig = wep.BlockShopRandomization
            end

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

    -- Fail-safe check for buying a non-default detective/traitor item
    self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
        local showMessage = true

        if is_item then
            id = math.floor(id)

            if id == EQUIP_ARMOR or id == EQUIP_RADAR or id == EQUIP_DISGUISE then
                showMessage = false
            end
        else
            for _, wep in ipairs(defaultDetectiveItems) do
                if wep == id then
                    showMessage = false
                    break
                end
            end

            for _, wep in ipairs(defaultTraitorItems) do
                if wep == id then
                    showMessage = false
                    break
                end
            end
        end

        if showMessage then
            ply:PrintMessage(HUD_PRINTCENTER, "Original items only!")
        end
    end)

    -- Tables of the default weapons/playermodels
    local defaultPistols = {"weapon_zm_revolver", "weapon_zm_pistol", "weapon_ttt_glock"}

    local defaultHeavys = {"weapon_zm_sledge", "weapon_zm_shotgun", "weapon_zm_rifle", "weapon_zm_mac10", "weapon_ttt_m16"}

    local defaultNades = {"weapon_zm_molotov", "weapon_ttt_smokegrenade", "weapon_ttt_confgrenade"}

    local defaultModels = {"models/player/phoenix.mdl", "models/player/arctic.mdl", "models/player/guerilla.mdl", "models/player/leet.mdl"}

    local standardHeightVector = Vector(0, 0, 64)
    local standardCrouchedHeightVector = Vector(0, 0, 28)
    -- Choosing a random default model for everyone
    local chosenModel = defaultModels[math.random(1, #defaultModels)]

    for _, ply in pairs(player.GetAll()) do
        -- Removing all non-default held weapons
        self:StripRoleWeapons(ply)
        local credits = 0
        local heldWepKind

        if IsValid(ply:GetActiveWeapon()) then
            heldWepKind = ply:GetActiveWeapon().Kind
        end

        timer.Simple(0.1, function()
            if heldWepKind then
                for _, wep in ipairs(ply:GetWeapons()) do
                    if wep.Kind and wep.Kind == heldWepKind then
                        ply:SelectWeapon(wep)
                    end
                end
            end
        end)

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
                -- Keeping track of how many credits need to be refunded when removing buy menu items
                credits = credits + 1
                ply:StripWeapon(wep:GetClass())
            end
        end

        -- Reset FOV to unscope
        ply:SetFOV(0, 0.2)
        -- Giving the magneto stick and "Holstered", just in case
        ply:Give("weapon_zm_carry")
        ply:Give("weapon_ttt_unarmed")

        if Randomat:IsTraitorTeam(ply) or Randomat:IsGoodDetectiveLike(ply) then
            -- Now stripping passive items
            local i = 1
            local equip = {}

            while i <= EQUIP_MAX do
                if ply:HasEquipmentItem(i) then
                    -- Remove and refund non-default equipment items
                    if i ~= EQUIP_ARMOR or i ~= EQUIP_RADAR or i ~= EQUIP_DISGUISE then
                        credits = credits + 1
                    else
                        table.insert(equip, i)
                    end
                end

                -- Double the index since this is a bit-mask
                i = i * 2
            end

            -- Change everyone to basic detectives/traitors
            if Randomat:IsTraitorTeam(ply) then
                Randomat:SetRole(ply, ROLE_TRAITOR)
            elseif Randomat:IsGoodDetectiveLike(ply) then
                Randomat:SetRole(ply, ROLE_DETECTIVE)
            end

            -- Refund all credits spent on stripped buy menu items
            ply:AddCredits(credits)
            ply:ResetEquipment()

            -- Add back all originally held default equipment items (since we only want to remove non-default items)
            for _, id in ipairs(equip) do
                ply:GiveEquipmentItem(id)
            end
        else
            -- Set all non-detectives/traitors to innocents, and remove all credits they have, as they now can't use them
            Randomat:SetRole(ply, ROLE_INNOCENT)
            ply:ResetEquipment()
            ply:SetCredits(0)
        end

        -- Command to stop Advanced Playermodel Selector from preventing playermodels from being changed
        ply:ConCommand("cl_playermodel_selector_force 0")

        -- Wait a second before giving everyone a default TTT playermodel as the "cl_playermodel_selector_force" command needs to be networked
        timer.Simple(1, function()
            if ply:GetViewOffset() ~= standardHeightVector then
                ply:SetViewOffset(standardHeightVector)
                ply:SetViewOffsetDucked(standardCrouchedHeightVector)
            end

            playerModels[ply] = ply:GetModel()
            ply:SetModel(chosenModel)
        end)
    end

    -- Updating everyone's roles in the bottom-left HUD box
    SendFullStateUpdate()

    -- Replacing all guns and grenades with default ones
    for _, ent in ipairs(ents.GetAll()) do
        if ent.AutoSpawnable and ent.Kind then
            local pos = ent:GetPos()
            local kind = ent.Kind
            local wepsTable = defaultPistols
            ent:Remove()

            if kind == WEAPON_PISTOL then
                wepsTable = defaultPistols
            elseif kind == WEAPON_HEAVY then
                wepsTable = defaultHeavys
            elseif kind == WEAPON_NADE then
                wepsTable = defaultNades
            end

            local wep = ents.Create(wepsTable[math.random(1, #defaultPistols)])
            wep:SetPos(pos)
            wep:Spawn()
        end
    end

    -- Replacing the end-of-round summary of everyone's roles with the classic highlights tab
    if ConVarExists("ttt_round_summary_tabs") then
        summaryTabs = GetConVar("ttt_round_summary_tabs"):GetString()
        GetConVar("ttt_round_summary_tabs"):SetString("hilite,events,scores")
        SetGlobalString("ttt_round_summary_tabs", "hilite,events,scores")
    end

    -- Prevent people from multi-jumping if a mod that adds it is installed
    if ConVarExists("multijump_default_jumps") then
        orginalJumps = GetConVar("multijump_default_jumps"):GetInt()
        GetConVar("multijump_default_jumps"):SetInt(0)

        timer.Simple(3, function()
            PrintMessage(HUD_PRINTTALK, "Warning!\nMulti-jumping is disabled!")
        end)
    end

    -- Letting everyone search bodies
    if ConVarExists("ttt_detective_search_only") then
        detectiveOnlySearch = GetConVar("ttt_detective_search_only"):GetBool()
        GetConVar("ttt_detective_search_only"):SetBool(false)
        SetGlobalBool("ttt_detective_search_only", false)
    end

    -- Preventing traitors from seeing each other with a red outline
    if ConVarExists("ttt_traitor_vision_enable") then
        traitorHalos = GetConVar("ttt_traitor_vision_enable"):GetBool()
        GetConVar("ttt_traitor_vision_enable"):SetBool(false)
        SetGlobalBool("ttt_traitor_vision_enable", false)
    end

    -- Disabling sprinting and removing non-default buy menu items on the client
    net.Start("BasicsRandomatClientStart")
    net.Broadcast()
end

function EVENT:End()
    -- Only reset everything if this randomat actually triggered
    if eventTriggered then
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

                if wep.BlockShopRandomizationOrig then
                    wep.BlockShopRandomization = wep.BlockShopRandomizationOrig
                end
            end
        end

        for _, ply in pairs(player.GetAll()) do
            if playerModels[ply] ~= nil then
                ply:SetModel(playerModels[ply])
            end

            ply:ConCommand("cl_playermodel_selector_force 1")
            table.Empty(playerModels)
        end

        if ConVarExists("ttt_round_summary_tabs") then
            GetConVar("ttt_round_summary_tabs"):SetString(summaryTabs)
            SetGlobalString("ttt_round_summary_tabs", summaryTabs)
        end

        if ConVarExists("multijump_default_jumps") then
            GetConVar("multijump_default_jumps"):SetInt(orginalJumps)
        end

        if ConVarExists("ttt_detective_search_only") then
            GetConVar("ttt_detective_search_only"):SetBool(detectiveOnlySearch)
            SetGlobalBool("ttt_detective_search_only", detectiveOnlySearch)
        end

        if ConVarExists("ttt_traitor_vision_enable") then
            GetConVar("ttt_traitor_vision_enable"):SetBool(traitorHalos)
            SetGlobalBool("ttt_traitor_vision_enable", traitorHalos)
        end

        net.Start("BasicsRandomatClientEnd")
        net.Broadcast()
    end
end

function EVENT:Condition()
    return not eventTriggered
end

Randomat:register(EVENT)