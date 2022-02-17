
GlobalState.mode = 'open'

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function()

  TriggerClientEvent('setupLightsHUD', source)
end)

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function()

  TriggerClientEvent('cleanupLightsHUD', source)
end)
