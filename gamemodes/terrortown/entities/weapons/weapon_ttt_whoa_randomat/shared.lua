-- A very basic weapon that causes the player to spin on primary attacking, and damage nearby players
if (CLIENT) then
    SWEP.PrintName = "Spin Attack"
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true
    SWEP.ViewModelFOV = 70
    SWEP.ViewModelFlip = true
    SWEP.CSMuzzleFlashes = false
    SWEP.Icon = "vgui/ttt/icon_spinattack.png"

    SWEP.EquipMenuData = {
        type = "Weapon",
        desc = "Click to spin attack."
    }
end

if (SERVER) then
    resource.AddFile('materials/vgui/ttt/icon_spinattack.png')
    AddCSLuaFile("shared.lua")
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = false
    SWEP.AutoSwitchFrom = false
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP1
SWEP.AutoSpawnable = false
SWEP.InLoudableFor = nil
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.HoldType = "normal"
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Click to spin attack"
SWEP.SlotPos = 1
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
-- 2-second cooldown in using this weapon
SWEP.Primary.Delay = 2
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Spinning = false

function SWEP:Initialize()
end

-- Whenever the player primary attacks,
function SWEP:PrimaryAttack()
    -- Prevent them from using the weapon again until the cooldown is over (2 seconds)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    -- Play the crash bandicoot spin attack sound
    if SERVER then
        self:GetOwner():EmitSound(Sound("whoa/spinattack.mp3"))
    end

    -- Set the player to start spinning
    self.Spinning = true

    -- After half a second, stop them from spinning, as this is the length of the sound
    timer.Simple(0.49, function()
        self.Spinning = false
    end)
end

function SWEP:Think()
    -- Constantly check if self.Spinning is true
    if self.Spinning and SERVER then
        -- If so, spin the player around
        self:GetOwner():SetEyeAngles(Angle(0, self:GetOwner():EyeAngles().y + 20, 0))

        -- And check if a player is close enough, alive and not the user of the weapon, then deal damage
        for i, ply in pairs(player.GetAll()) do
            if (self:GetOwner():GetPos():DistToSqr(ply:GetPos()) < (200 * 200)) and (ply ~= self:GetOwner()) and ply:Alive() and not ply:IsSpec() then
                ply:TakeDamage(5, self:GetOwner(), self)
            end
        end
    end
end

function SWEP:Holster()
    return true
end

function SWEP:DrawHUD()
end

-- Prevent any model from being drawn for this weapon
function SWEP:Deploy()
    local owner = self:GetOwner()

    if IsPlayer(owner) then
        owner:DrawWorldModel(false)
    end

    self:DrawShadow(false)

    return true
end

function SWEP:ShouldDrawViewModel()
    return false
end

-- Prevent this weapon from being dropped
function SWEP:OnDrop()
    self:Remove()
end

function SWEP:ShouldDropOnDie()
    return false
end