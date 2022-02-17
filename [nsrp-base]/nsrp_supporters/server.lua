RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function()

  local supporter =  IsPlayerAceAllowed(source, 'supporter.vehicles')

  --print("Supporter: " .. tostring(supporter))
  TriggerClientEvent('c:checkVehicle', source, supporter)
end)

RegisterCommand('supveh', function(source, args)
  local choice = args[1]
  TriggerClientEvent('spawnSupVeh', source, choice)
end, true)
