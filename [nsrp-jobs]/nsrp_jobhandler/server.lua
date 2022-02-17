
RegisterNetEvent('jobs:getLevel')
AddEventHandler('jobs:getLevel', function(source)
  local level = 1
  --print("Source: " .. source)
  local level = exports.nsrp_xp:getPlayerLevel(source, function(level)
    return level
  end)
  --print("Fishing got level: " .. level)
  TriggerClientEvent('recPlayerLevel', source, level)
end)

RegisterNetEvent('j:setJob')
AddEventHandler('j:setJob', function(job)
  local player = Entity(GetPlayerPed(source))
  player.state.job = job
  print("Player: " .. target .. " job set to " .. player.state.job)
end)

RegisterNetEvent('j:clearJob')
AddEventHandler('j:clearJob', function()
  local player = Entity(GetPlayerPed(source))
  player.state.job = 'none'
  print("Player: " .. target .. " job set to " .. player.state.job)
end)
