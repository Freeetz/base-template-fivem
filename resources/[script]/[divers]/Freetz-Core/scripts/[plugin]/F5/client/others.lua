Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(2000)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
	RefreshMoney2()
end)

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		societymoney2 = ESX.Math.GroupDigits(money)
    end
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			societymoney2 = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job2.name)
	end
end

--Fonctions des accesoires 
function setAccess(value, plyPed)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:getSkin', function(skina)
            if value == 'mask' then
                if skin.mask_1 ~= skina.mask_1 then
                    ExecuteCommand("me remet son Masque")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['mask_1'] = skin.mask_1, ['mask_2'] = skin.mask_2 })
                else
                    ExecuteCommand("me retire son Masque")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['mask_1'] = 0, ['mask_2'] = 0 })
                end
            elseif value == 'chain' then
                if skin.chain_1 ~= skina.chain_1 then
                    ExecuteCommand("me remet sa Chaine")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['chain_1'] = skin.chain_1, ['chain_2'] = skin.chain_2 })
                else
                    ExecuteCommand("me retire sa Chaine")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['chain_1'] = 0, ['chain_2'] = 0 })
                end
            elseif value == 'helmet' then
                if skin.helmet_1 ~= skina.helmet_1 then
                    ExecuteCommand("me remet son Casque")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['helmet_1'] = skin.helmet_1, ['helmet_2'] = skin.helmet_2 })
                else
                    ExecuteCommand("me retire son Casque")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['helmet_1'] = -1, ['helmet_2'] = 0 })
                end
            elseif value == 'glasses' then
                if skin.glasses_1 ~= skina.glasses_1 then
                    ExecuteCommand("me retire ses Lunette")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['glasses_1'] = skin.glasses_1, ['glasses_2'] = skin.glasses_2 })
                else
                    if skin.sex == 0 then
                        ExecuteCommand("me retire ses Lunette")
                        TriggerEvent('skinchanger:loadClothes', skina, { ['glasses_1'] = 0, ['glasses_2'] = 0 })
                    else
                        TriggerEvent('skinchanger:loadClothes', skina, { ['glasses_1'] = 5, ['glasses_2'] = 0 })
                    end
                end
            elseif value == 'ears' then
                if skin.ears_1 ~= skina.ears_1 then
                    ExecuteCommand("me retire ses Boucle d'oreilles")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['ears_1'] = skin.ears_1, ['ears_2'] = skin.ears_2 })
                else
                    ExecuteCommand("me retire ses Boucle d'oreilles")
                    TriggerEvent('skinchanger:loadClothes', skina, { ['ears_1'] = 0, ['ears_2'] = 0 })
                end
            end
        end)
    end)
end

--Fonction poids
function GetCurrentWeight()
	local currentWeight = 0
	for i = 1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			currentWeight = currentWeight + (ESX.PlayerData.inventory[i].weight * ESX.PlayerData.inventory[i].count)
		end
	end
	return currentWeight
end

--Check Quantity 
function CheckQuantity(number)
    number = tonumber(number)

    if type(number) == "number" then
        number = ESX.Math.Round(number)

        if number > 0 then
            return true, number
        end
    end

    return false, number
end

--Player Marker
function PlayerMakrer(player)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    DrawMarker(2, pos.x, pos.y, pos.z+1.0, 0.0, 0.0, 0.0, 179.0, 0.0, 0.0, 0.25, 0.25, 0.25, 0, 131, 4, 200, 0, 1, 2, 1, nil, nil, 0)
end

local noir = false
RegisterCommand('noir', function()
    noir = not noir
    if noir then 
        DisplayRadar(false) 
        TriggerEvent("tempui:toggleUi", true)
        TriggerEvent('hideSoifEtFaimFDP', false)
    end
    while noir do
        if not HasStreamedTextureDictLoaded('revolutionbag') then
            RequestStreamedTextureDict('revolutionbag')
            while not HasStreamedTextureDictLoaded('revolutionbag') do
                Citizen.Wait(50)
            end
        end

        DrawSprite('revolutionbag', 'cinema', 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        Citizen.Wait(0)
    end
    DisplayRadar(true)
    TriggerEvent('hideSoifEtFaimFDP', true)
    TriggerEvent("tempui:toggleUi", false)
    SetStreamedTextureDictAsNoLongerNeeded('revolutionbag')
end)

RegisterNetEvent('framework:tp', function(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)

Citizen.CreateThread(function()
    while true do
        local xPlayer = PlayerPedId()
        local interval = 2500

        if IsPedArmed(xPlayer, 1) then
            interval = 0
    	    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.3) 
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.2) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_POOLCUE"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNUCKLE"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SWITCHBLADE"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DAGGER"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HACHETE"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BATTLEAXE"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ZIZI"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"), 0.3) 
		    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"), 0.2)
        end

        Wait(interval)
    end
