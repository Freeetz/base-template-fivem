local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end

	while true do
		ESX.PlayerData = ESX.GetPlayerData()
        Wait(1500)
	end
end)

local safeZones = {
	vector3(-821.2, -127.65, 28.18),
	vector3(218.76, -802.87, 30.09),
	vector3(429.54, -981.86, 30.71),
	vector3(-38.22, -1100.84, 26.42),
	vector3(-1276.0182, 312.9510, 64.5118),
	vector3(295.68, -586.45, 43.14),
	vector3(-211.34, -1322.06, 30.89),
	vector3(234.42, -863.06, 29.86),
	vector3(2748.9648, 3472.4531, 55.6782),
	vector3(-1079.4501, -817.1877, 19.3568),
	vector3(-676.7147, 312.0013, 83.0841),
	vector3(-290.1886, -892.8923, 31.0801),
	vector3(-355.3748, -129.6715, 39.4307),
	vector3(-2167.82, 5191.79, 16.38),
	vector3(-1259.59, -360.44, 36.91),
	vector3(6.8256, -933.3570, 29.9049),
	vector3(482.998, 4812.112, -58.384),
	vector3(-38.58, -1046.38, 28.4),
	vector3(83.5511, -1394.5829, 29.4018),
	vector3(1643.32, 2570.36, 44.56),
	vector3(16.58, -1116.03, 29.79),
	vector3(117.3068, -1289.5239, 28.2610),
	vector3(-799.7953, -591.5215, 30.2760),
	vector3(29.2569, -1351.2438, 29.3365),
	vector3(175.1979, -941.8757, 29.4547),
	vector3(-1189.1755, -890.6185, 13.8862),
	vector3(-1397.1432, -606.3572, 30.3200),
	vector3(-913.3368, -2040.4561, 9.4048),
	vector3(-806.5526, -1353.7396, 5.1609),
	vector3(-363.3431, -121.6884, 38.6976),
	vector3(148.3779, -3034.0073, 7.0547),
	vector3(909.2472, -172.3728, 74.1654),
	vector3(-222.6269, -1327.1818, 31.3005),
	vector3(239.1021, -1381.7676, 33.7418),
	vector3(148.5973, -1040.2578, 29.3702),
	vector3(-207.2040, -1176.0585, 23.0440),
	vector3(408.6832, -1640.6146, 29.2921),
	vector3(-716.7722, -156.7699, 36.9880),
	vector3(-814.8245, -184.2205, 37.5689),
	vector3(-167.8628, -298.9688, 39.7334),
	vector3(124.4729, -219.0429, 54.5577),
	vector3(248.6561, -734.7569, 32.3115),
	vector3(-249.6274, -1032.5381, 28.2207),
	vector3(-287.1396, -1114.9636, 23.0740),
	vector3(-340.7647, -1067.3652, 23.1258),
	vector3(-329.9584, -1019.1685, 30.3542)
}

local disabledSafeZonesKeys = {
	{group = 2, key = 37, message = '~r~Vous ne pouvez pas sortir d\'arme en SafeZone'},
	{group = 0, key = 24, message = '~r~Vous ne pouvez pas tirer/frapper en SafeZone'},
	{group = 0, key = 69, message = '~r~Vous ne pouvez pas tirer/frapper en SafeZone'},
	{group = 0, key = 92, message = '~r~Vous ne pouvez pas tirer/frapper en SafeZone'},
	{group = 0, key = 74, message = '~r~Vous ne pouvez pas plaquer en SafeZone'},
	{group = 0, key = 101, message = '~r~Vous ne pouvez pas plaquer en SafeZone'},
	{group = 0, key = 104, message = '~r~Vous ne pouvez pas plaquer en SafeZone'},
	{group = 0, key = 304, message = '~r~Vous ne pouvez pas plaquer en SafeZone'},
	{group = 0, key = 140, message = '~r~Vous ne pouvez pas tirer/frapper en SafeZone'},
	{group = 0, key = 106, message = '~r~Vous ne pouvez pas tirer/frapper en SafeZone'},
	{group = 0, key = 168, message = '~r~Vous ne pouvez pas utilisez votre Menu F7 en SafeZone'},
	{group = 0, key = 45, message = '~r~Vous ne pouvez pas frapper/recharger en SafeZone'},
	{group = 0, key = 160, message = '~r~Vous ne pouvez pas sortir d\'arme en SafeZone'}
}

