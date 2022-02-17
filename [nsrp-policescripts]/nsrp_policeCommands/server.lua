
GlobalState.mode = 'open'

-- Register the cuff command.
RegisterNetEvent('cuff')
AddEventHandler('cuff', function(target)
  if IsPlayerAceAllowed(source, "command.cuff") then
    TriggerClientEvent('pc:cuffMe', target)
    -- local player = Entity(GetPlayerPed(Target))
    -- print(player.state.cuffed)
  end
end)


RegisterCommand('seat', function(source, args)
  TriggerClientEvent('seat', tonumber(args[1]))
end, false)

RegisterCommand('unseat', function(source, args)
  TriggerClientEvent('unseat', tonumber(args[1]))
end, false)
