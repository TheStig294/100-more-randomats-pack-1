-- Boomerang weapon used for the 'Boomerang Fu!' Randomat
if SERVER then
    AddCSLuaFile()
end

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Boomerang"

function ENT:Initialize()
    self.LastHitEntity = 0
    self.LastHitDirection = false
    self.Hits = 0
    self.TargetReached = false
    self.CollideCount = 0
    local targetPos = self:GetNWVector("targetPos")
    self.LastVelocity = (targetPos - self:GetPos()):GetNormalized()
    self.Drop = false
    self:SetModel("models/boomerang/boomerang.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:GetPhysicsObject():SetMass(0.5)
end

function ENT:PhysicsCollide(data, phys)
    if self.Drop or self.Hits >= 4 then return end
    local hitEntity = data.HitEntity
    local owner = self:GetOwner()

    if hitEntity == owner then
        owner:Give("weapon_ttt_boomerang_randomat")

        if SERVER then
            self:Remove()
        end
    end

    if IsValid(hitEntity) then
        if hitEntity:IsPlayer() or hitEntity:GetClass() ~= "prop_ragdoll" then
            self:SetPos(self:GetPos() + (self.LastVelocity:GetNormalized() * 40))
            self:SetAngles(Angle(20, 0, 90))
            self:GetPhysicsObject():AddAngleVelocity(Vector(0, -1000, 0) - self:GetPhysicsObject():GetAngleVelocity())
        end

        if hitEntity == self.LastHitEntity and self.TargetReached == self.LastHitDirection then return end
        self.LastHitEntity = hitEntity
        self.LastHitDirection = self.TargetReached

        if hitEntity:IsPlayer() then
            self.Hits = self.Hits + 1
        end

        self:EmitSound("weapons/crossbow/hitbod1.wav")
        local dmg = DamageInfo()
        dmg:SetAttacker(owner)
        dmg:SetDamage(50)
        dmg:SetDamageForce(self:GetVelocity() * 100)
        dmg:SetInflictor(self)
        dmg:SetDamageType(DMG_SLASH)
        dmg:SetDamagePosition(hitEntity:GetPos())
        hitEntity:TakeDamageInfo(dmg)
    end

    if not hitEntity:IsPlayer() and hitEntity:GetClass() ~= "prop_ragdoll" then
        self.CollideCount = self.CollideCount + 1

        if self.CollideCount > 1 then
            owner:SetNWEntity("boomerang_swep", self)

            timer.Create("propTimer", 1, 1, function()
                local weapon = ents.Create("weapon_ttt_boomerang_randomat")
                weapon:SetPos(self:GetPos())
                weapon:SetAngles(self:GetAngles())
                weapon:SetVelocity(self:GetVelocity())
                weapon:Spawn()
                weapon:Activate()
                weapon:SetModel("models/boomerang/boomerang.mdl")
                weapon.Hits = self.Hits

                if SERVER then
                    self:Remove()
                end
            end)

            self.Drop = true
        else
            self:SetPos(self:GetPos() + ((owner:GetShootPos() - self:GetPos()):GetNormalized() * 20))
            self:GoYourWayBack(20, 600)
        end
    else
        self:SetAngles(Angle(20, 0, 90))
        self:NextThink(CurTime())
    end
end

function ENT:Think()
    if self.Hits >= 4 then
        self:Remove()
    end

    if CLIENT or self.Drop then return end
    local targetPos = self:GetNWVector("targetPos")
    local Pos = self:GetPos()
    local owner = self:GetOwner()
    local ownerPos = owner:GetShootPos()

    if not self.TargetReached and (targetPos:Distance(Pos) < 500) then
        self:GoYourWayBack(40, 2000)

        return
    elseif not self.TargetReached then
        self:GetPhysicsObject():ApplyForceCenter((targetPos - Pos):GetNormalized() * 1000)
    else
        self:GetPhysicsObject():ApplyForceCenter((ownerPos - Pos):GetNormalized() * 1000)
    end

    if (self.TargetReached and self:NearOwner()) then
        owner:Give("weapon_ttt_boomerang_randomat")
        local boomerang = owner:GetWeapon("weapon_ttt_boomerang_randomat")
        boomerang.Hits = self.Hits

        if SERVER then
            self:Remove()
        end
    end
end

function ENT:GoYourWayBack(up, power)
    local Pos = self:GetPos()
    local ownerPos = self:GetOwner():GetShootPos()
    self:SetVelocity(Vector(0, 0, 0))
    self:GetPhysicsObject():ApplyForceCenter(((ownerPos + Vector(0, 0, up)) - Pos):GetNormalized() * power)
    self.LastVelocity = (-1) * self.LastVelocity
    self.TargetReached = true
    self:GetPhysicsObject():AddAngleVelocity(Vector(0, -10, 0) - self:GetPhysicsObject():GetAngleVelocity())
end

function ENT:NearOwner()
    local targetPos = self:GetNWVector("targetPos")
    local Pos = self:GetPos()
    local ownerPos = self:GetOwner():GetShootPos()
    if Pos:Distance(ownerPos) < 100 then return true end
    if targetPos:Distance(ownerPos) < targetPos:Distance(Pos) then return true end

    return false
end