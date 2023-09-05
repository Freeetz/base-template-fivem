ConfigFreetzBase = {}

ConfigFreetzBase.WeaponList = {
	324215364,
	-619010992,
	736523883,
	-270015777,
	171789620,
	2024373456,
	-1660422300,
	2144741730,
	1627465347,
	-1121678507,
	961495388,
	-1074790547,
	-2084633992,
	3686625920,
	-1357824103,
	-1063057011,
	4208062921,
	2132975508,
	100416529,
	1649403952,
	2017895192,
	-494615257,
	-1654528753,
	487013001,
	-952879014,
	-1466123874,
	177293209,
	-1074790547,
	205991906,
	-275439685,
	-1568386805,
	125959754,
	205991906,
	984333226,
	1119849093,
	2138347493,
	1834241177,
	-1312131151,
	1672152130,
	453432689,
	1305664598,
	3219281620,
	1593441988,
	-1076751822,
	-1716589765,
	-598887786,
	137902532,
	771403250,
	911657153,
	1198879012,
	584646201,
	-1045183535,
}

ConfigFreetzBase.PedAbleToWalkWhileSwapping = true
ConfigFreetzBase.UnarmedHash = -1569615261

Citizen.CreateThread(function()
	local animDict = 'reaction@intimidation@1h'

	local animIntroName = 'intro'
	local animOutroName = 'outro'

	local animFlag = 0

	RequestAnimDict(animDict)
	  
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end

	local lastWeapon = nil

	while true do
		local interval = 2500

		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			interval = 500
			if ConfigFreetzBase.PedAbleToWalkWhileSwapping then
				animFlag = 48
			else
				animFlag = 0
			end

			for i=1, #ConfigFreetzBase.WeaponList do
				if lastWeapon ~= nil and lastWeapon ~= ConfigFreetzBase.WeaponList[i] and GetSelectedPedWeapon(PlayerPedId()) == ConfigFreetzBase.WeaponList[i] then
					SetCurrentPedWeapon(PlayerPedId(), ConfigFreetzBase.UnarmedHash, true)
					TaskPlayAnim(PlayerPedId(), animDict, animIntroName, 8.0, -8.0, 2700, animFlag, 0.0, false, false, false)

					Citizen.Wait(1000)
					SetCurrentPedWeapon(PlayerPedId(), ConfigFreetzBase.WeaponList[i], true)
				end

				if lastWeapon ~= nil and lastWeapon == ConfigFreetzBase.WeaponList[i] and GetSelectedPedWeapon(PlayerPedId()) == ConfigFreetzBase.UnarmedHash then
					TaskPlayAnim(PlayerPedId(), animDict, animOutroName, 8.0, -8.0, 2100, animFlag, 0.0, false, false, false)

					Citizen.Wait(1000)
					SetCurrentPedWeapon(PlayerPedId(), ConfigFreetzBase.UnarmedHash, true)
				end
			end
		end

		lastWeapon = GetSelectedPedWeapon(PlayerPedId())

		Wait(interval)
	end
end)