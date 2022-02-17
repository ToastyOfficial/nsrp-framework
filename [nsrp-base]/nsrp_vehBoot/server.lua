RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function()

  local canSteal =  IsPlayerAceAllowed(source, 'can.steal')

  --print("Can steal: " .. tostring(canSteal))
  TriggerClientEvent('b:checkVehicle', source, canSteal)
end)
