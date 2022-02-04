local EVENT = {}
EVENT.Title = "Simon Says"
EVENT.Description = "Everyone is forced to use the gun the chosen person has out"
EVENT.id = "simonsays"
EVENT.leader = nil
EVENT.weapons = {}
EVENT.activeWeapon = nil
-- Declares this randomat a 'Weapon Override' randomat, meaning it cannot trigger if another Weapon Override randomat has triggered in the round
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

-- Allow players to hold the crowbar, magneto stick and 'holstered' even if the chosen player is holding something different
EVENT.whitelist = {"weapon_zm_improvised", "weapon_zm_carry", "weapon_ttt_unarmed"}

function EVENT:Begin()
    -- After 5 seconds,
    timer.Simple(5, function()
        -- Choose the 'leader'
        self:SelectLeader()

        -- And force everyone else to hold what they are holding
        timer.Create("RandomatCopyGuns", 0.1, 0, function()
            self:CopyGuns()
        end)
    end)

    -- Whenever a player walks over a weapon,
    self:AddHook("PlayerCanPickupWeapon", function(ply, wep)
        -- If there is a leader and they aren't the leader,
        if self.leader ~= nil and ply ~= self.leader then
            local allowPickup = false

            -- If they're trying to pick up the leader's weapon then let them
            for _, leaderWeapon in pairs(self.weapons) do
                if wep.ClassName == leaderWeapon.cl then
                    allowPickup = true
                    break
                end
            end

            -- Else, stop them from picking it up
            if not allowPickup then return false end
        end
    end)

    -- If someone dies,
    self:AddHook("PostPlayerDeath", function(ply)
        -- And they're the leader,
        if ply == self.leader then
            -- After a second,
            timer.Simple(1, function()
                -- Select a new leader
                self:SelectLeader()
            end)
        end
    end)
end

function EVENT:End()
    -- Stop forcing everyone to use the leader's guns
    timer.Remove("RandomatCopyGuns")
    self:CleanUpHooks()
end

function EVENT:SelectLeader()
    -- For all alive players,
    local plys = self:GetAlivePlayers(true)

    for _, ply in pairs(plys) do
        -- If there isn't already a leader,
        if self.leader == nil then
            -- Randomly pick a new one
            self.leader = table.Random(plys)
            break
        else
            -- If there is a leader, ensure the same person isn't chosen
            if ply ~= self.leader then
                self.leader = table.Random(plys)
                break
            end
        end
    end

    -- Let everyone know there is a new leader
    self:SmallNotify("You can only use the gun " .. self.leader:Nick() .. " is using.")
    -- Let the new leader drop their guns again
    self:UnlockGuns()
    -- Force everyone else to use the new leader's guns
    self:CopyGuns()
end

function EVENT:CopyGuns()
    if self.leader:Alive() then
        -- Get the leader's weapons,
        self.weapons = {}

        for k, v in pairs(self.leader:GetWeapons()) do
            table.insert(self.weapons, {
                cl = v.ClassName
            })
        end

        -- Active weapon,
        self.activeWeapon = self.leader:GetActiveWeapon().ClassName
        -- And them them drop guns
        self:UnlockGuns()
    end

    -- For everyone other than the leader,
    local plys = self:GetAlivePlayers()

    for _, ply in pairs(plys) do
        if ply ~= self.leader then
            -- Remove all weapons they have that the leader doesn't
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

            -- Unscope them so their fov isn't permenantly zoomed in if they were scoped
            ply:SetFOV(0, 0.2)

            -- Give them the leader's weapons and prevent them from dropping them
            for k, weapon in pairs(self.weapons) do
                local wep = ply:Give(weapon.cl)
                wep.AllowDrop = false
            end

            -- If the weapon they're holding isn't what the leader is holding,
            local wepCl = ply:GetActiveWeapon().ClassName

            if wepCl ~= self.activeWeapon then
                local whitelisted = false

                -- And it isn't one of the whitelisted weapons, (crowbar, magneto stick, holstered)
                for _, whitelistWeapon in pairs(self.whitelist) do
                    if wepCl == whitelistWeapon then
                        whitelisted = true
                        break
                    end
                end

                -- Force them to hold the leader's weapon
                if not whitelisted then
                    ply:SelectWeapon(self.activeWeapon)
                end
            end
        end
    end
end

-- Allows players to drop weapons
function EVENT:UnlockGuns()
    for _, wep in pairs(self.leader:GetWeapons()) do
        wep.AllowDrop = true
    end
end

Randomat:register(EVENT)