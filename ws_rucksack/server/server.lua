local ESX = exports["es_extended"]:getSharedObject()
local BackPackUsed = {}
local CachedWeights = {}

Citizen.CreateThread(function()
    for _, v in ipairs(WS.BackPacks) do
        ESX.RegisterUsableItem(v["name"], function(source)
            local xPlayer = ESX.GetPlayerFromId(source)

            if xPlayer then
                local xItem = xPlayer.getInventoryItem(v["name"])
                local currWeight = xPlayer.getMaxWeight()

                if xItem and xItem.count > 0 then 
                    if BackPackUsed[xPlayer.source] then 
                        return TriggerClientEvent("ws_notify", xPlayer.source, "error", "information", "Du hast bereits einen Rucksack an", 5000)
                    end

                    CachedWeights[xPlayer.source] = currWeight
                    BackPackUsed[xPlayer.source] = true
                    xPlayer.setMaxWeight((currWeight + backpack["weight"]))
                    TriggerClientEvent("ws_notify", xPlayer.source, "error", "information", "Du hast einen Rucksack angezogen", 5000)
                end
            end
        end)
    end
end)

RegisterNetEvent("ws_rucksack:onJoin", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        for _, v in ipairs(WS.BackPacks) do
            local currWeight = xPlayer.getMaxWeight()
            local xItem = xPlayer.getInventoryItem(v["name"])

            if xItem and xItem.count > 0 then 
                BackPackUsed[xPlayer.source] = true
                CachedWeights[xPlayer.source] = currWeight
                xPlayer.setMaxWeight((currWeight + v["weight"]))
            end
        end
    end
end)

RegisterNetEvent("esx:onRemoveInventoryItem")
AddEventHandler("esx:onRemoveInventoryItem", function(source, name, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        for _, v in ipairs(WS.BackPacks) do
            if v["name"] == name and CachedWeights[xPlayer.source] ~= nil then 
                xPlayer.setMaxWeight(CachedWeights[xPlayer.source])
                CachedWeights[xPlayer.source] = nil
                BackPackUsed[xPlayer.source] = false
            end
        end
    end
end)