RegisterNetEvent('fishChat')
AddEventHandler('fishChat', function(source, fishSize, fishName, fishType, fishValue)
  --print('Event fired')
  TriggerClientEvent('chat:addMessage', -1, {color = {95, 112, 185}, multiline = true, args = {'Fishing', source .. ' just caught a ' .. fishSize .. ' inch ' .. fishName .. ' [' .. fishType .. '] ' .. ' worth ' .. fishValue .. 'xp!'}})
end)

RegisterNetEvent('fishing:xp')
AddEventHandler('fishing:xp', function(target, fishValue)
  print("^6Granting ID: " .. target .. ' with ' .. fishValue .. ' xp.')

  exports.nsrp_xp:addXP(target, fishValue)
end)

RegisterNetEvent('fishing:getLevel')
AddEventHandler('fishing:getLevel', function(source)
  local level = 1
  --print("Source: " .. source)
  local level = exports.nsrp_xp:getPlayerLevel(source, function(level)
    return level
  end)
  --print("Fishing got level: " .. level)
  TriggerClientEvent('fishing:recPlayerLevel', source, level)
end)
