local travelCoords = {
    walking = nil,
    horseBack = nil
}

local travelDistance = {
    walking = 0,
    horseBack = 0
}

local playerSpawned = true

RegisterNetEvent("jtmcraft:start_awards_thread")
AddEventHandler("playerSpawned", function()
    playerSpawned = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if playerSpawned == true then
            local playerPed = PlayerPedId()
            local onFoot = IsPedOnFoot(playerPed)
            local onHorseBack = IsPedOnMount(playerPed)
            local playerCoords = GetEntityCoords(playerPed)
            local x1, y1, z1 = table.unpack(playerCoords)

            if onFoot == 1 then
                if travelCoords.walking ~= nil then
                    local x2, y2, z2 = table.unpack(travelCoords.walking)
                    travelDistance.walking = travelDistance.walking + Vdist2(x1, y1, z1, x2, y2, z2)
                end
                updateCoordsTable("walking", playerCoords)
            elseif onHorseBack == 1 then
                if travelCoords.horseBack ~= nil then
                    local x2, y2, z2 = table.unpack(travelCoords.horseBack)
                    travelDistance.horseBack = travelDistance.horseBack + Vdist2(x1, y1, z1, x2, y2, z2)
                end
                updateCoordsTable("horseBack", playerCoords)
            end
        end
    end
end)

function updateCoordsTable(key, value)
    for k, v in pairs(travelCoords) do
        travelCoords[k] = nil
    end

    travelCoords[key] = value
end

function notifyDistance()
    local walkingText = string.format("Walking: %.2f", travelDistance.horseBack)
    TriggerEvent("redem_roleplay:ShowSimpleRightText", walkingText, 4000)
end

RegisterNetEvent("jtmcraft:awards")
AddEventHandler("jtmcraft:awards", function()
    notifyDistance()
end)
