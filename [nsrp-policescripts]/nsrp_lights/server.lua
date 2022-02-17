GlobalState.mode = 'open'

RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function()

  TriggerClientEvent('el:checkVehicle', source)
end)

RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function()

  TriggerClientEvent('el:cleanupHUD', source)
end)
