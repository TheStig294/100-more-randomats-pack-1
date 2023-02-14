local modelExists = util.IsValidModel("models/bandicoot/bandicoot.mdl")
util.PrecacheSound("whoa/whoa.mp3")
local EVENT = {}

CreateConVar("randomat_whoa_timer", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between being given spin attacks", 1, 15)

local strip = CreateConVar("randomat_whoa_strip", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons")

CreateConVar("randomat_whoa_weaponid", "weapon_ttt_whoa_randomat", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")

local function GetDescription()
    local description = "Everyone"

    if modelExists then
        description = description .. " is changed into Crash Bandicoot, and"
    end

    description = description .. " can"

    if strip then
        description = description .. " only"
    end

    description = description .. " spin attack!"

    return description
end

EVENT.Title = "Whoa!"
EVENT.Description = GetDescription()
EVENT.id = "whoa"

EVENT.Categories = {"item", "largeimpact", "deathtrigger"}

if strip then
    EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
    table.insert(EVENT.Categories, "rolechange")
end

function EVENT:HandleRoleWeapons(ply)
    if not strip then return end
    local updated = false
    local changing_teams = Randomat:IsMonsterTeam(ply) or Randomat:IsIndependentTeam(ply)

    -- Convert all bad guys to traitors so we don't have to worry about fighting with special weapon replacement logic
    if (Randomat:IsTraitorTeam(ply) and ply:GetRole() ~= ROLE_TRAITOR) or changing_teams then
        Randomat:SetRole(ply, ROLE_TRAITOR)
        updated = true
    elseif Randomat:IsJesterTeam(ply) then
        Randomat:SetRole(ply, ROLE_INNOCENT)
        updated = true
    end

    -- Remove role weapons from anyone on the traitor team now
    if Randomat:IsTraitorTeam(ply) then
        self:StripRoleWeapons(ply)
    end

    return updated, changing_teams
end

function EVENT:Begin()
    strip = GetConVar("randomat_whoa_strip"):GetBool()
    self.Description = GetDescription()
    local new_traitors = {}

    for _, v in ipairs(self:GetAlivePlayers()) do
        local _, new_traitor = self:HandleRoleWeapons(v)

        if new_traitor then
            table.insert(new_traitors, v)
        end
    end

    SendFullStateUpdate()
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)

    -- Periodically gives everyone the spin attack weapon
    timer.Create("RandomatWhoaTimer", GetConVar("randomat_whoa_timer"):GetInt(), 0, function()
        local weaponid = GetConVar("randomat_whoa_weaponid"):GetString()
        local updated = false

        for _, ply in ipairs(self:GetAlivePlayers()) do
            if strip then
                for _, wep in ipairs(ply:GetWeapons()) do
                    local weaponclass = WEPS.GetClass(wep)

                    if weaponclass ~= weaponid then
                        ply:StripWeapon(weaponclass)
                    end
                end

                -- Reset FOV to unscope
                ply:SetFOV(0, 0.2)
            end

            if not ply:HasWeapon(weaponid) then
                ply:Give(weaponid)
            end

            -- Workaround the case where people can respawn as Zombies while this is running
            updatedPly, new_traitor = self:HandleRoleWeapons(ply)
            updated = updated or updatedPly

            if new_traitor then
                table.insert(new_traitors, ply)
            end
        end

        -- If anyone's role changed, update each client
        -- If anyone became a traitor, notify all other traitors
        if updated then
            SendFullStateUpdate()
            self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)
            table.Empty(new_traitors)
        end
    end)

    self:AddHook("PlayerCanPickupWeapon", function(ply, wep)
        if not strip then return end

        return IsValid(wep) and WEPS.GetClass(wep) == GetConVar("randomat_whoa_weaponid"):GetString()
    end)

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        -- Silence their usual death noise
        dmginfo:SetDamageType(DMG_SLASH)
        sound.Play("whoa/whoa.mp3", ply:GetShootPos(), 140, 100, 1)
    end)

    -- Sets someone's playermodel again when respawning, as force playermodel is off
    if modelExists then
        for k, ply in pairs(player.GetAll()) do
            Randomat:ForceSetPlayermodel(ply, "models/bandicoot/bandicoot.mdl")
        end

        self:AddHook("PlayerSpawn", function(ply)
            timer.Simple(1, function()
                Randomat:ForceSetPlayermodel(ply, "models/bandicoot/bandicoot.mdl")
            end)
        end)
    end
end

function EVENT:End()
    timer.Remove("RandomatWhoaTimer")

    for i, ent in ipairs(ents.FindByClass(GetConVar("randomat_whoa_weaponid"):GetString())) do
        ent:Remove()
    end

    if strip then
        for i, ply in ipairs(self:GetAlivePlayers()) do
            ply:Give("weapon_zm_improvised")
            ply:Give("weapon_zm_carry")
            ply:Give("weapon_ttt_unarmed")
        end
    end

    if modelExists then
        Randomat:ForceResetAllPlayermodels()
    end
end

function EVENT:Condition()
    if Randomat:IsEventActive("grave") then return false end
    local weaponid = GetConVar("randomat_whoa_weaponid"):GetString()

    return util.WeaponForClass(weaponid) ~= nil
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"timer"}) do
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

    for _, v in pairs({"strip"}) do
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

    for _, v in pairs({"weaponid"}) do
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