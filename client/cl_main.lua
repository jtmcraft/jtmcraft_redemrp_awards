local lastCoords = nil
local totalDistance = 0
local totalWalked = 0
local totalMounted = 0
local totalVehicle = 0
local playerSpawned = false

AddEventHandler("playerSpawned", function()
    lastCoords = GetEntityCoords(PlayerPedId())
    totalDistance = 0
    playerSpawned = true
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPedId = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPedId)

        if playerSpawned == true then
            local x1, y1, z1 = table.unpack(lastCoords)
            local x2, y2, z2 = table.unpack(playerCoords)
            totalDistance = totalDistance + Vdist2(x1, y1, z1, x2, y2, z2)
            lastCoords = playerCoords
        end
    end
end)

function notifyDistance()
    local text = string.format("Distance: %.2f", totalDistance)
    TriggerEvent("redem_roleplay:ShowSimpleRightText", text, 4000)
end

RegisterNetEvent("jtmcraft:awards")
AddEventHandler("jtmcraft:awards", function()
    notifyDistance()
end)
