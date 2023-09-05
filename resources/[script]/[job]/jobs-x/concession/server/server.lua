TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('freetz:concess:avion')
AddEventHandler('freetz:concess:avion', function(value)

    if value == 'ouverture' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers    = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Avion', '~b~Annonce Concess Avion', 'Le ~y~Concessionnaire Avion~s~ est actuellement ~g~Ouvert~s~ !', 'CHAR_ORTEGA', 8)
        end
    elseif value == 'fermeture' then 
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers    = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Avion', '~b~Annonce Concess Avion', 'Le ~y~Concessionnaire Avion~s~ est actuellement ~r~Fermer~s~ !', 'CHAR_ORTEGA', 8)
        end
    elseif value == 'recrutement' then 
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers    = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Avion', '~b~Annonce Concess Avion', 'Le ~y~Concessionnaire Avion~s~ est actuellement à la ~b~recherche d\'employés~s~ ! Rendez-vous dans nos locaux.', 'CHAR_ORTEGA', 8)
        end
    end
end)

RegisterServerEvent('freetz:concess:voiture')
AddEventHandler('freetz:concess:voiture', function(value)

    if value == 'ouverture' then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers    = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Voiture', '~b~Annonce Concess Voiture', 'Le ~y~Concessionnaire Voiture~s~ est actuellement ~g~Ouvert~s~ !', 'CHAR_CONCESS', 8)
        end
    elseif value == 'fermeture' then 
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers    = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Voiture', '~b~Annonce Concess Voiture', 'Le ~y~Concessionnaire Voiture~s~ est actuellement ~r~Fermer~s~ !', 'CHAR_CONCESS', 8)
        end
    elseif value == 'recrutement' then 
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xPlayers    = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Concess Voiture', '~b~Annonce Concess Voiture', 'Le ~y~Concessionnaire Voiture~s~ est actuellement à la ~b~recherche d\'employés~s~ ! Rendez-vous dans nos locaux.', 'CHAR_CONCESS', 8)
        end
    end
end)