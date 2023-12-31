-------- [Base Template] dev par Freetz -------


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

RegisterNetEvent('esx_armour:armor')
AddEventHandler('esx_armour:armor', function()
	local plyPed = PlayerPedId()

	if GetPedArmour(plyPed) == 100 then
		ESX.ShowNotification("Tu a un gilet par balle neuf")
	else
		SetPedArmour(plyPed, 0)
		ClearPedBloodDamage(plyPed)
		ResetPedVisibleDamage(plyPed)
		ClearPedLastWeaponDamage(plyPed)
		ResetPedMovementClipset(plyPed, 0.0)

		TriggerServerEvent('esx_armour:armorremove')

		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 11,  ['bproof_2'] = 1})
				SetPedArmour(PlayerPedId(), 100)
			else
				TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 13,  ['bproof_2'] = 1})
				SetPedArmour(PlayerPedId(), 100)
			end
		end)

		ESX.ShowNotification("Tu a utilisé un gilet par balle")
	end
end)

RegisterNetEvent('esx_armour:handcuff')
AddEventHandler('esx_armour:handcuff', function()
	IsHandcuffed = not IsHandcuffed;
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		local player, distance = ESX.Game.GetClosestPlayer()

		if distance ~= -1 and distance <= 3.0 then
			if IsHandcuffed then
				ESX.Streaming.RequestAnimDict('mp_arresting')

				local otherPed = GetPlayerPed(player)

				TaskPlayAnim(otherPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
				RemoveAnimDict('mp_arresting')

				SetEnableHandcuffs(otherPed, true)
				SetPedCanPlayGestureAnims(otherPed, false)
				FreezeEntityPosition(otherPed, true)

				TriggerServerEvent('esx_armour:handcuffremove')
				ESX.ShowNotification('Tu a utlisé un serflex')
			else
				ESX.ShowNotification('Cette personne a déjà un serflex')
			end
		else
			ESX.ShowNotification('Aucun joueur à proximité')
		end
	end)
end)

RegisterNetEvent('esx_armour:cutting_pliers')
AddEventHandler('esx_armour:cutting_pliers', function()
	IsHandcuffed = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		local player, distance = ESX.Game.GetClosestPlayer()

		if distance ~= -1 and distance <= 3.0 then
			if IsHandcuffed then
				ESX.ShowNotification('Cette personne n\'a pas de serflex')
			else
				local otherPed = GetPlayerPed(player)

				ClearPedSecondaryTask(otherPed)
				SetEnableHandcuffs(otherPed, false)
				SetPedCanPlayGestureAnims(otherPed, true)
				FreezeEntityPosition(otherPed, false)

				ESX.ShowNotification('Tu a enlever un serflex')
			end
		else
			ESX.ShowNotification('Aucun joueur à proximité')
		end
	end)
end)

