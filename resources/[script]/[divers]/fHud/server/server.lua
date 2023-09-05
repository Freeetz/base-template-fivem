local login = false -- PREVENTS HUD FROM VIEWING WITHOUT SELECTING THE PLAYER CHARACTER -- 

if Config.Framework == "esx" then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
elseif Config.Framework == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()
end

if Config.UseCarHud then
    -- EJECTS EACH PLAYER FROM THE CAR --
    RegisterServerEvent('Freetz-OtoSchool:server:EjectPlayer')
    AddEventHandler('Freetz-OtoSchool:server:EjectPlayer', function(table, velocity)
    for i=1, #table do
            if table[i] then
                TriggerClientEvent("Freetz-OtoSchool:client:EjectPlayer", table[i], velocity)
            end
        end
    end)
end

if Config.UsePlayerStats then
    -- GETS PLAYER PING --
    RegisterServerEvent("Freetz-OtoSchool:server:GetPlayerPing", function()
        local src = source
        local PlayerPing = GetPlayerPing(src)
        TriggerClientEvent("Freetz-OtoSchool:client:GetPlayerPing", src, PlayerPing)
    end)


    if Config.Framework == "esx" then
        -- GETS PLAYER MONEY FOR ESX --
        RegisterServerEvent("Freetz-OtoSchool:server:GetPlayerMoney", function()
            local src = source
            local xPlayer = ESX.GetPlayerFromId(src)
            if not xPlayer then return end
            local PlayerBank = xPlayer.getAccount('bank').money
            local PlayerCash = xPlayer.getAccount('cash').money
    
            TriggerClientEvent("Freetz-OtoSchool:client:GetPlayerMoney", src, PlayerCash, PlayerBank)
        end)
    elseif Config.Framework == "qb" then
        -- GETS PLAYER MONEY FOR QBCORE --
        RegisterServerEvent("Freetz-OtoSchool:server:GetPlayerMoney", function()
            local src = source
            local xPlayer = QBCore.Functions.GetPlayer(src)
            if not xPlayer then return end
            local PlayerBank = xPlayer.PlayerData.money["bank"]
            local PlayerCash = xPlayer.PlayerData.money["cash"]
    
            TriggerClientEvent("Freetz-OtoSchool:client:GetPlayerMoney", src, PlayerCash, PlayerBank)
        end)
    end
end