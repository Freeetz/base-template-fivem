--[[ Main ]]--

nbPlayerTotal = 0
RegisterNetEvent('freetz:updatePlayerCount')
AddEventHandler('freetz:updatePlayerCount', function(nbPlayer)
    nbPlayerTotal = nbPlayer
end)

AddEventHandler('freetz:init', function()
    Citizen.CreateThread(function()
		while true do
			local Player = LocalPlayer()

			DisablePlayerVehicleRewards(Player.ID)
			SetPlayerHealthRechargeMultiplier(Player.ID, 0.0)
			SetRunSprintMultiplierForPlayer(Player.ID, 1.0)
			SetSwimMultiplierForPlayer(Player.ID, 1.0)

			if Player.IsDriver then
				SetPlayerCanDoDriveBy(Player.ID, false)
			else
				SetPlayerCanDoDriveBy(Player.ID, true)
			end

			if GetPlayerWantedLevel(Player.ID) ~= 0 then
				ClearPlayerWantedLevel(Player.ID)
            end

			Citizen.Wait(0)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			local Player = LocalPlayer()

			AddTextEntry('FE_THDR_GTAO', ('[~r~FR/QC/BE~s~] ~b~Freetz Community~s~ | ~b~%s~s~ [~b~%s~s~] | '.. nbPlayerTotal ..' Joueurs | discord.gg/freetz'):format(Player.Name, Player.ServerID))

			SetDiscordAppId(965518854367367209)
			SetDiscordRichPresenceAsset('logo')
			SetDiscordRichPresenceAssetText("Base template développer par Freetz !!")
			SetDiscordRichPresenceAssetSmall('logo')
			SetDiscordRichPresenceAssetSmallText('discord.gg/freetz')
            SetDiscordRichPresenceAction(0, "🎮・Se-Connecter", "https://discord.gg/freetz")
            SetDiscordRichPresenceAction(1, "🟢・Rejoindre le Discord", "https://discord.gg/freetz")
            SetRichPresence(("%s | [%s] - ".. nbPlayerTotal .." Joueurs"):format(Player.Name, Player.ServerID))

			Citizen.Wait(30000)
		end
	end)
end)

Citizen.CreateThread(function()
    while true do
        local interval = 1000
        if IsControlPressed(0, 25) then 
            interval = 0

            DisableControlAction(0, 18, true)
        end

        if IsPedArmed(PlayerPedId(), 2) or IsPedArmed(PlayerPedId(), 4) then 
            interval = 0 

            DisableControlAction(1, 26, true)
            DisableControlAction(0, 18, true)
        end

        if IsPedArmed(ped, 6) then
            interval = 0
            DisableControlAction(1, 26, true)
        end

        Wait(interval)
    end
end)

local NumberJump = 15

Citizen.CreateThread(function()
    local Jump = 0
    while true do
        local ped = PlayerPedId()
        local interval = 500

        if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
            interval = 0

            Jump = Jump + 1

            if Jump == NumberJump then
                SetPedToRagdoll(ped, 5000, 1400, 2)
                Jump = 0
            end
        end

        Wait(interval)
    end
end)
