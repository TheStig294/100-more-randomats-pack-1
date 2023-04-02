AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Borgir"

function ENT:Initialize()
    self:SetModel("models/food/burger.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetHealth(1)
    self:SetModelScale(2, 0.0000001)
    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:OnRemove()
end

function ENT:OnTakeDamage(dmgInfo)
    self:Remove()

    return true
end

function ENT:Think()
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:Alive() or activator:IsSpec() then return end
    local newMult

    if math.random(0, 1) == 0 then
        local increment = GetConVar("randomat_borgir_faster_mult"):GetFloat()
        local currentMult = activator:GetLaggedMovementValue()
        newMult = currentMult + increment
        newMult = math.min(newMult, GetConVar("randomat_borgir_faster_cap"):GetFloat())
        activator:SetLaggedMovementValue(newMult)
        newMult = tostring(newMult)
        newMult = string.Left(newMult, 3)
        activator:PrintMessage(HUD_PRINTCENTER, "Fast borgir! Speed x" .. newMult)
    else
        local increment = GetConVar("randomat_borgir_slower_mult"):GetFloat()
        local currentMult = activator:GetLaggedMovementValue()
        newMult = currentMult - increment
        newMult = math.max(newMult, GetConVar("randomat_borgir_slower_cap"):GetFloat())
        activator:SetLaggedMovementValue(newMult)
        newMult = tostring(newMult)
        newMult = string.Left(newMult, 3)
        activator:PrintMessage(HUD_PRINTCENTER, "Slow borgir... Speed x" .. newMult)
    end

    self:EmitSound("borgir/borgir.mp3", 75, 100 * newMult)
    self:Remove()
end

function ENT:Break()
end