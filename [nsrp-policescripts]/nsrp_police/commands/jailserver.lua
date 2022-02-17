local time = os.date("%m/%d/%Y %I:%M %p")
local bookLoc = vector3(1788.13, 2594.52, 44.8)

RegisterCommand('jail', function(source, args)
  local target = args[1]


  local user = GetPlayerName(source)
  local name = GetPlayerName(target)
  local userLoc = GetEntityCoords(GetPlayerPed(source))
  local targetLoc = GetEntityCoords(GetPlayerPed(target))
  local distance = #(userLoc - bookLoc)
  local distance2 = #(targetLoc - bookLoc)
  print('Target Location: ' .. targetLoc)
  print('Target Distance: ' .. distance2)
  print(userLoc.x)
  print(bookLoc.x)
  if distance < 2 then
    print(distance)
    if distance2 < 2 then
      if tonumber(target) ~= tonumber(source) then
        TriggerClientEvent('jailMe', target)
        file = io.open("logs/jaillog.txt", 'a')
        file:write('[' .. time .. '] ' .. '['..source..'] '..user.. ' jailed ['.. target.. '] ' ..name ..'\r\n')
        file:close()
        exports.nsrp_xp:addXP(source, 500)

      end
    else
      print('Target too far')
    end
  else
    print('Too far to jail')
  end
end, true)

RegisterCommand('unjail', function(source, args)
  local target = args[1]
  local user = GetPlayerName(source)
  local name = GetPlayerName(target)

  file = io.open("logs/jaillog.txt", 'a')
  file:write('[' .. time .. '] ' .. '['..source..'] '..user.. ' unjailed ['.. target.. '] ' ..name ..'\r\n')
  file:close()
  TriggerClientEvent('unjailMe', target)
end, true)

RegisterNetEvent('addJailXP')
AddEventHandler('addJailXP', function(amount)
  print(source)
  print(amount)
  exports.nsrp_xp:addXP(source, amount)
end)
