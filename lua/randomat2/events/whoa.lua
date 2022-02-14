local modelExists = util.IsValidModel("models/bandicoot/bandicoot.mdl")
util.PrecacheSound("whoa/whoa.mp3")
local EVENT = {}

CreateConVar("randomat_whoa_timer", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between being given spin attacks")

CreateConVar("randomat_whoa_strip", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons")

CreateConVar("randomat_whoa_weaponid", "weapon_ttt_whoa_randomat", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")

EVENT.Title = "Whoa!"
EVENT.Description = "Everyone can only spin attack!"
EVENT.id = "whoa"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:Begin()
    for i, ply in ipairs(self:GetAlivePlayers()) do
        -- Convert all independent guys to innocents so we don't have to worry about fighting damage penalty logic
        if Randomat:IsMonsterTeam(ply) or Randomat:IsIndependentTeam(ply) or Randomat:IsJesterTeam(ply) then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
        end
    end

    SendFullStateUpdate()

    for k, ply in pairs(player.GetAll()) do
        if modelExists then
            ForceSetPlayermodel(ply, "models/bandicoot/bandicoot.mdl")
        end
    end

    timer.Create("RandomatWhoaTimer", GetConVar("randomat_whoa_timer"):GetInt(), 0, function()
        local weaponid = GetConVar("randomat_whoa_weaponid"):GetString()

        for _, ply in pairs(self:GetAlivePlayers()) do
            if GetConVar("randomat_whoa_strip"):GetBool() then
                for _, wep in pairs(ply:GetWeapons()) do
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
        end
    end)

    self:AddHook("PlayerCanPickupWeapon", function(ply, wep)
        if not GetConVar("randomat_whoa_strip"):GetBool() then return end

        return IsValid(wep) and WEPS.GetClass(wep) == GetConVar("randomat_whoa_weaponid"):GetString()
    end)

    -- Sets someone's playermodel again when respawning, as force playermodel is off
    if modelExists then
        self:AddHook("PlayerSpawn", function(ply)
            timer.Simple(1, function()
                ForceSetPlayermodel(ply, "models/bandicoot/bandicoot.mdl")
            end)
        end)
    end

    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        -- Silence their usual death noise
        dmginfo:SetDamageType(DMG_SLASH)
        sound.Play("whoa/whoa.mp3", ply:GetShootPos(), 140, 100, 1)
    end)
end

function EVENT:End()
    timer.Remove("RandomatWhoaTimer")
    ForceResetAllPlayermodels()
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