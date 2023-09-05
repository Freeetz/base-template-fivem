
local config = {
    Heading = 219.18060302734,
    pedHash = "s_m_y_construct_01",
    AuTravaillebucheron = false,
    ArgentMin = 120,
    ArgentMax = 150,
}



RegisterNetEvent("aJobs:bucheronAntiDump")
AddEventHandler("aJobs:bucheronAntiDump", function()
    TriggerClientEvent("aJobs:bucheronAntiDump", source, config, WorkerChillPos, WorkerWorkingPos)
end)

RegisterNetEvent("Bucheron:Freetz")
AddEventHandler("Bucheron:Freetz", function()
    local resultat = math.random(1, 5)
    local xPlayer = ESX.GetPlayerFromId(source)

    if resultat == 3 then 
        xPlayer.addInventoryItem('bois', 1)
        xPlayer.showNotification("Vous avez gagner ~y~x1~b~ bois~s~ !")
    end
end)