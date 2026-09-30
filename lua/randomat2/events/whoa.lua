local modelExists = util.IsValidModel("models/bandicoot/bandicoot.mdl")
util.PrecacheSound("whoa/whoa.mp3")
local timerCvar = CreateConVar("randomat_whoa_timer", 3, FCVAR_NONE, "Time between being given spin attacks", 1, 15)
local stripCvar = CreateConVar("randomat_whoa_strip", 1, FCVAR_NONE, "The event strips your other weapons")
local weaponidCvar = CreateConVar("randomat_whoa_weaponid", "weapon_ttt_whoa_randomat", FCVAR_NONE, "Id of the weapon given")
local strip = stripCvar:GetBool()

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

local EVENT = {}
EVENT.Title = "Whoa!"
EVENT.Description = GetDescription()
EVENT.id = "whoa"

EVENT.Categories = {"item", "largeimpact", "deathtrigger"}

if modelExists then
    table.insert(EVENT.Categories, 1, "modelchange")
end

if strip then
    EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
    table.insert(EVENT.Categories, "rolechange")
end

function EVENT:Begin()
    strip = stripCvar:GetBool()
    self.Description = GetDescription()
    local _, _, new_traitors = Randomat:BalanceTeams()
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)

    -- Periodically gives everyone the spin attack weapon
    timer.Create("RandomatWhoaTimer", timerCvar:GetInt(), 0, function()
        local weaponid = weaponidCvar:GetString()

        for _, ply in player.Iterator() do
            if not ply:Alive() or ply:IsSpec() then continue end

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
        end
    end)

    self:AddHook("PlayerCanPickupWeapon", function(_, wep)
        if not strip then return end

        return IsValid(wep) and WEPS.GetClass(wep) == weaponidCvar:GetString()
    end)

    self:AddHook("TTTCanOrderEquipment", function(ply, _, is_item)
        if not strip or not IsValid(ply) then return end

        if not is_item then
            ply:PrintMessage(HUD_PRINTCENTER, "Passive items only!")
            ply:ChatPrint("You can only buy passive items during '" .. Randomat:GetEventTitle(EVENT) .. "'!\nYour purchase has been refunded.")

            return false
        end
    end)

    self:AddHook("DoPlayerDeath", function(ply, _, dmginfo)
        -- Silence their usual death noise
        dmginfo:SetDamageType(DMG_SLASH)
        sound.Play("whoa/whoa.mp3", ply:GetShootPos(), 140, 100, 1)
    end)

    -- Sets someone's playermodel again when respawning, as force playermodel is off
    if modelExists then
        for _, ply in player.Iterator() do
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

    for _, ent in ipairs(ents.FindByClass(weaponidCvar:GetString())) do
        ent:Remove()
    end

    if strip then
        for _, ply in player.Iterator() do
            if not ply:Alive() or ply:IsSpec() then continue end
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

    -- Do not trigger passive item only events when there is a Faker
    for _, ply in player.Iterator() do
        if ply.IsFaker and ply:IsFaker() then return false end
    end

    return util.WeaponForClass(weaponidCvar:GetString()) ~= nil
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