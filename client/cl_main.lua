local travelCoords = {
    walking = nil,
    horseBack = nil
}

local travelDistance = {
    walking = 0,
    horseBack = 0
}

local killsWithWeapon = {
    bow = 0,
    pistol = 0,
    repeater = 0
}

local playerSpawned = true

AddEventHandler("playerSpawned", function()
    playerSpawned = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local event = events.getEventData("EVENT_NETWORK_DAMAGE_ENTITY")
        if event then
            handlePlayerKills(event)
        end

        if playerSpawned == true then
            handlePlayerTravel()
        end
    end
end)

function handlePlayerKills(entityDamagedEvent)
    local playerPed = GetPlayerPed()
    local victimId = entityDamagedEvent["damaged entity id"]

    if entityDamagedEvent["killer entity id"] == playerPed then
        local victimHuman = IsPedHuman(victimId)
        local victimDead = IsEntityDead(victimId)

        if victimHuman and victimDead then
            local weaponHash = entityDamagedEvent[5]
            local isBow = Citizen.InvokeNative(0xC4DEC3CA8C365A5D, weaponHash)
            local isRepeater = Citizen.InvokeNative(0xDDB2578E95EF7138, weaponHash)
            local isPistol = Citizen.InvokeNative(0xDDC64F5E31EEDAB6, weaponHash)

            if isBow == 1 then
                killsWithWeapon.bow = killsWithWeapon.bow + 1
                notifyProgress("Bow", killsWithWeapon.bow)
            elseif isRepeater == 1 then
                killsWithWeapon.repeater = killsWithWeapon.repeater + 1
                notifyProgress("Repeater", killsWithWeapon.repeater)
            elseif isPistol == 1 then
                killsWithWeapon.pistol = killsWithWeapon.pistol + 1
                notifyProgress("Pistol", killsWithWeapon.pistol)
            end
        end
    end
end

function handlePlayerTravel()
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

function updateCoordsTable(key, value)
    for k, v in pairs(travelCoords) do
        travelCoords[k] = nil
    end

    travelCoords[key] = value
end

function notifyProgress(label, value)
    local text = string.format("" .. label .. ": %d", value)
    TriggerEvent("redem_roleplay:ShowSimpleRightText", text, 4000)
end

RegisterNetEvent("jtmcraft:awards")
AddEventHandler("jtmcraft:awards", function()
    notifyProgress("foo", 69)
end)
