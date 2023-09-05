ESX = nil

if ConfigEssence.UseESX then
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)

		if price > 0 then
			xPlayer.removeAccountMoney('cash', amount)
		end
	end)
end

RegisterNetEvent('freetz:give-essence')
AddEventHandler('freetz:give-essence', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 500

    if xPlayer.hasWeapon('WEAPON_PETROLCAN') then
		TriggerClientEvent('esx:showNotification', source, "Vous avez déjà un ~r~Bidon D\'essence~s~.")
	else
        --xPlayer.removeAccountMoney('cash', price)
        xPlayer.addWeapon('WEAPON_PETROLCAN', 250)
        TriggerClientEvent('esx:showNotification', source, "Vous venez d\'achetez ~o~x1 Bidon D\'essence~s~ !")
    end
end)
