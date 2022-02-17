RegisterNetEvent('postal:xp')
AddEventHandler('postal:xp', function(target, amount)
  print("^6Granting ID: " .. target .. ' with ' .. amount .. ' xp.')

  exports.nsrp_xp:addXP(target, amount)
end)

RegisterNetEvent('postal:getLevel')
AddEventHandler('postal:getLevel', function(source)
  local level = 1
  --print("Source: " .. source)
  local level = exports.nsrp_xp:getPlayerLevel(source, function(level)
    return level
  end)
  --print("Fishing got level: " .. level)
  TriggerClientEvent('postal:recPlayerLevel', source, level)
end)