local notifIn, notifOut = false, false
local closestZone = 1

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(500)
	end

	while true do
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local minDistance = 100000

		for i = 1, #safeZones, 1 do
			local dist = #(safeZones[i] - plyCoords)

			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end

		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(500)
	end

	while true do
		local Sleep = 5000
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local dist = #(safeZones[closestZone] - plyCoords)

		if dist <= 80 then
			Sleep = 0
			if not notifIn then
				NetworkSetFriendlyFireOption(false)
				SetCurrentPedWeapon(plyPed, `WEAPON_UNARMED`, true)
				ESX.ShowNotification('~g~Vous êtes en SafeZone')

				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
				ESX.ShowNotification('~r~Vous n\'êtes plus en SafeZone')
				notifOut = true
				notifIn = false
			end
		end

		if notifIn then
			Sleep = 0
			if (ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'vinewood' or ESX.PlayerData.job.name == 'fbi' or ESX.PlayerData.job.name == 'bcso') then
				DisablePlayerFiring(player, true)
			else
				for i = 1, #disabledSafeZonesKeys, 1 do
					DisablePlayerFiring(player, true)
					DisableControlAction(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key, true)

					if IsDisabledControlJustPressed(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key) then
						SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)

						if disabledSafeZonesKeys[i].message then
							ESX.ShowNotification(disabledSafeZonesKeys[i].message)
						end
					end
				end
			end
		end
		Wait(Sleep)
	end
end)

Citizen.CreateThread(function()
    ReplaceHudColourWithRgba(
        116,
        0,
        132,
        178,
        195  
    )
end)

Citizen.CreateThread(function()
    while true do
		local interval = 2500
		if GetSelectedPedWeapon(PlayerPedId()) == `WEAPON_UNARMED` then
			interval = 0
        	N_0x4757f00bc6323cfe(`WEAPON_UNARMED`, 0.2) 
        end

		Wait(interval)
    end
end)

function GetSafeZone()
    return notifIn
end

local tiempo = 10000
local isTaz = false
Citizen.CreateThread(function()
	while true do
        local interval = 2000
		
		if IsPedBeingStunned(PlayerPedId()) then
			
            interval = 0
			SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, 0, 0, 0)
			
		end
		
		if IsPedBeingStunned(PlayerPedId()) and not isTaz then
			
            interval = 0
			isTaz = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
			
		elseif not IsPedBeingStunned(PlayerPedId()) and isTaz then
            interval = 0 
			isTaz = false
			Wait(5000)
			
			SetTimecycleModifier("hud_def_desat_Trevor")
			
			Wait(10000)
			
            SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end

        Wait(interval)
	end
end)

RegisterCommand('+ragdoll', function()
    IsRagdollPut = not IsRagdollPut
    while IsRagdollPut do
        Wait(0)
        local plyPed = PlayerPedId()
        local entityAlpha = GetEntityAlpha(PlayerPedId())
        if entityAlpha < 100 then
            Citizen.Wait(0)
        else
            if IsRagdollPut then
                SetPedRagdollForceFall(plyPed)
                ResetPedRagdollTimer(PlayerPedId())
                SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
                ResetPedRagdollTimer(PlayerPedId())
            end
        end
    end
end, false)

RegisterKeyMapping('+ragdoll', 'S\'endormir / se réveiller', 'keyboard', 'j')

Citizen.CreateThread(function()
    while true do
        local interval = 2500
        local plyPed = PlayerPedId()

        if IsPedSittingInAnyVehicle(plyPed) then
            interval = 0
        	local plyVehicle = GetVehiclePedIsIn(plyPed, false)
        	CarSpeed = GetEntitySpeed(plyVehicle) * 3.6
        		if CarSpeed <= 60.0 then
        			if IsControlJustReleased(0, 157) then
        			SetPedIntoVehicle(plyPed, plyVehicle, -1)
        			Citizen.Wait(10)
        		end
   	    		if IsControlJustReleased(0, 158) then
        			SetPedIntoVehicle(plyPed, plyVehicle, 0)
        			Citizen.Wait(10)
        		end
        		if IsControlJustReleased(0, 160) then
        			SetPedIntoVehicle(plyPed, plyVehicle, 1)
        			Citizen.Wait(10)
        		end
        		if IsControlJustReleased(0, 164) then
        			SetPedIntoVehicle(plyPed, plyVehicle, 2)
        			Citizen.Wait(10)
        		end
        	end
        end
    
        Wait(interval)
    end
end)

local carkill = false 

