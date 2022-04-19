local EVENT = {}
EVENT.Title = "Simon Says"
EVENT.Description = "Everyone's forced to use the weapon the chosen person has out"
EVENT.id = "simonsays"
EVENT.leader = nil
EVENT.leaders = {}
EVENT.weapons = {}
EVENT.activeWeapon = nil
EVENT.givenWeapons = {}
EVENT.leaderSelectCount = 0
EVENT.leaderWeaponPickups = 0
-- This stops other "Weapon Override" randomats from triggering
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"item", "largeimpact"}

-- Weapons that aren't allowed during this event
EVENT.blocklist = {"weapon_zm_improvised", "weapon_zm_carry", "weapon_ttt_unarmed"}

-- Default guns to give out if the leader doesn't have one
EVENT.defaultHeavys = {"weapon_zm_sledge", "weapon_zm_shotgun", "weapon_zm_rifle", "weapon_zm_mac10", "weapon_ttt_m16"}

CreateConVar("randomat_simonsays_strip_basic_weapons", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether weapons like the crowbar and magneto stick are removed", 0, 1)

CreateConVar("randomat_simonsays_timer", "45", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds until leader changes, set to 0 disable", 0, 120)

local autoSpawnHeavyWeps = {}

function EVENT:Begin()
    self.leaderSelectCount = 0

    for i, swep in ipairs(weapons.GetList()) do
        if swep.AutoSpawnable and swep.Kind and swep.Kind == WEAPON_HEAVY then
            table.insert(autoSpawnHeavyWeps, swep)
        end
    end

    timer.Create("SimonSaysInitialTriggerTimer", 5, 1, function()
        -- Remove all grenades as players will expect to be able to hold them infinitely.
        -- When a nade is thrown, the player isn't given a new one even if the leader is still holding one, instead they can use their weapons freely
        -- This will still happen for weapons like the red matter bomb, but players tend to use shop items quickly
        for _, ent in ipairs(ents.GetAll()) do
            if not IsValid(ent) then continue end

            if ent.Kind and (ent.Kind == WEAPON_NADE or (ent.Kind == WEAPON_MELEE and ent:GetClass() ~= "weapon_zm_improvised")) then
                ent:Remove()
                -- Also remove everyone's crowbar, magneto stick and unarmed if configured to
            elseif (ent:GetClass() == "weapon_zm_carry" or ent:GetClass() == "weapon_ttt_unarmed" or ent:GetClass() == "weapon_zm_improvised") and GetConVar("randomat_simonsays_strip_basic_weapons"):GetBool() then
                ent:Remove()
            end
        end

        self:SelectLeader()

        for _, ply in ipairs(self:GetAlivePlayers()) do
            for _, wep in ipairs(ply:GetWeapons()) do
                if wep.Kind and wep.Kind == WEAPON_ROLE then
                    ply:ChatPrint("You can use role weapons regardless of what the chosen player is holding")
                    break
                end
            end
        end

        -- Forces everyone else to hold what the leader is holding 
        timer.Create("SimonSaysCopyGuns", 0.1, 0, function()
            self:CopyGuns()
        end)

        -- Select a new leader every 45 seconds
        timer.Create("SimonSaysSelectLeaderTimer", GetConVar("randomat_simonsays_timer"):GetInt(), 0, function()
            if GetConVar("randomat_simonsays_timer"):GetInt() ~= 0 then
                self:SelectLeader()
            end
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

        -- If the leader dies, select a new leader
        self:AddHook("PostPlayerDeath", function(ply)
            if ply == self.leader and #self:GetAlivePlayers() ~= 0 then
                timer.Start("SimonSaysSelectLeaderTimer")
                self:SelectLeader()
            end
        end)

        -- If we're switching from a TFA weapon to the disguiser while it's running, JUST DO IT!
        -- The holster animation causes a delay where the client is not allowed to switch weapons
        -- This means if we tell the user to select a weapon and then block the user from switching weapons immediately after,
        -- the holster animation delay will cause the player to not select the weapon we told them to
        self:AddHook("TFA_PreHolster", function(wep, target)
            if not IsValid(wep) or not IsValid(target) then return end
            local owner = wep:GetOwner()
            if not IsPlayer(owner) then return end
            local weapon = WEPS.GetClass(target)
            if weapon == self.activeWeapon then return true end
        end)

        -- Reset their given weapons when players respawn
        self:AddHook("PlayerSpawn", function(ply)
            self.givenWeapons[ply] = {}
        end)

        -- Count the amount of times the leader picks up a weapon, and change leader if they do it too many times
        self:AddHook("WeaponEquip", function(weapon, owner)
            if owner ~= self.leader then return end
            self.leaderWeaponPickups = self.leaderWeaponPickups + 1

            if self.leaderWeaponPickups > 10 then
                self:SelectLeader()
            end
        end)

        -- Prevent non-leaders from buying non-passive items
        self:AddHook("TTTCanOrderEquipment", function(ply, id, is_item)
            if ply ~= self.leader and not is_item then
                ply:PrintMessage(HUD_PRINTCENTER, "Not the leader, passive items only!")
                ply:ChatPrint("You can only buy passive items while you are not the leader!")

                return false
            end
        end)
    end)
end

function EVENT:End()
    -- Stop forcing everyone to use the leader's guns
    timer.Remove("SimonSaysInitialTriggerTimer")
    timer.Remove("SimonSaysCopyGuns")
    timer.Remove("SimonSaysSelectLeaderTimer")
    self.leader = nil
    self.leaders = {}
    self.weapons = {}
    self.activeWeapon = nil
    self.givenWeapons = {}
    table.Empty(autoSpawnHeavyWeps)
end

function EVENT:SelectLeader()
    self.givenWeapons = {}
    self.leaderWeaponPickups = 0
    -- For all alive players,
    local alivePlayers = self:GetAlivePlayers(true)

    -- If there isn't already a leader,
    if self.leader == nil then
        -- Randomly pick a new one,
        self.leader = alivePlayers[1]
    else
        -- If there is a leader, ensure someone who hasn't been picked before is chosen
        for _, pastLeader in ipairs(self.leaders) do
            table.RemoveByValue(alivePlayers, pastLeader)
        end

        -- But if everyone's been picked before then let everyone have a chance to be picked again
        if table.IsEmpty(alivePlayers) then
            alivePlayers = self:GetAlivePlayers(true)
            self.leaders = {}
        end

        for _, ply in ipairs(alivePlayers) do
            self.leader = ply
            table.insert(self.leaders, self.leader)
            break
        end
    end

    -- Let the new leader drop their guns again
    self:UnlockGuns()
    -- Remove the leader's crowbar, magneto stick and holstered weapons
    self:StripBlocklistedWeapons(self.leader)

    -- If the leader doesn't have any guns, give them a random default one
    if table.IsEmpty(self.leader:GetWeapons()) then
        local wep = self.leader:Give(self.defaultHeavys[math.random(1, #self.defaultHeavys)])
        self.leader:SelectWeapon(wep)
    end

    -- Let everyone know there is a new leader, unless they're a zombie as they'll soon not be the leader anymore
    if self.leader:GetRole() ~= ROLE_ZOMBIE then
        self:SmallNotify("You can only use the weapon " .. self.leader:Nick() .. " is using.")

        for _, wep in ipairs(self.leader:GetWeapons()) do
            if wep.Kind and wep.Kind == WEAPON_ROLE then
                local leader = self.leader

                timer.Simple(1, function()
                    leader:ChatPrint("No-one will get your role weapon(s)")
                end)

                break
            end
        end
    end
end

function EVENT:CopyGuns()
    if self.leader:Alive() then
        -- Get the leader's weapons,
        self.weapons = {}

        if table.IsEmpty(self.leader:GetWeapons()) then
            local classname = WEPS.GetClass(autoSpawnHeavyWeps[math.random(1, #autoSpawnHeavyWeps)])
            local wep = self.leader:Give(classname)
            wep.leaderLocked = true
        end

        for k, v in pairs(self.leader:GetWeapons()) do
            table.insert(self.weapons, {
                cl = v.ClassName
            })
        end

        self.activeWeapon = self.leader:GetActiveWeapon().ClassName
        -- And let them drop guns
        self:UnlockGuns()
    end

    -- If the leader turns into a zombie, change the leader
    if self.leader:GetRole() == ROLE_ZOMBIE then
        self.leaderSelectCount = self.leaderSelectCount + 1

        -- If everyone is a zombie, end the event
        if self.leaderSelectCount > 30 then
            self:SmallNotify(self.Title .. " has ended.")
            self:End()

            return
        end

        self:SelectLeader()

        return
    end

    local alivePlayers = self:GetAlivePlayers()

    for _, ply in pairs(alivePlayers) do
        self:StripBlocklistedWeapons(ply)

        -- For everyone other than the leader,
        if ply ~= self.leader then
            -- Remove all weapons they have that the leader doesn't
            for _, CurrentWeapon in pairs(ply:GetWeapons()) do
                local wepCl = CurrentWeapon.ClassName
                local delete = true

                for k, weapon in pairs(self.weapons or {}) do
                    -- Except if it is a role weapon!
                    if wepCl == weapon.cl or (CurrentWeapon.Kind and CurrentWeapon.Kind == WEAPON_ROLE) then
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

            -- If a player has already received a weapon, don't give it to them again
            -- This prevents weapons like grenades or the read matter bomb from being thrown infinite times if the leader holds it but doesn't throw it
            if self.givenWeapons[ply] == nil then
                self.givenWeapons[ply] = {}
            end

            -- Give them the leader's weapons and prevent them from dropping them
            for k, weapon in pairs(self.weapons) do
                -- Skip weapons already given before
                local alreadyGiven = false
                local classname = weapon.cl

                for _, givenWeapon in ipairs(self.givenWeapons[ply]) do
                    if classname == givenWeapon then
                        alreadyGiven = true
                        break
                    end
                end

                if not alreadyGiven then
                    local wep = ply:Give(classname)
                    wep.AllowDrop = false
                    table.insert(self.givenWeapons[ply], classname)
                end
            end

            -- If the weapon they're holding isn't what the leader is holding,
            local wepCl = ply:GetActiveWeapon().ClassName

            -- Or if the player isn't holding a role weapon 
            if self.activeWeapon ~= nil and wepCl ~= self.activeWeapon and not (ply:GetActiveWeapon().Kind and ply:GetActiveWeapon().Kind == WEAPON_ROLE) then
                -- Force them to hold the leader's weapon
                -- This will do nothing if the player has used the single-use item the leader has used
                ply:SelectWeapon(self.activeWeapon)
            end
        end
    end
end

-- Allows the leader to drop weapons, if they weren't given one they can't drop
function EVENT:UnlockGuns()
    for _, wep in pairs(self.leader:GetWeapons()) do
        if wep.leaderLocked then
            wep.AllowDrop = false
        else
            wep.AllowDrop = true
        end
    end
end

-- Removes the weapons from the blocklist from a player
function EVENT:StripBlocklistedWeapons(ply)
    if GetConVar("randomat_simonsays_strip_basic_weapons"):GetBool() then
        for _, classname in ipairs(self.blocklist) do
            if ply:HasWeapon(classname) then
                ply:StripWeapon(classname)
            end
        end
    end
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

    local checkboxes = {}

    for _, v in pairs({"strip_basic_weapons"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checkboxes, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders, checkboxes
end

Randomat:register(EVENT)