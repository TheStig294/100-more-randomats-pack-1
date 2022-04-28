if SERVER then
    AddCSLuaFile()
end

ENT.Base = "base_anim"
ENT.Type = "anim"

-- Set the prop to a bucket
function ENT:Initialize()
    if SERVER then
        self:SetTrigger(true)
    end

    self:SetModel("models/props_junk/metalbucket01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:GetPhysicsObject():SetMass(0.5)
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
    end
end