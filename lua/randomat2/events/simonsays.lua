local EVENT = {}
EVENT.Title = "Simon Says"
EVENT.Description = "Everyone's forced to use the gun the chosen person has out"
EVENT.id = "simonsays"
EVENT.leader = nil
EVENT.weapons = {}
EVENT.activeWeapon = nil

EVENT.whitelist = {"weapon_zm_improvised", "weapon_zm_carry", "weapon_ttt_unarmed"}

function EVENT:Begin()
    timer.Simple(5, function()
        self:SelectLeader()

        timer.Create("RandomatCopyGuns", 0.1, 0, function()
            self:CopyGuns()
        end)
    end)

    self:AddHook("PlayerCanPickupWeapon", function(ply, wep)
        if self.leader ~= nill then
            if ply ~= self.leader then
                local allowPickup = false

                for _, leaderWeapon in pairs(self.weapons) do
                    if wep.ClassName == leaderWeapon.cl then
                        allowPickup = true
                        break
                    end
                end

                if not allowPickup then return false end
            end
        end
    end)

    self:AddHook("PostPlayerDeath", function(ply)
        if ply == self.leader then
            timer.Simple(1, function()
                self:SelectLeader()
            end)
        end
    end)
end

function EVENT:End()
    timer.Remove("RandomatCopyGuns")
    self:CleanUpHooks()
end

function EVENT:SelectLeader()
    local plys = self:GetAlivePlayers(true)

    for _, ply in pairs(plys) do
        if self.leader == nil then
            self.leader = table.Random(plys)
            break
        else
            if ply ~= self.leader then
                self.leader = table.Random(plys)
                break
            end
        end
    end

    self:SmallNotify("You can only use the gun " .. self.leader:Nick() .. " is using.")
    self:UnlockGuns()
    self:CopyGuns()
end

function EVENT:CopyGuns()
    if self.leader:Alive() then
        self.weapons = {}

        for k, v in pairs(self.leader:GetWeapons()) do
            table.insert(self.weapons, {
                cl = v.ClassName
            })
        end

        self.activeWeapon = self.leader:GetActiveWeapon().ClassName
        self:UnlockGuns()
    end

    local plys = self:GetAlivePlayers()

    for _, ply in pairs(plys) do
        if ply ~= self.leader then
            for _, CurrentWeapon in pairs(ply:GetWeapons()) do
                local wepCl = CurrentWeapon.ClassName
                local delete = true

                for k, weapon in pairs(self.weapons or {}) do
                    if wepCl == weapon.cl then
                        delete = false
                        break
                    end
                end

                if delete then
                    ply:StripWeapon(wepCl)
                end
            end

            for k, weapon in pairs(self.weapons) do
                local wep = ply:Give(weapon.cl)
                wep.AllowDrop = false
            end

            local wepCl = ply:GetActiveWeapon().ClassName

            if wepCl ~= self.activeWeapon then
                local whitelisted = false

                for _, whitelistWeapon in pairs(self.whitelist) do
                    if wepCl == whitelistWeapon then
                        whitelisted = true
                        break
                    end
                end

                if not whitelisted then
                    ply:SelectWeapon(self.activeWeapon)
                end
            end
        end
    end
end

function EVENT:UnlockGuns()
    for _, wep in pairs(self.leader:GetWeapons()) do
        wep.AllowDrop = true
    end
end

function EVENT:Condition()
    if next(Randomat.ActiveEvents) == nil then return true end

    for k, v in pairs(Randomat.ActiveEvents) do
        if v.Id == "gungame" then
            return false
        elseif v.Id == "randomweapon" then
            return false
        elseif v.Id == "gungame2" then
            return false
        end
    end

    return true
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"delay"}) do
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

    return sliders
end

Randomat:register(EVENT)