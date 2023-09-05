TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('freetz:achat:ikea')
AddEventHandler('freetz:achat:ikea', function(item)
	local xPlayer  = ESX.GetPlayerFromId(source)

	if item == 'boombox' then
		prix = 1500

		if xPlayer.getAccount('cash').money >= prix then
			if xPlayer.canCarryItem(item, 1) then
				xPlayer.addInventoryItem(item, 1)
				xPlayer.removeAccountMoney('cash', prix)
				xPlayer.showNotification('~g~Vous avez effectué votre achat !')
			else
				xPlayer.ShowNotification("~r~Vous n\'avez pas assez d\'espace sur vous !")
			end
		else
			xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
		end
		
	elseif item == 'canape' then
		prix = 850

		if xPlayer.getAccount('cash').money >= prix then
			if xPlayer.canCarryItem(item, 1) then
				xPlayer.addInventoryItem(item, 1)
				xPlayer.removeAccountMoney('cash', prix)
				xPlayer.showNotification('~g~Vous avez effectué votre achat !')
			else
				xPlayer.ShowNotification("~r~Vous n\'avez pas assez d\'espace sur vous !")
			end
		else
			xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
		end

	elseif item == 'chaise' then
		prix = 800

		if xPlayer.getAccount('cash').money >= prix then
			if xPlayer.canCarryItem(item, 1) then
				xPlayer.addInventoryItem(item, 1)
				xPlayer.removeAccountMoney('cash', prix)
				xPlayer.showNotification('~g~Vous avez effectué votre achat !')
			else
				xPlayer.ShowNotification("~r~Vous n\'avez pas assez d\'espace sur vous !")
			end
		else
			xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
		end

	elseif item == 'grillage' then
		prix = 8000

		if xPlayer.getAccount('cash').money >= prix then
			if xPlayer.canCarryItem(item, 1) then
				xPlayer.addInventoryItem(item, 1)
				xPlayer.removeAccountMoney('cash', prix)
				xPlayer.showNotification('~g~Vous avez effectué votre achat !')
			else
				xPlayer.ShowNotification("~r~Vous n\'avez pas assez d\'espace sur vous !")
			end
		else
			xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
		end

	elseif item == 'table' then
		prix = 500

		if xPlayer.getAccount('cash').money >= prix then
			if xPlayer.canCarryItem(item, 1) then
				xPlayer.addInventoryItem(item, 1)
				xPlayer.removeAccountMoney('cash', prix)
				xPlayer.showNotification('~g~Vous avez effectué votre achat !')
			else
				ESX.ShowNotification("~r~Vous n\'avez pas assez d\'espace sur vous !")
			end
		else
			xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
		end

	elseif item == 'television' then
		prix = 5000

		if xPlayer.getAccount('cash').money >= prix then
			if xPlayer.canCarryItem(item, 1) then
				xPlayer.addInventoryItem(item, 1)
				xPlayer.removeAccountMoney('cash', prix)
				xPlayer.showNotification('~g~Vous avez effectué votre achat !')
			else
				xPlayer.ShowNotification("~r~Vous n\'avez pas assez d\'espace sur vous !")
			end
		else
			xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
		end

	elseif item == 'tente' then
		prix = 7000
		if xPlayer.getAccount('cash').money >= prix then
			if xPlayer.canCarryItem(item, 1) then
				xPlayer.addInventoryItem(item, 1)
				xPlayer.removeAccountMoney('cash', prix)
				xPlayer.showNotification('~g~Vous avez effectué votre achat !')
			else
				xPlayer.ShowNotification("~r~Vous n\'avez pas assez d\'espace sur vous !")
			end
		else
			xPlayer.showNotification("~r~Vous n\'avez pas assez d\'argent !")
		end

	else
		DropPlayer(source, "Tentative de cheat ou désyncronisation avec le serveur ! [discord.gg/freetz]")
	end
end)