local EVENT = {}

EVENT.Title = "Banana Peel"
EVENT.Description = "Zero friction"
EVENT.id = "banana"

local randomat_banana_friction = CreateConVar("randomat_banana_friction", "0", {FCVAR_ARCHIVE}, "Friction amount")
local randomat_banana_nopropdmg = CreateConVar("randomat_banana_nopropdmg", "1", {FCVAR_ARCHIVE}, "If enabled, everyone becomes immune to prop damage")

function EVENT:Begin()
	bananaRandomat = true
 RunConsoleCommand("sv_friction", randomat_banana_friction:GetFloat())
    if randomat_banana_nopropdmg:GetBool() then
		self:AddHook("EntityTakeDamage", function(ent, dmginfo)
			if IsValid(ent) and ent:IsPlayer() and dmginfo:IsDamageType(DMG_CRUSH) then
				return true
			end
		end)
    end
end

function EVENT:End()
	if bananaRandomat then
	RunConsoleCommand("sv_friction", 8)
	end
end

Randomat:register(EVENT)
