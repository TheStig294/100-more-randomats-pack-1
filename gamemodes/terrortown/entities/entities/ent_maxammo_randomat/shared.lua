-- Credit goes to "ricky dicky doo dah grimes": https://steamcommunity.com/id/NexsX
-- For creating the original version of this entity for Sandbox: https://steamcommunity.com/sharedfiles/filedetails/?id=3310267134
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Max Ammo"
ENT.Author = "ricky dicky doo dah grimes"
ENT.Category = "CoD Zombies Power-ups"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:Draw()
    local ang = Angle(-15, RealTime() * 50, 0)
    self:SetAngles(ang)
    self:DrawModel()
end

function ENT:Initialize()
    self.Color = Color(255, 255, 255, 255)
    self.StartPos = self:GetPos()
    self:SetModel("models/codvanguard/other/powerups.mdl")
    self:SetModelScale(0.75)
    self:SetBodygroup(0, 1)
    self:SetBodygroup(1, 1)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:DrawShadow(false)
    self:ManipulateBonePosition(0, Vector(0, 0, -5))
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    ParticleEffectAttach("vortigaunt_hand_glow", PATTACH_POINT_FOLLOW, self, 1)
    self:EmitSound("doground/glow.mp3")
    self:StartFlashing()
    self:SetNWBool("UsePowerup", true)

    timer.Create("GlowSound" .. self:EntIndex(), 2, 0, function()
        if IsValid(self) then
            self:EmitSound("doground/glow.mp3")
        end
    end)

    timer.Create("CheckEntities" .. self:EntIndex(), 0.1, 0, function()
        if not IsValid(self) then
            timer.Remove("CheckEntities" .. self:EntIndex())

            return
        end

        local entities = ents.FindInSphere(self:GetPos(), 30)

        for _, ent in pairs(entities) do
            if ent:IsPlayer() then
                if not self:GetNWBool("UsePowerup", false) then return end
                self:SetNWBool("UsePowerup", false)
                self:MaxAmmoFunction()
                self:EmitSound("doground/gasp.mp3")

                if SERVER then
                    self:Remove()
                end
            end
        end
    end)
end

function ENT:MaxAmmoFunction()
    if CLIENT then return end
    BroadcastLua("surface.PlaySound(\"doground/max_ammo.mp3\")")

    if Randomat and Randomat.EventNotifySilent then
        Randomat:EventNotifySilent("Max Ammo!")
    end

    for _, ply in player.Iterator() do
        local activeWeapon = ply:GetActiveWeapon()

        if IsValid(activeWeapon) then
            local ammoType = activeWeapon:GetPrimaryAmmoType()
            local clipSize = activeWeapon:GetMaxClip1()
            local numMagazines = 4

            if ammoType and clipSize > 0 then
                ply:GiveAmmo(clipSize * numMagazines, ammoType, true)
            end
        end

        for _, weapon in ipairs(ply:GetWeapons()) do
            if weapon ~= activeWeapon then
                local ammoType = weapon:GetPrimaryAmmoType()
                local clipSize = weapon:GetMaxClip1()
                local numMagazines = 2

                if ammoType and clipSize > 0 then
                    ply:GiveAmmo(clipSize * numMagazines, ammoType, true)
                end
            end
        end
    end
end

function ENT:StartFlashing()
    local FlashInterval = 0.5
    local FlashSpeed = 0.04
    local DespawnDelay = 20

    timer.Simple(DespawnDelay - 5, function()
        if not IsValid(self) then return end

        timer.Create("FlashTimer" .. self:EntIndex(), FlashInterval, 0, function()
            if not IsValid(self) then
                timer.Remove("FlashTimer" .. self:EntIndex())

                return
            end

            if self:GetColor().a == 255 then
                self:SetRenderMode(RENDERMODE_TRANSALPHA)
                self:SetColor(Color(255, 255, 255, 0))
            else
                self:SetRenderMode(RENDERMODE_NORMAL)
                self:SetColor(Color(255, 255, 255, 255))
            end

            FlashInterval = math.max(FlashInterval - FlashSpeed, 0.1)
            timer.Adjust("FlashTimer" .. self:EntIndex(), FlashInterval)
        end)
    end)

    timer.Simple(DespawnDelay, function()
        if not IsValid(self) then return end
        timer.Remove("GlowSound" .. self:EntIndex())
        timer.Remove("FlashTimer" .. self:EntIndex())
        self:StopSound("doground/glow.mp3")
        self:EmitSound("doground/despawn.mp3")

        if SERVER then
            self:Remove()
        end
    end)
end

function ENT:OnRemove()
    timer.Remove("GlowSound" .. self:EntIndex())
    self:StopSound("doground/glow.mp3")
end