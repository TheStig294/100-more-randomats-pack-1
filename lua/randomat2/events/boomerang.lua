local EVENT = {}

CreateConVar("randomat_boomerang_strip", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons", 0, 1)

CreateConVar("randomat_boomerang_weaponid", "weapon_ttt_boomerang_randomat", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")

EVENT.Title = "Boomerang Fu!"
EVENT.Description = "\"They're a one-shot if it hits you twice\""
EVENT.id = "boomerang"

EVENT.Categories = {"item", "largeimpact"}

-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
if GetConVar("randomat_boomerang_strip"):GetBool() then
    EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
end

function EVENT:Begin()
    --Remove all weapons from the ground (Which also removes all non-bought weapons from players)
    if GetConVar("randomat_boomerang_strip"):GetBool() then
        for _, ent in pairs(ents.GetAll()) do
            if ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE and ent.AutoSpawnable then
                ent:Remove()
            end
        end
    end

    for i, ply in pairs(self:GetAlivePlayers()) do
        --Strip all living players' weapons, if enabled
        if GetConVar("randomat_boomerang_strip"):GetBool() then
            ply:StripWeapons()
        end

        ply:SetFOV(0, 0.2)
        --Give everyone their initial boomerang
        ply:Give(GetConVar("randomat_boomerang_weaponid"):GetString())

        -- Set assassins to ordinary traitors as their damage bonus doesn't work with boomerangs
        if ply:GetRole() == ROLE_ASSASSIN and GetConVar("randomat_boomerang_strip"):GetBool() then
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:ChatPrint("Boomerangs are not affected by your assassin damage bonus.\nYou have been changed from an assassin to a traitor.")
            ply:PrintMessage(HUD_PRINTCENTER, "Role changed to traitor")
        end
    end

    SendFullStateUpdate()
    hook.Run("UpdatePlayerLoadouts")

    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            --Strip all living players' weapons, if enabled
            if GetConVar("randomat_boomerang_strip"):GetBool() then
                ply:StripWeapons()
            end

            --Give  their initial boomerang
            ply:Give(GetConVar("randomat_boomerang_weaponid"):GetString())
        end)
    end)
end

--Stop periodically giving out boomerangs
function EVENT:End()
    for i, ent in ipairs(ents.FindByClass(GetConVar("randomat_boomerang_weaponid"):GetString())) do
        ent:Remove()
    end

    if GetConVar("randomat_boomerang_strip"):GetBool() then
        for i, ply in ipairs(self:GetAlivePlayers()) do
            timer.Remove(ply:SteamID64() .. "BoomerangRandomatTimer")
            ply:Give("weapon_zm_improvised")
            ply:Give("weapon_zm_carry")
            ply:Give("weapon_ttt_unarmed")
        end
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"timer"}) do
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

    local checks = {}

    for _, v in ipairs({"strip"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    local textboxes = {}

    for _, v in ipairs({"weaponid"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(textboxes, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks, textboxes
end

Randomat:register(EVENT)