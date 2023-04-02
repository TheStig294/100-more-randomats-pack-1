if SERVER then
    AddCSLuaFile()
end

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Bus"

-- Set the prop to a bus
function ENT:Initialize()
    if SERVER then
        self:SetTrigger(true)
    end

    self:SetModel("models/randomat/bus/bus.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:GetPhysicsObject():SetMass(1)
end

-- Kill any player that touches it
function ENT:StartTouch(ent)
    if IsPlayer(ent) and ent:Alive() and not ent:IsSpec() then
        local dmg = DamageInfo()
        dmg:SetDamage(ent:Health() + 1)
        dmg:SetDamageType(DMG_CLUB)
        dmg:SetInflictor(self)
        dmg:SetAttacker(self)
        ent:TakeDamageInfo(dmg)
        self:EmitSound("bus/bus_horn.mp3")
    end
end