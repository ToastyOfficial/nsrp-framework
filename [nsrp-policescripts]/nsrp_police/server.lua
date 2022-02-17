
GlobalState.policeCount = 0

----------------------

--local GlobalState.policeCount = 0
local updating = false

RegisterNetEvent('updateCopCount')
AddEventHandler('updateCopCount', function(increase)
  if increase then
    GlobalState.policeCount = GlobalState.policeCount + 1
    if updating == false then
      exports.nsrp_hud:updateCops(GlobalState.policeCount, false)
    end
  else
    GlobalState.policeCount = GlobalState.policeCount - 1
    if updating == false then
      exports.nsrp_hud:updateCops(GlobalState.policeCount, false)
    end
  end
end)

CreateThread(function()
  while true do
    local allPlayers = GetPlayers()
    if #allPlayers > 0 then
      updating = true
      GlobalState.policeCount = 0
      for k, v in pairs(GetPlayers()) do
        local player = Entity(GetPlayerPed(v))
        if player.state.job == 'leo' then
          GlobalState.policeCount = GlobalState.policeCount + 1
        end
        --TriggerClientEvent('returnClientClocked', v, updating)
        Wait(100)
      end
      --print("Number of cops updated to: " .. GlobalState.policeCount)
      exports.nsrp_hud:updateCops(GlobalState.policeCount, true)
      updating = false
    end
    Wait(20000)
  end
end)


-- Check perms for clock in, then tell client to clock in, if no perms show error
RegisterCommand('clockin', function(source)
  perms = IsPlayerAceAllowed(source, "command.clockin")
  if perms then
    local allPlayers = GetPlayers()
    if GlobalState.policeCount < #allPlayers / 2 then
      TriggerClientEvent('p:clockMeIn', source)
      local player = Entity(GetPlayerPed(source))
      player.state.job = 'leo'
    else
      TriggerClientEvent('p:tooMany', source)
    end
  else
    TriggerClientEvent('p:noClockPerms', source)
  end
end, false)

-- Check perms for clock in, then tell client to clock out
RegisterCommand('clockout', function(source)
  local player = Entity(GetPlayerPed(source))
  if player.state.job == 'leo' then
    TriggerClientEvent('p:clockMeOut', source)

    player.state.job = 'none'
  end

end, false)

------------------------
------- COMMANDS -------
------------------------
------------------------

-- cuff command from client
RegisterNetEvent('cuff')
AddEventHandler('cuff', function(target)
  print('Got cuff event')
  if IsPlayerAceAllowed(source, "command.cuff") then

    local player = Entity(GetPlayerPed(target))
    print(player.state.cuffed)

    TriggerClientEvent('pc:cuffMe', target)

  end
end)

--drag command from client
RegisterNetEvent('s:drag')
AddEventHandler('s:drag', function(target)
  print("Drag triggered on server.")
  print("Target: " .. target)
  if IsPlayerAceAllowed(source, "command.drag") then
    print('s:drag triggered.')
    print("Dragger = " .. source)
    print("Target = " .. target)

    local player = Entity(GetPlayerPed(source))
    player.state.dragging = target -- set statebag for user as player server ID they are dragging will need to add distance check later


    TriggerClientEvent('pc:dragMe', target, source)

  else
    print('No perms for drag on player: ' .. source)
  end
end)

--seat command from client
RegisterNetEvent('seat')
AddEventHandler('seat', function(target)
  if IsPlayerAceAllowed(source, "command.seat") then

    TriggerClientEvent('pc:seatMe', target)

  end
end)

--unseat command from client
RegisterNetEvent('unseat')
AddEventHandler('unseat', function(target)
  if IsPlayerAceAllowed(source, "command.seat") then

    TriggerClientEvent('pc:unseatMe', target)

  end
end)
