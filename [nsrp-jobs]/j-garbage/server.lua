RegisterNetEvent('garbage:getLevel')
AddEventHandler('garbage:getLevel', function(source)
  local level = 1
  --print("Source: " .. source)
  local level = exports.nsrp_xp:getPlayerLevel(source, function(level)
    return level
  end)
  --print("Fishing got level: " .. level)
  TriggerClientEvent('garbage:recPlayerLevel', source, level)
end)


RegisterNetEvent('garbage:xp')
AddEventHandler('garbage:xp', function(target, amount)
  print("^6Granting ID: " .. target .. ' with ' .. amount .. ' xp.')

  exports.nsrp_xp:addXP(target, amount)
end)
