ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent("aJobs:pay")
AddEventHandler("aJobs:pay", function(money)
    if money < 1000 then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("cash", money)
    else
        print("Freetz Commu | SYNCHRONISATION PERDU AVEC LE SERVEUR DU A UNE TENTATIVE DE TRICHE - MERCI DE RETIRER TOUT LOGICIEL DE TRICHE DE VOTRE JEU AVEC DE VENIR SUR LE SERVEUR")
    end
end)