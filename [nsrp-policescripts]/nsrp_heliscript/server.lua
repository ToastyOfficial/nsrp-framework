local spotlightInUse = false

RegisterNetEvent('s:spotActivated')
AddEventHandler('s:spotActivated', function(location, user)
  spotlightInUse = true
  print("User = " .. user)
  TriggerClientEvent('c:serverSpotEnabled', -1, location, user)
end)

RegisterNetEvent('s:spotDeactivated')
AddEventHandler('s:spotDeactivated', function()
  spotlightInUse = false
  TriggerClientEvent('c:serverSpotDisabled', -1)
end)

-- update spotlight on clients
RegisterNetEvent('s:updateSpotlight')
AddEventHandler('s:updateSpotlight', function(forVec)
  TriggerClientEvent('c:updateSpotlight', -1, forVec)
end)
