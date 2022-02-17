
-- RES

local time = os.date("%m/%d/%Y %I:%M %p")

-- Revive command
RegisterCommand('revive', function(source, args, raw)
    -- set default player to revive as self
    local to_rev = source
	  local user = GetPlayerName(source)
    print(to_rev)
    print(user)

    -- if not used on self
    if args[1] ~= nil then
      -- set playerID to typed ID
      local player_id = tonumber(args[1])
      -- if typed ID is nil or 0 or playername of player with typed ID is nil
      if player_id == nil or player_id == 0 or GetPlayerName(player_id) == nil then
        -- show error
          TriggerClientEvent('chatMessage', source, 'SAN ANDREAS FIRE & RESCUE', {200, 0, 0},
              'That Player ID is either invalid or the player have gone offline')
      end
      -- if ID belongs to self then
      if to_rev == player_id then
        -- show error
          TriggerClientEvent('chatMessage', source, 'SAN ANDREAS FIRE & RESCUE', {200, 0 ,0},
              'A player ID isn\'t needed when reviving yourself. Just do /' .. config.commands.revive)
      end

      -- set ID of player to rev
      to_rev = player_id
    end
    -- default name of revived to "yourself"
    local name = 'yourself'

    -- if they are not reviving themselves then
    if source ~= to_rev then

      -- get name of player to rev
      name = GetPlayerName(to_rev)
      -- set playerID to typed ID
		  local player_id = tonumber(to_rev)
      -- revive player event passing ID
      TriggerClientEvent('reviveClient', to_rev, GetPlayerName(source))
      -- write to log file
    	file = io.open("logs/revlog.txt", 'a')
    	file:write('[' .. time .. '] ' .. '['..source..'] '..user.. ' revived ['.. to_rev.. '] ' ..name ..'\r\n')
    	file:close()
    -- if they are reviving themselves
    else

      -- set player ID to self
  		local player_id = tonumber(to_rev)
      print(player_id)
      -- revive
      TriggerClientEvent('reviveClient', player_id)
      -- write to log file
    	file = io.open("logs/revlog.txt", 'a')
    	file:write('[' .. time .. '] ' .. '['..source..'] '..user .. ' Revived themselves \r\n')
    	file:close()
    end

    TriggerClientEvent('chatMessage', source, 'San Andreas Fire & Rescue', {200, 0, 0}, 'Reviving ' .. name)
  end, true)




-- AOP
  GlobalState.aop = 1
  GlobalState.aopText = 'Blaine County'
  serverAOP = 1
  serverAOP_text = 'Blaine County' -- default

  aopTable = {
    'Blaine County', -- 1
    'Los Santos', -- 2
    'Statewide' -- 3
  }

  -- AOP SERVER FUNCTION

  function choose_AOP_FromTable(int)
      -- choose aop based on int
      print('Function: arg: ' .. int)
      GlobalState.aopText = aopTable[int]
      serverAOP_text = aopTable[int]
      print('Function: string: ' .. serverAOP_text)

    return serverAOP_text
  end
  -- Send AOP to client when requested

  RegisterServerEvent('sync_AOP')
  AddEventHandler('sync_AOP', function()
    exports.nsrp_hud:updateAOP(serverAOP_text)
    --print('AOP to server event: ' .. serverAOP .. ' - ' .. serverAOP_text)
  	TriggerClientEvent('get_AOP', -1, serverAOP, serverAOP_text)
  end)


  -- AOP command
  RegisterCommand('aop', function(source, args)
    -- check perms
  	if source == 0 or IsPlayerAceAllowed(source, 'nsrp.aopcmds') then
      --print('Command arg result: ' .. args[1])
      -- choose AOP from table based on inputed integer
      GlobalState.aop = tonumber(args[1])
      serverAOP = tonumber(args[1])
  		serverAOP_text = choose_AOP_FromTable(tonumber(args[1])) -- tonumber(int[1]) will take the first arg (which is your int).
      -- sync clients
  		TriggerEvent('sync_AOP')
      TriggerClientEvent('aopNotification', -1, serverAOP_text)
  		TriggerClientEvent('chatMessage', -1, ' \n —————————————————————— \n RP AREA IS NOW : '.. serverAOP_text ..' \n Please finish your current RP and move. \n ——————————————————————', {237, 110, 110})
      SetMapName("RP : " .. serverAOP_text)
      Citizen.Wait(20000)
      TriggerClientEvent('aopNotification', -1, serverAOP_text)

  	else
  		TriggerClientEvent('noPerms', source)
  	end
  end)

RegisterNetEvent('deathXP')
AddEventHandler('deathXP', function(amount)
  exports.nsrp_xp:remXP(source, amount)
end)
