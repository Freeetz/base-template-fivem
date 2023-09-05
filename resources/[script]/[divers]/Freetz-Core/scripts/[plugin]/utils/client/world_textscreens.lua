--[[ Main ]]--
local textscreens = {
	{
		coords = vector3(-1280.8400, 303.5283, 64.9716),
		text = "~r~Bienvenue~s~ sur ~b~Freetz~s~ !\nPasse un ~b~agréable~s~ moment parmi nous !",
		size = 0.7,
		font = 0,
		maxDistance = 10
	},
	{
		coords = vector3(-1283.5825, 298.2694, 64.9404),
		text = "Noublie pas de rejoindre notre discord !\n~b~discord.gg/freetz~s~",
		size = 0.7,
		font = 0,
		maxDistance = 10
	},
	{
		coords = vector3(-843.15, -130.43, 28.98),
		text = "Recrutements staffs, ~r~ouvert~s~ !",
		size = 0.7,
		font = 0,
		maxDistance = 10

	},
	{
		coords = vector3(-799.0372, -99.1817, 37.6133),
		text = "Recrutements L.S.P.D ~g~OUVERT~b~ !\n~s~Contactez nous via l'application JOBS",
		size = 0.7,
		font = 0,
		maxDistance = 10

	},
	{
		coords = vector3(-1263.8125, 263.2060, 64.1372),
		text = "Bon ~o~Jeux~s~ !",
		size = 1.0,
		font = 0,
		maxDistance = 20

	},
	{
		coords = vector3(-1366.0211, 249.2933, 60.2011),
		text = "Bon ~o~Jeux~s~ !",
		size = 1.0,
		font = 0,
		maxDistance = 20

	},
	{
		coords = vector3(482.3105, 4812.0908, -58.3843),
		text = "Vous êtes ~r~bloqué~s~ ici ?\nContactez l\'~g~équipe staff~s~ afin d'être téléporter au ~b~Parking Central~s~\n~r~/report~s~ TP Parking Central !",
		size = 0.7,
		font = 0,
		maxDistance = 30

	},
	{
		coords = vector3(-1093.6245, -807.0079, 19.2825),
		text = "~b~Afin de contacter un agent, utiliser le téléphone.",
		size = 0.7,
		font = 0,
		maxDistance = 5
	}
}


AddEventHandler('freetz:init', function()
	Citizen.CreateThread(function()
		while true do
			local PlayerCoords = LocalPlayer().Coords
			local interval = 2500

			for i = 1, #textscreens, 1 do
				if #(PlayerCoords - textscreens[i].coords) < textscreens[i].maxDistance then
					interval = 0
					ESX.Game.Utils.DrawText3D(textscreens[i].coords, textscreens[i].text, textscreens[i].size, textscreens[i].font)
				end
			end

			Wait(interval)
		end
	end)
end)