Citizen.CreateThread(function()
    while true do
        if not carkill then
            Citizen.Wait(5000)
            for _,player in ipairs(GetActivePlayers()) do
                local ped = PlayerPedId()
                local everyone = GetPlayerPed(player)
                local everyoneveh = GetVehiclePedIsUsing(everyone)
                local speed = GetEntitySpeed(everyoneveh)
                if speed > 0.5 then
                    if IsPedInAnyVehicle(everyone, false) then
                        SetEntityNoCollisionEntity(ped, everyoneveh, false)
                        SetEntityNoCollisionEntity(everyoneveh, ped, false)
                    else
                        SetEntityNoCollisionEntity(ped, everyone, false)
                    end
                else
                    SetEntityNoCollisionEntity(ped, everyoneveh, true)
                    SetEntityNoCollisionEntity(everyoneveh, ped, true)
                end
            end
        else
            local ped = PlayerPedId()
            local everyone = GetPlayerPed(player)
            local everyoneveh = GetVehiclePedIsUsing(everyone)
            
            SetEntityNoCollisionEntity(ped, everyoneveh, false)
            SetEntityNoCollisionEntity(everyoneveh, ped, false)
            Wait(10000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        local roll = GetEntityRoll(vehicle)
        local interval = 2500

        if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
            interval = 0
            DisableControlAction(2,59,true)
            DisableControlAction(2,60,true)
        end

        Wait(interval)
    end
end)

local props = {
    "prop_trafficlight",
    "prop_traffic_lightset_01",
    "prop_traffic_03b",
    "prop_traffic_03a",
    "prop_traffic_02b",
    "prop_traffic_02a",
    "prop_traffic_01d",
    "prop_traffic_01b",
    "prop_traffic_01a",
    "prop_traffic_01",
    "prop_streetlight_01b",
    "prop_streetlight_01",
    "prop_streetlight_01b"
}

local trafficLightObjects = {
    [`prop_traffic_01a`] = true,
    [`prop_traffic_01b`] = true,
    [`prop_traffic_01d`] = true,
    [`prop_traffic_02a`] = true,
    [`prop_traffic_02b`] = true,
    [`prop_traffic_03a`] = true,
    [`prop_traffic_03b`] = true,
    [`prop_streetlight_01`] = true,
    [`prop_streetlight_01b`] = true,
    [`prop_streetlight_02`] = true,
    [`prop_streetlight_03`] = true,
    [`prop_streetlight_03b`] = true,
    [`prop_streetlight_03c`] = true,
    [`prop_streetlight_03d`] = true,
    [`prop_streetlight_03e`] = true,
    [`prop_streetlight_04`] = true,
    [`prop_streetlight_05`] = true,
    [`prop_streetlight_05_b`] = true,
    [`prop_streetlight_06`] = true,
    [`prop_streetlight_07a`] = true,
    [`prop_streetlight_07b`] = true,
    [`prop_streetlight_08`] = true,
    [`prop_streetlight_09`] = true,
    [`prop_streetlight_10`] = true,
    [`prop_streetlight_11a`] = true,
    [`prop_streetlight_11b`] = true,
    [`prop_streetlight_11c`] = true,
    [`prop_streetlight_12a`] = true,
    [`prop_streetlight_12b`] = true,
    [`prop_streetlight_14a`] = true,
    [`prop_streetlight_15a`] = true,
    [`prop_trafficlight`] = true,
    [`prop_traffic_lightset_01`] = true,
    [`prop_streetlight_16a`] = true,
    [-97646180] = true,
}

local blockNetworkingModels = {
    [`prop_streetlight_01`] = "prop_streetlight_01",
    [`prop_streetlight_01b`] = "prop_streetlight_01b",
    [`prop_streetlight_02`] = "prop_streetlight_02",
    [`prop_streetlight_03`] = "prop_streetlight_03",
    [`prop_streetlight_03b`] = "prop_streetlight_03b",
    [`prop_streetlight_03c`] = "prop_streetlight_03c",
    [`prop_streetlight_03d`] = "prop_streetlight_03d",
    [`prop_streetlight_03e`] = "prop_streetlight_03e",
    [`prop_streetlight_04`] = "prop_streetlight_04",
    [`prop_streetlight_05`] = "prop_streetlight_05",
    [`prop_streetlight_05_b`] = "prop_streetlight_05_b",
    [`prop_streetlight_06`] = "prop_streetlight_06",
    [`prop_streetlight_07a`] = "prop_streetlight_07a",
    [`prop_streetlight_07b`] = "prop_streetlight_07b",
    [`prop_streetlight_08`] = "prop_streetlight_08",
    [`prop_streetlight_09`] = "prop_streetlight_09",
    [`prop_streetlight_10`] = "prop_streetlight_10",
    [`prop_streetlight_11a`] = "prop_streetlight_11a",
    [`prop_streetlight_11b`] = "prop_streetlight_11b",
    [`prop_streetlight_11c`] = "prop_streetlight_11c",
    [`prop_streetlight_12a`] = "prop_streetlight_12a",
    [`prop_streetlight_12b`] = "prop_streetlight_12b",
    [`prop_streetlight_14a`] = "prop_streetlight_14a",
    [`prop_streetlight_15a`] = "prop_streetlight_15a",
    [`prop_streetlight_16a`] = "prop_streetlight_16a",

    [`prop_traffic_01a`] = "prop_traffic_01a",
    [`prop_traffic_01b`] = "prop_traffic_01b",
    [`prop_traffic_01d`] = "prop_traffic_01d",
    [`prop_traffic_02a`] = "prop_traffic_02a",
    [`prop_traffic_02b`] = "prop_traffic_02b",
    [`prop_traffic_03a`] = "prop_traffic_03a",
    [`prop_traffic_03b`] = "prop_traffic_03b",

    [`prop_dumpster_01a`] = "prop_dumpster_01a",
    [`prop_dumpster_02a`] = "prop_dumpster_02a",
    [`prop_dumpster_02b`] = "prop_dumpster_02b",
    [`prop_dumpster_03a`] = "prop_dumpster_03a",
    [`prop_dumpster_04a`] = "prop_dumpster_04a",
    [`prop_dumpster_04b`] = "prop_dumpster_04b",

    [`prop_news_disp_02c`] = "prop_news_disp_02c",
    [`prop_phonebox_03`] = "prop_phonebox_03",
    [`prop_news_disp_05a`] = "prop_news_disp_05a",
    [`prop_news_disp_02e`] = "prop_news_disp_02e",
    [`prop_news_disp_03c`] = "prop_news_disp_03c",
    [`prop_gas_smallbin01`] = "prop_gas_smallbin01",
    [`prop_parknmeter_01`] = "prop_parknmeter_01",
    [`prop_news_disp_06a`] = "prop_news_disp_06a",
    [`prop_news_disp_02a`] = "prop_news_disp_02a",
    [`prop_news_disp_02d`] = "prop_news_disp_02d",
    [`prop_phonebox_01c`] = "prop_phonebox_01c",
    [`prop_postbox_01a`] = "prop_postbox_01a",
    [`prop_fire_hydrant_2_l1`] = "prop_fire_hydrant_2_l1",
    [`prop_fire_hydrant_1`] = "prop_fire_hydrant_1",
    [`prop_parkingpay`] = "prop_parkingpay",
    [`prop_valet_03`] = "prop_valet_03",
    [`prop_news_disp_02b`] = "prop_news_disp_02b",
    [`prop_fire_hydrant_4`] = "prop_fire_hydrant_4",
    [`prop_postbox_ss_01a`] = "prop_postbox_ss_01a",
    [`prop_phonebox_01b`] = "prop_phonebox_01b",
    [`prop_news_disp_01a`] = "prop_news_disp_01a",
    [`prop_news_disp_03a`] = "prop_news_disp_03a",
    [`prop_parknmeter_02`] = "prop_parknmeter_02",
    [`prop_fire_hydrant_2`] = "prop_fire_hydrant_2",
    [`prop_bin_07b`] = "prop_bin_07b",
    [`prop_recyclebin_04_a`] = "prop_recyclebin_04_a",
    [`prop_recyclebin_02_c`] = "prop_recyclebin_02_c",
    [`zprop_bin_01a_old`] = "zprop_bin_01a_old",
    [`prop_recyclebin_03_a`] = "prop_recyclebin_03_a",
    [`prop_bin_07c`] = "prop_bin_07c",
    [`prop_bin_10b`] = "prop_bin_10b",
    [`prop_bin_10a`] = "prop_bin_10a",
    [`prop_recyclebin_02b`] = "prop_recyclebin_02b",
    [`prop_bin_08a`] = "prop_bin_08a",
    [`prop_recyclebin_04_b`] = "prop_recyclebin_04_b",
    [`prop_bin_02a`] = "prop_bin_02a",
    [`prop_bin_03a`] = "prop_bin_03a",
    [`prop_recyclebin_02_d`] = "prop_recyclebin_02_d",
    [`prop_bin_08open`] = "prop_bin_08open",
    [`prop_bin_12a`] = "prop_bin_12a",
    [`prop_recyclebin_02a`] = "prop_recyclebin_02a",
    [`prop_bin_05a`] = "prop_bin_05a",
    [`prop_bin_07a`] = "prop_bin_07a",
    [`prop_recyclebin_01a`] = "prop_recyclebin_01a",
    [`prop_elecbox_02b`] = "prop_elecbox_02b",
    [`prop_elecbox_02a`] = "prop_elecbox_02a",
    [`prop_phonebox_04`] = "prop_phonebox_04",
	[`prop_bikerack_1a`] = "prop_bikerack_1a",
	[`prop_elecbox_04a`] = "prop_elecbox_04a",

}

local attachedObjects = {
    [`prop_ld_flow_bottle`] = true,
    [`prop_cs_burger_01`] = true,
    [`prop_cs_hand_radio`] = true,
    [`prop_tool_broom`] = true,
    [`bkr_prop_coke_spatula_04`] = true,
    [-2054442544] = true,
    [`ba_prop_battle_glowstick_01`] = true,
    [`ba_prop_battle_hobby_horse`] = true,
    [`p_amb_brolly_01`] = true,
    [`prop_notepad_01`] = true,
    [`hei_prop_heist_box`] = true,
    [`prop_single_rose`] = true,
    [`prop_cs_ciggy_01`] = true,
    [`hei_heist_sh_bong_01`] = true,
    [`prop_ld_suitcase_01`] = true,
    [`prop_security_case_01`] = true,
    [`prop_tool_pickaxe`] = true,
    [`p_amb_coffeecup_01`] = true,
    [`prop_police_id_board`] = true,
    [`prop_drink_whisky`] = true,
    [`prop_amb_beer_bottle`] = true,
    [`prop_plastic_cup_02`] = true,
    [`prop_amb_donut`] = true,
    [`prop_sandwich_01`] = true,
    [`prop_ecola_can`] = true,
    [`prop_choc_ego`] = true,
    [`prop_drink_redwine`] = true,
    [`prop_champ_flute`] = true,
    [`prop_drink_champ`] = true,
    [`prop_cigar_02`] = true,
    [`prop_cigar_01`] = true,
    [`prop_acc_guitar_01`] = true,
    [`prop_el_guitar_01`] = true,
    [`prop_el_guitar_03`] = true,
    [`prop_novel_01`] = true,
    [`prop_snow_flower_02`] = true,
    [`v_ilev_mr_rasberryclean`] = true,
    [`p_michael_backpack_s`] = true,
    [`p_amb_clipboard_01`] = true,
    [`prop_tourist_map_01`] = true,
    [`prop_beggers_sign_03`] = true,
    [`prop_anim_cash_pile_01`] = true,
    [`prop_pap_camera_01`] = true,
    [`ba_prop_battle_champ_open`] = true,
    [`p_cs_joint_02`] = true,
    [`prop_amb_ciggy_01`] = true,
    [`prop_ld_case_01`] = true,
    [`w_ar_carbinerifle`] = true,
    [`w_ar_assaultrifle`] = true,
    [`w_sb_smg`] = true,
    [`w_me_poolcue`] = true,
    [`prop_golf_iron_01`] = true,
    [`w_me_bat`] = true,
    [`bkr_prop_fakeid_binbag_01`] = true,
    [`hei_prop_heist_binbag`] = true,
    [`prop_rub_tyre_01`] = true,
    [`prop_bongos_01`] = true,
}

local visibleObjects = {
    [`p_parachute1_mp_s`] = true
}

Citizen.CreateThread(function()
    local GetEntityModel, SetEntityInvincible = GetEntityModel, SetEntityInvincible
    while true do
        DisablePlayerVehicleRewards(PlayerId())
        local objects = GetGamePool("CObject")
        local count = 0
        for i=1, #objects do
            if count > 5 then
                count = 0
                Citizen.Wait(50)
            end
            count = count + 1
            local model = GetEntityModel(objects[i])
            if trafficLightObjects[model] then
                SetEntityInvincible(objects[i], true)
                FreezeEntityPosition(objects[i], true)
            end
            if model == -1581502570 or model == 1129053052 then
                ESX.Game.DeleteObject(objects[i])
                Citizen.Wait(1000)
            end
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    local GetEntityModel, SetEntityInvincible = GetEntityModel, SetEntityInvincible
    while true do
        DisablePlayerVehicleRewards(PlayerId())
        local objects = GetGamePool("CObject")
        local count = 0
        for i=1, #objects do
            if count > 5 then
                count = 0
                Citizen.Wait(50)
            end
            count = count + 1
            local model = GetEntityModel(objects[i])
            if blockNetworkingModels[model] then
                SetEntityInvincible(objects[i], true)
                FreezeEntityPosition(objects[i], true)
            end
            if model == -1581502570 or model == 1129053052 then
                ESX.Game.DeleteObject(objects[i])
                Citizen.Wait(1000)
            end
        end
        Citizen.Wait(1000)
    end
end)