local AfkTime = {}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('requteInvestTime')
AddEventHandler('requteInvestTime', function(result)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then
        MySQL.Async.fetchAll('SELECT * FROM `eInvest` WHERE `license` = @license', {
            ['@license'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                if not AfkTime[xPlayer.source] then
                    AfkTime[xPlayer.source] = {}
                    AfkTime[xPlayer.source].time = result[1].time
                    AfkTime[xPlayer.source].type = result[1].type
                    TriggerClientEvent("requestClientAfkTime", xPlayer.source, AfkTime[xPlayer.source].time)
                    if #(GetEntityCoords(GetPlayerPed(xPlayer.source)) - eInvest.Position) < 150 then
                        SetEntityCoords(GetPlayerPed(xPlayer.source), vector3(234.1163, -762.789, 30.8331))
                    end
                    --TriggerClientEvent("esx:showNotification", source,'Vous avez un investissement en cours.\nIl vous reste ~b~'..result[1].time..' ~s~minutes pour le finir.')
                end
            else
                AfkTime[xPlayer.source] = {}
                AfkTime[xPlayer.source].time = 0
                AfkTime[xPlayer.source].type = 0
                if #(GetEntityCoords(GetPlayerPed(xPlayer.source)) - eInvest.Position) < 150 then
                    TriggerClientEvent("esx:showNotification", source,'Vous êtes dans la zone Investissement alors que vous n\'avez pas d\'investissement.')
                    SetEntityCoords(GetPlayerPed(xPlayer.source), einvest.ReturnPosition)
                end
            end
        end)
    end
end)

RegisterNetEvent('GoInvest')
AddEventHandler('GoInvest', function(result)
    local xPlayer = ESX.GetPlayerFromId(source)
    local type = result
    local time = eInvest.InvestReward[type].heures 
    
    --if xPlayer.getMoney('bank').money >= eInvest.InvestReward[type].invest then 
    --    xPlayer.removeMoney(eInvest.InvestReward[type].invest)
    --    AfkTime[xPlayer.source].time = eInvest.InvestReward[type].heures*60
    --    AfkTime[xPlayer.source].type = type
    --    SetEntityCoords(GetPlayerPed(xPlayer.source), eInvest.Position)
    --    TriggerClientEvent("requestClientAfkTime", xPlayer.source, AfkTime[xPlayer.source].time)
    --    TriggerClientEvent("esx:showNotification", source,'Tu as lancer un investissement pour gagner ~b~'..eInvest.InvestReward[type].reward..' ~s~pour ~b~'..eInvest.InvestReward[type].heures..' ~s~heures')
     if xPlayer.getAccount('bank').money >= eInvest.InvestReward[type].invest then
        xPlayer.removeAccountMoney('bank', eInvest.InvestReward[type].invest)
        AfkTime[xPlayer.source].time = eInvest.InvestReward[type].heures*60
        AfkTime[xPlayer.source].type = type
        SetEntityCoords(GetPlayerPed(xPlayer.source), eInvest.Position)
        TriggerClientEvent("requestClientAfkTime", xPlayer.source, AfkTime[xPlayer.source].time)
        TriggerClientEvent("esx:showNotification", source,'Tu as lancer un investissement pour gagner ~b~'..eInvest.InvestReward[type].reward..' ~s~pour ~b~'..eInvest.InvestReward[type].heures..' ~s~heurs')
    else
        TriggerClientEvent("esx:showNotification", source,'Vous n\'avez pas l\'argent nécéssaire')
    end
end)

RegisterNetEvent('UpdateAfkTick')
AddEventHandler('UpdateAfkTick', function(result)
    local xPlayer = ESX.GetPlayerFromId(source)
    if AfkTime[xPlayer.source].time-1 == result then
        AfkTime[xPlayer.source].time = result
        if AfkTime[xPlayer.source].time == 0 then
            TriggerClientEvent("esx:showNotification", source,'Vous avez terminé votre investissement félication !\nVous avez gagner ~g~'..eInvest.InvestReward[AfkTime[xPlayer.source].type].reward..'~s~$\n~g~/invest ~s~pour relancer un investissement')
            xPlayer.addAccountMoney('cash', eInvest.InvestReward[AfkTime[xPlayer.source].type].reward)
            MySQL.Async.execute('DELETE FROM eInvest WHERE `license` = @license', {
                ['@license'] = xPlayer.identifier
            })
            AfkTime[xPlayer.source] = {}
            TriggerClientEvent("requestClientAfkTime", xPlayer.source, 0)
            SetEntityCoords(GetPlayerPed(xPlayer.source), eInvest.ReturnPosition)
        end
    else
        DropPlayer(source, 'Désynchronisation avec le serveur ou detection de Cheat')
    end
end)

AddEventHandler('playerDropped', function (reason)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    

    if xPlayer == nil then
        --print('Aucun joueur détecter')
    else
        if AfkTime[xPlayer.source] == nil or AfkTime[xPlayer.source] == '' then
            return
        else
            if AfkTime[xPlayer.source].time >= 1 then
                MySQL.Async.fetchAll('SELECT * FROM `eInvest` WHERE `license` = @license', {
                    ['@license'] = xPlayer.identifier
                }, function(result)
                    if result[1] then
                        MySQL.Async.execute('UPDATE eInvest SET time = @time, type = @type WHERE license = @license',{
                            ['@license'] = xPlayer.identifier,
                            ['@time'] = AfkTime[xPlayer.source].time,
                            ['@type'] = AfkTime[xPlayer.source].type,
                        })
                    else
                        MySQL.Async.execute('INSERT INTO eInvest (license, time, type) VALUES (@license, @time, @type)', {
                            ['@license'] = xPlayer.identifier,
                            ['@time'] = AfkTime[xPlayer.source].time,
                            ['@type'] = AfkTime[xPlayer.source].type,
                        }, function()
                        end)
                    end
                end)
            end
        end
    end
end)


--[[Citizen.CreateThread(function()
    while true do
        Wait(60000*90)
        TriggerClientEvent(eInvest.TriggersNotification, -1, eInvest.ServerName, eInvest.TitleNotification, eInvest.NotificationTimerMessage, eInvest.CharNotification, 7)
    end
end)--]]