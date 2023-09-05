-------- [Base Template] dev par Freetz -------


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local TeleportPoint = {
	Bank = {
		positionFrom = vector3(780.6990, 1274.7892, 361.2846),
		positionTo = vector3(1118.9459, -3193.8291, -40.3946)
	},
	HumaneLabs = {
		positionFrom = vector3(3540.77, 3675.99, 28.07),
		positionTo = vector3(3540.52, 3675.52, 20.94)
	},
	Cronios = {
		positionFrom = vector3(-58.6388, -2244.7637, 8.9560),
		positionTo = vector3(891.8807, -3245.2808, -98.2651)
	},
	LabosM = {
		positionFrom = vector3(-1371.0139, -324.9042, 39.3098),
		positionTo = vector3(-1368.7314, -323.7731, 39.3674)
	},
	--Palais = {
	--	positionFrom = vector3(233.49, -410.88, 48.06),
	--	positionTo = vector3(239.55, -332.45, -119.82)
	--},
	BananaSplit = {
		positionFrom = vector3(-1569.409, -3017.4973, -74.46),
		positionTo = vector3(-254.89, 246.07, 91.52)
	},
	Casinototerasse = {
		positionFrom = vector3(965.14, 58.48, 112.55),
		positionTo = vector3(1004, 77.2, 73.28)
	},
	TerasseToHelico = {
		positionFrom = vector3(978.08, 61.96, 120.24),
		positionTo = vector3(968.08, 63.55, 112.55)
	},
	--Santamaria = {
	--	positionFrom = vector3(1398.06, 1141.77, 114.33),
	--	positionTo = vector3(1394.82, 1141.71, 114.62)
	--},
	Torture = {
		positionFrom = vector3(5444.3540, -5116.0376, 12.9904),
		positionTo = vector3(5433.1401, -5117.6992, -108.4337)
	},
	Entreport = {
		positionFrom = vector3(5124.2329, -5141.5405, 2.2016),
		positionTo = vector3(5124.3213, -5126.5483, -114.8454)
	},
	Entreport2 = {
		positionFrom = vector3(5159.9180, -5160.9194, 2.2436),
		positionTo = vector3(5157.0405, -5161.0977, 2.2333)
	},
	--Coke = {
	--	positionFrom = vector3(-391.1411, -2264.1560, 7.6082),
	--	positionTo = vector3(997.2649, -3200.6960, -36.3937)
	--},
	--Meth = {
	--	positionFrom = vector3(59.1247, 2795.2173, 57.8783),
	--	positionTo = vector3(1065.97, -3183.45, -39.16)
	--},
	--Opium = {
	--	positionFrom = vector3(2440.2166, 4068.1399, 38.0643),
	--	positionTo = vector3(1088.67, -3187.83, -38.99)
	--},
	Hopital1 = {
		positionFrom = vector3(-664.1417, 328.8913, 140.1229),
		positionTo = vector3(-664.4003, 326.1262, 78.1240)
	},
	--Hopital2 = {
	--	positionFrom = vector3(-664.2687, 326.3704, 83.0856),
	--	positionTo = vector3(-664.2804, 326.3083, 88.0144)
	--},
	--Hopital3 = {
	--	positionFrom = vector3(-661.3153, 326.1037, 83.0857),
	--	positionTo = vector3(-661.3665, 326.3950, 92.7405)
	--},
	AgenceImmo = {
		positionFrom = vector3(-906.0665, -451.5151, 39.6053),
		positionTo = vector3(-140.6458, -617.5888, 168.8204)
	}
	--Bank = {
	--	positionFrom = vector3(-2947.3154, 483.1855, 15.2574),
	--	positionTo = vector3(-2952.9800, 484.1853, 15.6970)
	--}
}

Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing

function Drawing.draw3DText(coords, text, fontId, scaleX, scaleY, r, g, b, a)
	local camCoords = GetGameplayCamCoords()
	local distance = GetDistanceBetweenCoords(camCoords, coords, 1)

	local scale = (1 / distance) * 10
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	SetTextScale(scaleX * scale, scaleY * scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText("STRING")
	SetTextCentre(1)
	AddTextComponentSubstringPlayerName(text)
	SetDrawOrigin(coords.x, coords.y, coords.z + 2, 0)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

function Drawing.drawMissionText(text, showtime)
	ClearPrints()
	BeginTextCommandPrint("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(showtime, 1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId(), false)
		local interval = 2500

		for k, v in pairs(TeleportPoint) do
			if GetDistanceBetweenCoords(coords, v.positionFrom) < 50.0 then
				interval = 0
				if GetDistanceBetweenCoords(coords, v.positionFrom) < 25.0 then
					DrawMarker(21, v.positionFrom, vector3(0.0, 0.0, 0.0), vector3(0.0, 180.0, 0.0), vector3(0.5, 0.5, 0.5), 255, 255, 255, 100, true, false, 2, false)

					if GetDistanceBetweenCoords(coords, v.positionFrom) < 1.5 then
						ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~")

						if IsControlJustPressed(0, 38) then
							DoScreenFadeOut(400)
							Citizen.Wait(400)
							--SetEntityCoords(PlayerPedId(), v.positionTo)
							SetPedCoordsKeepVehicle(PlayerPedId(), v.positionTo)
							Citizen.Wait(600)
							DoScreenFadeIn(600)
						end
					end
				end
			end

			if GetDistanceBetweenCoords(coords, v.positionTo) < 50.0 then
				interval = 0
				if GetDistanceBetweenCoords(coords, v.positionTo) < 25.0 then
					DrawMarker(21, v.positionTo, vector3(0.0, 0.0, 0.0), vector3(0.0, 180.0, 0.0), vector3(0.5, 0.5, 0.5), 255, 255, 255, 100, true, false, 2, false)

					if GetDistanceBetweenCoords(coords, v.positionTo) < 1.5 then
						ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~")

						if IsControlJustPressed(0, 38) then
							DoScreenFadeOut(400)
							Citizen.Wait(400)
							--SetEntityCoords(PlayerPedId(), v.positionFrom)
							SetPedCoordsKeepVehicle(PlayerPedId(), v.positionFrom)
							Citizen.Wait(600)
							DoScreenFadeIn(600)
						end
					end
				end
			end
		end

		Wait(interval)
	end
end)