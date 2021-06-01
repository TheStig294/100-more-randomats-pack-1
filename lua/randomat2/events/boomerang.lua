local EVENT = {}

CreateConVar("randomat_boomerang_timer", 5, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between being given boomerangs")
CreateConVar("randomat_boomerang_strip", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons")
CreateConVar("randomat_boomerang_weaponid", "weapon_ttt_boomerang_randomat", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")


EVENT.Title = "Boomerang Fu!"
EVENT.Description = "Return-throw only boomerangs for all!"
EVENT.id = "boomerang"

function EVENT:Begin()
	if GetConVar("randomat_boomerang_strip"):GetBool() then
		for _, ent in pairs(ents.GetAll()) do
			if ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE and ent.AutoSpawnable then
				ent:Remove()
			end
		end
	end
	
	for i, ply in pairs(self:GetAlivePlayers(true)) do
		if table.Count(ply:GetWeapons()) ~= 1 or (table.Count(ply:GetWeapons()) == 1 and ply:GetActiveWeapon():GetClass() ~= "weapon_ttt_homebat") then
			if GetConVar("randomat_boomerang_strip"):GetBool() then
				ply:StripWeapons()
			end
			ply:Give(GetConVar("randomat_boomerang_weaponid"):GetString())
		end
	end
	
	timer.Create("RandomatBoomerangTimer", GetConVar("randomat_boomerang_timer"):GetInt(), 0, function()
		for i, ply in pairs(self:GetAlivePlayers(true)) do
			if table.Count(ply:GetWeapons()) ~= 1 or (table.Count(ply:GetWeapons()) == 1 and ply:GetActiveWeapon():GetClass() ~= "weapon_ttt_homebat") then
				if GetConVar("randomat_boomerang_strip"):GetBool() then
					ply:StripWeapons()
				end
				ply:Give(GetConVar("randomat_boomerang_weaponid"):GetString())
			end
		end
	end)
	self:AddHook("Think", function()
		for i, ply in pairs(self:GetAlivePlayers(true)) do
			if ply:HasWeapon("weapon_ttt_boomerang") then
				if GetConVar("randomat_boomerang_strip"):GetBool() and GetConVar("randomat_boomerang_weaponid"):GetString() ~= "weapon_ttt_boomerang" then
					ply:StripWeapons()
					ply:Give(GetConVar("randomat_boomerang_weaponid"):GetString())
				end
			end
		end
	end)
end

function EVENT:End()
	timer.Remove("RandomatBoomerangTimer")
end

Randomat:register(EVENT)