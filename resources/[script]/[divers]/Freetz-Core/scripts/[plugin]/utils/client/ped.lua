AddEventHandler('freetz:init', function()
	Citizen.CreateThread(function()
		local wait = 15
		local count = 60

		while true do
			local Player = LocalPlayer()
			local interval = 2500

			if Player.Fighting then
				interval = 0
				if Player.Health < 115 then
					ESX.ShowNotification("~r~Tu es assommé !")
					wait = 15
					Player.KO = true
					SetEntityHealth(Player.Ped, 116)
				end
			end

			if Player.KO then
				interval = 0
				DisablePlayerFiring(Player.ID, true)
				SetPedToRagdoll(Player.Ped, 1000, 1000, 0, 0, 0, 0)
				ResetPedRagdollTimer(Player.Ped)
					
				if wait >= 0 then
					count = count - 1

					if count == 0 then
						count = 60
						wait = wait - 1
						SetEntityHealth(Player.Ped, GetEntityHealth(Player.Ped) + 4)
					end
				else
					Player.KO = false
				end
			end

			Citizen.Wait(interval)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			local Player = LocalPlayer()

			SetPedConfigFlag(Player.Ped, 35, false)
			SetPedConfigFlag(Player.Ped, 149, true)
			SetPedConfigFlag(Player.Ped, 438, true)

			Citizen.Wait(0)
		end
	end)
end)