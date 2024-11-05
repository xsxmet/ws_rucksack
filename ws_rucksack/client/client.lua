Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        Citizen.Wait(0)
    end

    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(1000)
    end

    Citizen.Wait(5000)

    if ESX.IsPlayerLoaded() then 
        TriggerServerEvent("ws_rucksack:onJoin")
    end
end)
