TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('freetz:get:id', function(source, cb)
    local identifier = ESX.GetPlayerFromId(source).identifier

    MySQL.Async.fetchAll('SELECT identifier, character_id FROM `users` WHERE `identifier` = @identifier', {
        ['@identifier'] = identifier,
        ['@character_id'] = id
    }, function(result)

        local data = {}

        if result[1] then
            id = result[1].character_id
        end

        cb(id)

    end)
end)