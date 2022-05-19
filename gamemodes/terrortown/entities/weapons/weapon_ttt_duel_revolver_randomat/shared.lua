-- Duel revolver used in the 'It's high noon...' randomat
AddCSLuaFile()
SWEP.PrintName = "Duel Revolver"
SWEP.Slot = 1
SWEP.Icon = "vgui/ttt/icon_pistols.png"
SWEP.IconLetter = "f"
SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "revolver"
SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Delay = 2
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Cone = 0.0325
SWEP.Primary.Damage = 1000
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 69
SWEP.Primary.DefaultClip = 75
SWEP.Primary.Sound = Sound("Weapon_357.Single")
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = Model("models/weapons/c_357.mdl")
SWEP.WorldModel = Model("models/weapons/w_357.mdl")
SWEP.IronSightsPos = Vector(-4.64, -3.96, 0.68)
SWEP.IronSightsAng = Vector(0.214, -0.1767, 0)
SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = false
SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.InLoadoutFor = {nil}

SWEP.LimitedStock = true
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = false

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    local owner = self:GetOwner()
    if not IsPlayer(owner) then return end
    -- Get the player the user is looking at
    local target = owner:GetEyeTrace().Entity
    local duellingPlayer = owner:GetNWEntity("HighNoonDuellingPlayer", NULL)

    -- Don't let duelling players shoot anyone else
    if duellingPlayer ~= NULL and SERVER and IsPlayer(target) and target ~= duellingPlayer then
        owner:PrintMessage(HUD_PRINTCENTER, "Not your duel opponent!")

        return
    elseif duellingPlayer ~= NULL or ((not IsPlayer(target)) or target == duellingPlayer) then
        -- Check if the target player was killed by the gunshot
        timer.Simple(0.1, function()
            if IsPlayer(target) and (target:IsSpec() or not target:Alive()) then
                owner:SetNWEntity("HighNoonDuellingPlayer", NULL)
                target:SetNWEntity("HighNoonDuellingPlayer", NULL)
                timer.Remove("HighNoonDuelOver" .. owner:SteamID64())
            end
        end)

        -- If they miss or are hitting their target, trigger the usual gunshot behaviour
        return self.BaseClass.PrimaryAttack(self)
    end

    if SERVER then
        if not IsPlayer(target) then return end
        -- Force the two players to look away from each other and freeze in place
        local ownerEyeAngles = owner:EyeAngles()
        owner:SetEyeAngles(-ownerEyeAngles)
        target:SetEyeAngles(ownerEyeAngles)
        owner:Freeze(true)
        target:Freeze(true)
        -- if owner:HasWeapon("weapon_ttt_unarmed") then
        -- Setting the flag for each player to be duelling
        owner:SetNWEntity("HighNoonDuellingPlayer", target)
        target:SetNWEntity("HighNoonDuellingPlayer", owner)
        -- Play the western whistle sound effect
        BroadcastLua("surface.PlaySound(\"highnoon/itshighnoon.mp3\")")
        local timerID = "DuelRevolver" .. owner:SteamID64()

        -- Shows a 3-second countdown, unfreezes players at 0 and plays a sound
        timer.Create(timerID, 1, 4, function()
            if timer.RepsLeft(timerID) == 0 then
                owner:PrintMessage(HUD_PRINTCENTER, "DRAW!")
                target:PrintMessage(HUD_PRINTCENTER, "DRAW!")
                owner:Freeze(false)
                target:Freeze(false)
                owner:SendLua("surface.PlaySound(\"highnoon/draw.mp3\")")
                target:SendLua("surface.PlaySound(\"highnoon/draw.mp3\")")

                -- After 10 seconds of duelling, the players are free to duel others and have to duel again to fight
                timer.Create("HighNoonDuelOver" .. owner:SteamID64(), 10, 1, function()
                    owner:SetNWEntity("HighNoonDuellingPlayer", NULL)
                    target:SetNWEntity("HighNoonDuellingPlayer", NULL)
                end)
            else
                local secondsLeft = timer.RepsLeft(timerID)
                owner:PrintMessage(HUD_PRINTCENTER, secondsLeft)
                target:PrintMessage(HUD_PRINTCENTER, secondsLeft)
            end
        end)
    end
end