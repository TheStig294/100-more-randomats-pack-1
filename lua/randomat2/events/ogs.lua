local EVENT = {}

EVENT.Title = "The OGs"
EVENT.Description = "Everyone gets one of the original TTT weapons"
EVENT.id = "ogs"

local defaultWeapons = {
	"weapon_ttt_beacon",
	"weapon_ttt_binoculars",
	"weapon_ttt_c4",
	"weapon_ttt_cse",
	"weapon_ttt_decoy",
	"weapon_ttt_defuser",
	"weapon_ttt_flaregun",
	"weapon_ttt_health_station",
	"weapon_ttt_knife",
	"weapon_ttt_phammer",
	"weapon_ttt_push",
	"weapon_ttt_radio",
	"weapon_ttt_sipistol",
	"weapon_ttt_stungun",
	"weapon_ttt_teleport",
	"weapon_ttt_wtester"
}

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			local weapon = defaultWeapons[math.random(#defaultWeapons)]
			ply:Give(weapon)
		end)
	end
end

Randomat:register(EVENT)