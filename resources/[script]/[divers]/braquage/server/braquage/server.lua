

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local housesStates = {}

Citizen.CreateThread(function()
    for _,house in pairs(robberiesConfiguration.houses) do
        table.insert(housesStates, {state = true, robbedByID = nil})
    end
end)

RegisterNetEvent("Freetz Commu_braquage:houseRobbed")
AddEventHandler("Freetz Commu_braquage:houseRobbed",function(houseID)
    local _src = source
    housesStates[houseID].state = false
    housesStates[houseID].robbedByID = _src
    sendToDiscordWithSpecialURL("Cambriolages","**"..GetPlayerName(_src).."** cambriole la maison n°"..houseID.." ("..robberiesConfiguration.houses[houseID].name..") !",16711680,"https://discord.com/api/webhooks/1075381500750610542/8goI5fVuRHugn2J27Pa-64X1LjYUZ2leNbtjn-MOy5ZSfRdpn26gVLMTy_UISxg9m-wG")
    Citizen.SetTimeout((1000*60)*robberiesConfiguration.houseRobRegen, function()
        housesStates[houseID].state = true
        housesStates[houseID].robbedByID = nil
    end)
end)

RegisterNetEvent("Freetz Commu_bijouterie:houseRobbed")
AddEventHandler("Freetz Commu_bijouterie:houseRobbed",function(houseID)
    local _src = source
    housesStates[houseID].state = false
    housesStates[houseID].robbedByID = _src
    sendToDiscordWithSpecialURL("Cambriolages","**"..GetPlayerName(_src).."** cambriole la maison n°"..houseID.." ("..bijouterie.houses[houseID].name..") !",16711680,"https://discord.com/api/webhooks/1075381500750610542/8goI5fVuRHugn2J27Pa-64X1LjYUZ2leNbtjn-MOy5ZSfRdpn26gVLMTy_UISxg9m-wG")
    Citizen.SetTimeout((1000*60)*bijouterie.houseRobRegen, function()
        housesStates[houseID].state = true
        housesStates[houseID].robbedByID = nil
    end)
end)

RegisterNetEvent("Freetz Commu_braquage:callThePolice")
AddEventHandler("Freetz Commu_braquage:callThePolice", function(houseIndex)
    local authority = robberiesConfiguration.houses[houseIndex].authority
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' or xPlayer.job.name == 'vinewood' or xPlayer.job.name == 'fbi' then
            TriggerClientEvent("Freetz Commu_braquage:initializePoliceBlip",xPlayers[i], houseIndex, robberiesConfiguration.houses[houseIndex].policeBlipDuration)
        end
    end
end)

RegisterNetEvent("Freetz Commu_bijouterie:callThePolice")
AddEventHandler("Freetz Commu_bijouterie:callThePolice", function(houseIndex)
    local authority = bijouterie.houses[houseIndex].authority
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' or xPlayer.job.name == 'vinewood' or xPlayer.job.name == 'fbi' then
            TriggerClientEvent("Freetz Commu_braquage:initializePoliceBlipx",xPlayers[i], houseIndex, bijouterie.houses[houseIndex].policeBlipDuration)
        end
    end
end)



RegisterNetEvent("Freetz Commu_braquage:reward") -- TODO SECURISER
AddEventHandler("Freetz Commu_braquage:reward", function(reward)
    local _src = source
    sendToDiscordWithSpecialURL("Cambriolages","**"..GetPlayerName(_src).."** à reçu __"..reward.."__$ pour son cambriolage.",16744192,"https://discord.com/api/webhooks/1075381500750610542/8goI5fVuRHugn2J27Pa-64X1LjYUZ2leNbtjn-MOy5ZSfRdpn26gVLMTy_UISxg9m-wG")
end)

RegisterNetEvent("Freetz Commu_bijouterie:reward") -- TODO SECURISER
AddEventHandler("Freetz Commu_bijouterie:reward", function(reward)
    local _src = source
    sendToDiscordWithSpecialURL("Bijouterie","**"..GetPlayerName(_src).."** à reçu __"..reward.."__$ pour son cambriolage de bijouterie.",16744192,"https://discord.com/api/webhooks/1075381500750610542/8goI5fVuRHugn2J27Pa-64X1LjYUZ2leNbtjn-MOy5ZSfRdpn26gVLMTy_UISxg9m-wG")
end)

RegisterNetEvent("Freetz Commu_bijouterie:money") -- TODO SECURISER
AddEventHandler("Freetz Commu_bijouterie:money", function(reward)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
--    local bijoux = reward

    xPlayer.addInventoryItem('bijoux', reward)
    TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "CAMBRIOLAGE", "Bijoux Reçu","Félicitation vous avez reçu : ~b~"..reward.."~s~ bijoux ! Pour votre braquage de ~o~Bijouterie~s~ !", 'CHAR_CAMBRIOLAGE', 9, 18)
end)
RegisterNetEvent("Freetz Commu_braquage:money") -- TODO SECURISER
AddEventHandler("Freetz Commu_braquage:money", function(reward)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    
    xPlayer.addAccountMoney('dirtycash', reward)
    --TriggerClientEvent('esx:showNotification', xPlayer.source, "Félicitation vous avez reçu : ~r~"..reward.."$" )
    TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, "CAMBRIOLAGE", "Paiement Reçu","Félicitation vous avez reçu : ~g~"..reward.."$", 'CHAR_CAMBRIOLAGE', 9, 18)
end)

RegisterNetEvent("Freetz Commu_braquage:getHousesStates")
AddEventHandler("Freetz Commu_braquage:getHousesStates", function()
    local _src = source
    TriggerClientEvent("Freetz Commu_braquage:getHousesStates", _src, housesStates)
end)

RegisterNetEvent("Freetz Commu_braquage:getHousesStatess")
AddEventHandler("Freetz Commu_braquage:getHousesStatess", function()
    local _src = source
    TriggerClientEvent("Freetz Commu_braquage:getHousesStatess", _src, housesStates)
end)













function sendToDiscordWithSpecialURL (name,message,color,url)
    local DiscordWebHook = "https://discord.com/api/webhooks/1051200459551019138/WeqbaPMwpTiV03xs2eU71E3TwN7qapBcATIJdleHAqzly_A0mqyT_ANe2vgK7gR2HjWz"
  
  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
          ["text"]= "Freetz CommuRP Logs - Freetz | Proposer par Freetz",
         },
      }
  }
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('freetz:getPoliceBraquo', function(source, cb)
    local keuf = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'vinewood' or xPlayer.job.name == 'usss' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'bcso' then
            keuf = keuf + 1
        end
    end
    
    if keuf <= 4 then
        cb(true)
    else
        cb(false)
    end

end)


-------- ↓ POLICE MINIMUM ↓ --------

ESX.RegisterServerCallback('freetz:bijouterie', function(source, cb)
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'bcso' or xPlayer.job.name == 'vinewood' or xPlayer.job.name == 'fbi' then
            cops = cops + 1
        end
    end
    if cops >= 4 then
        cb(true)
    else
        cb(false)
    end
end)