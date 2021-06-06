local EVENT = {}
EVENT.Title = "Gun Game 2.0"
EVENT.Description = "Swap weapons when someone dies"
EVENT.id = "gungame2"

EVENT.DefaultWeaponList = {"weapon_zm_revolver", "weapon_weapon_ttt_dragon_elites", "weapon_zm_shotgun", "weapon_ttt_sawedoff", "weapon_zm_mac10", "weapon_ttt_ak47", "weapon_ttt_m16", "weapon_ttt_famas", "weapon_ttt_aug", "weapon_zm_sledge", "weapon_ttt_m60", "weapon_zm_rifle", "weapon_ttt_sg550", "randomat_weapon_huntingbow", "weapon_ttt_knife", "weapon_ttt_knife"}

EVENT.ZombieWeaponList = {"weapon_zm_revolver", "weapon_weapon_ttt_dragon_elites", "weapon_zm_shotgun", "weapon_ttt_m60", "weapon_zm_rifle", "weapon_ttt_sawedoff", "weapon_zm_mac10", "weapon_ttt_ak47", "weapon_ttt_m16", "weapon_ttt_famas", "weapon_ttt_aug", "weapon_zm_sledge", "weapon_ttt_sg550", "weapon_zm_shotgun", "weapon_ttt_m60", "weapon_ttt_sawedoff"}

EVENT.RandomListMinimumSize = 20
EVENT.Blacklist = {}
EVENT.MaxNumber = 16

function EVENT:Begin()
    local WeaponList = self:CreateWeaponList()

    if (self:CheckZombies()) then
        self:ChangeZombieGuns(WeaponList)
    else
        self:ChangeGuns(WeaponList)
    end

    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        timer.Simple(0.1, function()
            if (self:CheckZombies()) then
                self:ChangeZombieGuns()
            else
                self:ChangeGuns(WeaponList)
            end
        end)
    end)
end

function EVENT:RemoveWeapons(ply)
    for _, wep in pairs(ply:GetWeapons()) do
        if wep.Kind == WEAPON_HEAVY then
            ply:StripWeapon(wep:GetClass())
        end
    end
end

function EVENT:ChangeGuns(weapons)
    local AlivePlayerCount = self:CountAlivePlayers()

    if (AlivePlayerCount > self.MaxNumber) then
        AlivePlayerCount = self.MaxNumber
    elseif (AlivePlayerCount < 1) then
        AlivePlayerCount = 1
    end

    local weaponChoice = (self.MaxNumber - AlivePlayerCount) + 1

    for i, ply in pairs(self:GetAlivePlayers()) do
        local currentWeapon = ply:GetActiveWeapon()
        self:RemoveWeapons(ply)
        local wep = ply:Give(weapons[weaponChoice].ClassName)
        wep.AllowDrop = false

        if (currentWeapon.Kind == wep.Kind) then
            ply:SelectWeapon(wep.ClassName)
        else
            ply:SelectWeapon(currentWeapon.ClassName)
        end

        self:FixFOV(ply)
    end
end

function EVENT:ChangeZombieGuns(weapons)
    local AliveNonZom = self:CountNonZombiePlayers()

    if (AliveNonZom > self.MaxNumber) then
        AliveNonZom = self.MaxNumber
    elseif (AliveNonZom < 1) then
        AliveNonZom = 1
    end

    local weaponChoice = (self.MaxNumber - AliveNonZom) + 1

    for i, ply in pairs(self:GetAlivePlayers()) do
        local currentWeapon = ply:GetActiveWeapon()
        self:RemoveWeapons(ply)
        local wep = ply:Give(weapons[weaponChoice])
        wep.AllowDrop = false

        if (currentWeapon.Kind == wep.Kind) then
            ply:SelectWeapon(wep.ClassName)
        else
            ply:SelectWeapon(currentWeapon.ClassName)
        end

        self:FixFOV(ply)
    end
end

function EVENT:CountAlivePlayers()
    local j = 0

    for _, ply in pairs(self:GetAlivePlayers()) do
        j = j + 1
    end

    return j
end

function EVENT:CountNonZombiePlayers()
    local j = 0

    for _, ply in pairs(self:GetAlivePlayers()) do
        if (ply:GetRole() ~= ROLE_ZOMBIE) then
            j = j + 1
        end
    end
end

function EVENT:CheckZombies()
    for _, ply in pairs(self:GetAlivePlayers()) do
        if ply:GetRole() == ROLE_ZOMBIE then return true end
    end

    return false
end

function EVENT:CreateWeaponList()
    local RandomList = {}
    local ListSize = self.RandomListMinimumSize
    local PlayerCount = 1

    for _, ply in pairs(self:GetPlayers()) do
        PlayerCount = PlayerCount + 1
    end

    if self.RandomListMinimumSize < PlayerCount then
        ListSize = PlayerCount
    end

    local currentSize = 0

    for k, wep in pairs(weapons.GetList()) do
        if wep.AutoSpawnable and wep.Kind == WEAPON_HEAVY then
            table.insert(RandomList, wep)
            currentSize = currentSize + 1
        end
    end

    if next(RandomList) then
        while (currentSize < ListSize) do
            table.insert(RandomList, table.Random(RandomList))
            currentSize = currentSize + 1
        end
    else
        if self:CheckZombies() then
            return self.ZombieWeaponList
        else
            return self.DefaultWeaponList
        end
    end

    return RandomList
end

--Prevents picking up primaries or secondaries that are not part of the 'round'
function EVENT:PreventPickups()
end

--If players are using a scope, they get stuck in a zoomed FOV and this needs to be fixed
function EVENT:FixFOV(ply)
    if ply:GetActiveWeapon().Kind == WEAPON_HEAVY then
        ply:SetFOV(0, 0.2)
    end
end

Randomat:register(EVENT)