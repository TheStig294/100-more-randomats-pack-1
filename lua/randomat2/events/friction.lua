local EVENT = {}
CreateConVar("randomat_friction_friction", "0", FCVAR_NONE, "Friction amount", 0, 8)
CreateConVar("randomat_friction_nopropdmg", "1", FCVAR_NONE, "Immunity to prop damage, else you might die from touching props")
EVENT.Title = "Zero friction!"
EVENT.Description = ""
EVENT.ExtDescription = "Everyone slides around, and must build momentum to move"
EVENT.id = "friction"

EVENT.Categories = {"largeimpact"}

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
            if IsPlayer(ent) and dmginfo:IsDamageType(DMG_CRUSH) then
                -- If we make people immune to damage from the barnacle, the last players alive could get stuck, so also let barnacle damage through
                if IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() == "npc_barnacle" then
                    return
                else
                    return true
                end
            end
        end)
    end

    -- Removing all explosive barrels from the map as people will not expect them to explode when they walk into them
    for i, barrel in ipairs(ents.FindByModel("models/props_c17/oildrum001_explosive.mdl")) do
        local class = barrel:GetClass()

        -- Check if the barrel is actually a physics prop first and not a prop disguised player
        if string.StartWith(class, "prop_physics") and not barrel.IsADisguise then
            barrel:Remove()
        end
    end

    -- Refund credits if players are holding weapons that don't work during this event
    for i, ply in ipairs(self:GetAlivePlayers()) do
        if ply:HasWeapon("weapon_prop_blaster") then
            ply:StripWeapon("weapon_prop_blaster")
            ply:AddCredits(1)
            ply:ChatPrint("The prop blaster doesn't work during this event.\nYour credit has been refunded.")
        end

        if ply:HasWeapon("weapon_randomlauncher") then
            local wep = ply:GetWeapon("weapon_randomlauncher")

            if wep:Clip1() ~= nil and wep:Clip1() > 0 then
                ply:StripWeapon("weapon_randomlauncher")
                ply:AddCredits(1)
                ply:ChatPrint("The random launcher doesn't work during this event.\nYour credit has been refunded.")
            end
        end
    end

    -- Prevent players from buying weapons that don't work
    self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
        if id == "weapon_prop_blaster" or id == "weapon_randomlauncher" then
            ply:PrintMessage(HUD_PRINTCENTER, "Doesn't work during this randomat!")

            return false
        end
    end)
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