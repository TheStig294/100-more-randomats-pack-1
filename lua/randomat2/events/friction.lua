local EVENT = {}

CreateConVar("randomat_friction_friction", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Friction amount", 0, 8)

CreateConVar("randomat_friction_nopropdmg", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Immunity to prop damage, else you might die from touching props")

EVENT.Title = "Zero friction!"
EVENT.Description = ""
EVENT.id = "friction"

function EVENT:Begin()
    bananaRandomat = true

    if GetConVar("randomat_friction_nopropdmg"):GetBool() then
        self.Description = "Also, no prop damage!"
    else
        self.Description = ""
    end

    -- Setting friction to 0, by default
    RunConsoleCommand("sv_friction", GetConVar("randomat_friction_friction"):GetInt())

    -- Removing prop damage as props can easily unintentionally kill you while friction is set to 0, by default
    if GetConVar("randomat_friction_nopropdmg"):GetBool() then
        self:AddHook("EntityTakeDamage", function(ent, dmginfo)
            if IsValid(ent) and ent:IsPlayer() and dmginfo:IsDamageType(DMG_CRUSH) then return true end
        end)
    end

    -- Removing all explosive barrels from the map as people will not expect them to explode when they walk into them
    for i, barrel in ipairs(ents.FindByModel("models/props_c17/oildrum001_explosive.mdl")) do
        barrel:Remove()
    end
end

function EVENT:End()
    -- Preventing the end function running unless this randomat has already been run
    if bananaRandomat then
        RunConsoleCommand("sv_friction", 8)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"friction"}) do
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

    for _, v in ipairs({"nopropdmg"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks
end

Randomat:register(EVENT)