function initializeInventory(target)
  local ply = Entity(GetPlayerPed(target))
  print("Initializing inventory for " .. GetPlayerName(target))
  ply.state['iCapacity'] = 0
  ply.state['iFirearms'] = 0
  ply.state['iWeapons'] = 0
  ply.state['iWeed'] = 0
  ply.state['iWeed2'] = 0
  ply.state['iMeth'] = 0
  ply.state['iMeth2'] = 0
  ply.state['iMoneyBags'] = 0
end

RegisterNetEvent('initMyInv')
AddEventHandler('initMyInv', function(target)
  CreateThread( function()
    initializeInventory(target)
    local name = GetPlayerName(target)
    TriggerClientEvent('setName', target, name)
  end)
end)

RegisterNetEvent('clearInv')
AddEventHandler('clearInv', function(target)
  local ply = Entity(GetPlayerPed(target))
  print("Clearing " .. GetPlayerName(target) .. "'s inventory.")

  if ply.state['iFirearms'] > 0 then
    TriggerEvent('i:takeItem', target, "iFirearms", ply.state['iFirearms'])
  end
  if ply.state['iWeapons'] > 0 then
    TriggerEvent('i:takeItem', target, "iWeapons", ply.state['iWeapons'])
  end
  if ply.state['iWeed'] > 0 then
    TriggerEvent('i:takeItem', target, "iWeed", ply.state['iWeed'])
  end
  if ply.state['iWeed2'] > 0 then
    TriggerEvent('i:takeItem', target, "iWeed2", ply.state['iWeed2'])
  end
  if ply.state['iMeth'] > 0 then
    TriggerEvent('i:takeItem', target, "iMeth", ply.state['iMeth'])
  end
  if ply.state['iMeth2'] > 0 then
    TriggerEvent('i:takeItem', target, "iMeth2", ply.state['iMeth2'])
  end
  if ply.state['iMoneyBags'] > 0 then
    TriggerEvent('i:takeItem', target, "iMoneyBags", ply.state['iMoneyBags'])
  end

  ply.state['iWeapons'] = 0
  ply.state['iWeed'] = 0
  ply.state['iWeed2'] = 0
  ply.state['iMeth'] = 0
  ply.state['iMeth2'] = 0
  ply.state['iMoneyBags'] = 0
end)

CreateThread(function()
  local players = GetPlayers()
  for k, v in pairs(players) do
    Wait(100)
    initializeInventory(v)
    local name = GetPlayerName(v)
    TriggerClientEvent('setName', v, name)
  end
end)

-- example event TriggerServerEvent('i:giveItem', 4, 'iDrugs', 30)
RegisterCommand('giveItem', function(source, args)
  local target = args[1]

  --print(target)
  local item = args[2]
  --print(item)
  local amount = math.ceil(tonumber(args[3]))
  --print(amount)
  if amount > 0 then
    TriggerEvent('i:giveItem', target, item, amount)
  elseif amount < 0 then
    amount = math.abs(amount)
    print("Taking items instead: " .. amount)
    TriggerEvent('i:takeItem', target, item, amount)
  end
end, false)

RegisterNetEvent('i:giveItem')
AddEventHandler('i:giveItem', function(target, item, amount)
  local ply = Entity(GetPlayerPed(target))
  local capacity = ply.state['iCapacity']

  print("Capacity = " .. capacity)
  if capacity ~= 200 then
    print(capacity + amount)

    if capacity + amount > 200 then
      print('more than 200')
      amount = 200 - capacity
      ply.state['iCapacity'] = 200
    else
      ply.state['iCapacity'] = capacity + amount
    end

    print("Current: " .. ply.state[item])
    print("Amount being given: " .. amount)

    local addremove = false
    if ply.state[item] == 0 then -- if they didnt have any, inform client to add
      addremove = true
    end


    ply.state[item] = ply.state[item] + amount

    print("^6Gave Item: " .. item .. " to " .. GetPlayerName(target))
    print("^6" .. GetPlayerName(target) .. " now has " .. ply.state[item] .. " " .. item)

    TriggerClientEvent('invUpdated', target, item, amount, ply.state[item], 1, addremove)
  end
end)

RegisterNetEvent('i:takeItem')
AddEventHandler('i:takeItem', function(target, item, amount)
  local type = 2
  local ply = Entity(GetPlayerPed(target))



  if ply.state[item] > amount then
    ply.state[item] = ply.state[item] - amount
  else
    ply.state[item] = 0
  end

  -- TEST THIS, CAPACITY SETTING ON LOSS
  ply.state['iCapacity'] = ply.state['iCapacity'] - amount
  if ply.state['iCapacity'] < 0 then
    ply.state['iCapacity'] = 0
  end
  print("New Capacity = " .. ply.state['iCapacity'])

  print("^6Took Item: " .. item .. " from " .. GetPlayerName(target))
  print("^6" .. GetPlayerName(target) .. " now has " .. ply.state[item] .. " " .. item)

  local addremove = false
  if ply.state[item] == 0 then -- if they now have none, inform client to remove
    addremove = true
  end
  TriggerClientEvent('invUpdated', target, item, amount, ply.state[item], 2, addremove)
end)
