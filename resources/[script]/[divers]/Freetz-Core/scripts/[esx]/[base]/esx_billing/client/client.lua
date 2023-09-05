ESX = nil 
local IsSpawned = true

CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Wait(0)
	end
end)

billingCount = {}
AddEventHandler('playerSpawned', function()
    if IsSpawned then
        IsSpawned = false
        ESX.TriggerServerCallback('Freetz:FactureListe', function(bills) 
            billingCount = bills 
        end)

	    Wait(4000)

        if #billingCount >= 5 then 
            ESX.ShowNotification("~r~Si vous possédez plus de ~g~20~r~ factures impayées, vous serez whype automatiquement !!!")
            ESX.ShowNotification(("Vous possédez actuellement ~y~%s~s~ facture(s) en attente de paiement."):format(#billingCount))
        end

        Wait(1000)

        if #billingCount >= 20 then
            TriggerServerEvent("Freetz:Whype")
        end
    end
end)