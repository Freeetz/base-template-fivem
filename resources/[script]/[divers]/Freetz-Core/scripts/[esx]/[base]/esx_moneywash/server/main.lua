ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function sendWebhook(message,color,url)
    local DiscordWebHook = url
    local embeds = {
        {
            ["title"]=message,
            ["type"]="rich",
            --["color"] =red,
            ["footer"]=  {
                ["text"]= "For Freetz Commu RolePlay - 2023/2024",
            },
        }
    }
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "Logs Blanchiment - Freetz Commu",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

--  TODO: Log to discord bot
RegisterServerEvent('esx_moneywash:cleanMoney')
AddEventHandler('esx_moneywash:cleanMoney', function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local dirtyMoney = xPlayer.getAccount("dirtycash")
    if dirtyMoney.money > 0 then
        --local cash = xPlayer.getMoney('dirtycash').money
        local cleanMoney = math.ceil(dirtyMoney.money - (dirtyMoney.money * ConfigBlanchiment.laundryTax))
        xPlayer.addAccountMoney('cash', cleanMoney)
        xPlayer.removeAccountMoney('dirtycash', dirtyMoney.money)
        sendWebhook(("L'utilisateur %s vient de blanchir ".. dirtyMoney.money .."$, et a recu en contre-partie : ".. cleanMoney .."$ !"):format(GetPlayerName(source)), "red", "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
        TriggerClientEvent('esx:showNotification', _source, 'Vous avez blanchi ~r~'..dirtyMoney.money..'$ argent sale~s~ contre ~b~'..cleanMoney..'$')
    else
        TriggerClientEvent('esx:showNotification', _source, '~r~Revien quand tu auras de l\'argent à blanchir.')
    end
end)

RegisterServerEvent('esx_moneywash:cleanMoney2')
AddEventHandler('esx_moneywash:cleanMoney2', function(target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local dirtyMoney = xPlayer.getAccount("dirtycash")
    if dirtyMoney.money > 0 then
        --local cash = xPlayer.getMoney('dirtycash').money
        local cleanMoney = math.ceil(dirtyMoney.money - (dirtyMoney.money * 0.10))
        xPlayer.addAccountMoney('cash', cleanMoney)
        xPlayer.removeAccountMoney('dirtycash', dirtyMoney.money)
        sendWebhook(("L'utilisateur %s vient de blanchir ".. dirtyMoney.money .."$, et a recu en contre-partie : ".. cleanMoney .."$ !"):format(GetPlayerName(source)), "red", "https://discord.com/api/webhooks/1147876081844621322/mflxOquSFpomBBmg8oIh1sMxjhGSxs1-8_z-O-eSAvcu7ruzjcV6KRdXX3qBCvzt13iF")
        TriggerClientEvent('esx:showNotification', _source, 'Vous avez blanchi ~r~'..dirtyMoney.money..'$ argent sale~s~ contre ~b~'..cleanMoney..'$')
    else
        TriggerClientEvent('esx:showNotification', _source, '~r~Revien quand tu auras de l\'argent à blanchir.')
    end
end)