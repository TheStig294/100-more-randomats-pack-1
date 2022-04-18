if (SERVER) then
    AddCSLuaFile("shared.lua")
    SWEP.HoldType = "melee2"
end

if (CLIENT) then
    SWEP.PrintName = "Baguette"
    SWEP.Author = "Gidz.Co"
    SWEP.Category = "Gidz.Co"
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
end

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/gidzco/bagette/v_bagette.mdl"
SWEP.WorldModel = "models/weapons/gidzco/bagette/w_bagette.mdl"
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
SWEP.Weight = 1
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.CSMuzzleFlashes = false
SWEP.Primary.Damage = 25
SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = 0.5
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Damage = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 5
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_MELEE
SWEP.Slot = 0
SWEP.InLoadoutFor = nil
SWEP.AutoSpawnable = false
SWEP.AllowDrop = false
SWEP.MissSound = Sound("Weapon_Crowbar.Single")

function SWEP:Initialize()
    self:SetWeaponHoldType("melee2")
end

--[[---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
    local owner = self:GetOwner()
    local tr = {}
    tr.start = owner:GetShootPos()
    tr.endpos = owner:GetShootPos() + (owner:GetAimVector() * 90)
    tr.filter = owner
    tr.mask = MASK_SHOT
    local trace = util.TraceLine(tr)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    owner:SetAnimation(PLAYER_ATTACK1)

    if trace.Hit then
        self:SendWeaponAnim(ACT_VM_HITCENTER)
        bullet = {}
        bullet.Num = 1
        bullet.Src = owner:GetShootPos()
        bullet.Dir = owner:GetAimVector()
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 0
        bullet.Force = 1
        bullet.Damage = self.Primary.Damage
        owner:FireBullets(bullet)
    else
        if IsFirstTimePredicted() then
            self:EmitSound(self.MissSound, 100, math.random(90, 120))
        end

        self:SendWeaponAnim(ACT_VM_MISSCENTER)
    end
end

-- Taken from "gamemodes/terrortown/entities/weapons/weapon_zm_improvised.lua"
function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(CurTime() + 0.1)
    local owner = self:GetOwner()

    if owner.LagCompensation then
        owner:LagCompensation(true)
    end

    local tr = owner:GetEyeTrace(MASK_SHOT)

    if tr.Hit and IsPlayer(tr.Entity) and (owner:EyePos() - tr.HitPos):Length() < 100 then
        local ply = tr.Entity

        if SERVER and (not ply:IsFrozen()) then
            local pushvel = tr.Normal * GetConVar("ttt_crowbar_pushforce"):GetFloat()
            pushvel.z = math.Clamp(pushvel.z, 50, 100)
            ply:SetVelocity(ply:GetVelocity() + pushvel)
            owner:SetAnimation(PLAYER_ATTACK1)

            ply.was_pushed = {
                att = owner,
                t = CurTime(),
                wep = self:GetClass()
            }
        end

        self:EmitSound(self.MissSound)
        self:SendWeaponAnim(ACT_VM_HITCENTER)
        self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
    end

    if owner.LagCompensation then
        owner:LagCompensation(false)
    end
end

--[[---------------------------------------------------------
Reload
---------------------------------------------------------]]
function SWEP:Reload()
    return false
end

--[[---------------------------------------------------------
OnRemove
---------------------------------------------------------]]
function SWEP:OnRemove()
    return true
end

--[[---------------------------------------------------------
Holster
---------------------------------------------------------]]
function SWEP:Holster()
    return true
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:ShouldDropOnDie()
    return false
end