end)

Rockstar = Rockstar or {}

RegisterCommand("stream",function()
    if IsRecording()
    then 
        return 
        StopRecordingAndSaveClip()
    end;
    StartRecording(1)
end)

-- DRIFT INC

local kmh = 3.6
local mph = 2.23693629
local carspeed = 0
driftmode = true -- on/off speed
local speed = kmh -- or mph
local drift_speed_limit = 150.0 

-- Thread
Citizen.CreateThread(function()
	while true do
		if IsPedInAnyVehicle(GetPed(), false) and driftmode then
			Citizen.Wait(1)
		else
			Wait(1500)
		end

		if driftmode then
			if IsPedInAnyVehicle(GetPed(), false) then
				CarSpeed = GetEntitySpeed(GetCar()) * speed
				if GetPedInVehicleSeat(GetCar(), -1) == GetPed() then
					if CarSpeed <= drift_speed_limit then  
						if IsControlPressed(1, 21) then
							SetVehicleReduceGrip(GetCar(), true)
						else
							SetVehicleReduceGrip(GetCar(), false)
						end
					end
				end
			end
		end
	end
end)


-- Function
function GetPed() return GetPlayerPed(-1) end
function GetCar() return GetVehiclePedIsIn(GetPlayerPed(-1),false) end

---------------------------- FUNCTION POUR LE DUREX --------------------------------------

RegisterNetEvent('scully:org')
AddEventHandler('scully:org', function()   
TriggerEvent("scully:black")
TriggerEvent("Ragdoll")
    ESX.ShowNotification("Vous vous déshabillez !")
    Citizen.Wait(1000)
    ESX.ShowNotification("Vous vous enfoncez le god michet.")
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'stupid1', 0.6)
	  Citizen.Wait(5000)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'stupid', 0.6)
	  Citizen.Wait(3000)
    ESX.ShowNotification("Vous avez un orgasme !")
	  Citizen.Wait(1000)
    TriggerEvent("Ragdoll")
end)

RegisterNetEvent('scully:org2')
AddEventHandler('scully:org2', function()   
   TriggerEvent("scully:black")
TriggerEvent("Ragdoll")
	Citizen.Wait(1000)
TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'stupid2', 0.6)
	Citizen.Wait(5000)
TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'stupid', 0.6)
	Citizen.Wait(3000)
  ESX.ShowNotification("Vous avez un orgasme !")
	Citizen.Wait(1000)
TriggerEvent("Ragdoll")
end)

RegisterNetEvent('scully:black')
AddEventHandler('scully:black', function()
   DoScreenFadeOut(100)
   while not IsScreenFadedOut() do
		Citizen.Wait(0)
   end
		Citizen.Wait(8000)
   DoScreenFadeIn(250)
end)

function setRagdoll(flag)
ragdoll = flag
end

CreateThread(function()
    while true do
        local interval = 2500
        if ragdoll then
            interval = 0
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
        end
        Wait(interval)
    end
end)

orgasm = true
RegisterNetEvent("Ragdoll")
AddEventHandler("Ragdoll", function()
if ( orgasm ) then
	setRagdoll(true)
	orgasm = false
else
	setRagdoll(false)
	orgasm = true
    end
end)


----------------- ↓ DESACTIVATION DES COUPS DE CROSSES (R) ↓ ---------------------

Citizen.CreateThread(function()
	while true do
        local interval = 2000

		if (not IsPedArmed(PlayerPedId(), 1)) and (GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('weapon_unarmed')) then
            interval = 5
	
			DisableControlAction(0, 140, true) 
			DisableControlAction(0, 141, true) 
			DisableControlAction(0, 142, true) 
		
		end

        Wait(interval)
	end
end)


-------------------------------------------------------------------------------