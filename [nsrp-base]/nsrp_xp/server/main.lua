local CurrentXP = 0
local CurrentRank = 1
local data = nil

local steam = nil

local name = nil
local xp = nil
local rank = nil

-- THIS HAPPENS WHEN PLAYER JOINS (triggered by client)

RegisterCommand('DB_Setup', function(source)
  setupPlayerDB(source)
end)

function setupPlayerDB(source)
  -- create thread to use Wait()
  CreateThread( function()
    local name = GetPlayerName(source)
    local targetSteam = getSteam(source)

    local setupXP = nil
    local setupRank = nil
      if config.debug = true then
         print(targetSteam)
      end 

    -- get player data function to get data from MySQL based on identifier above
    --name, xp, rank = getPlayerInfo(source, name, targetSteam)

    ---  V MOVED TO FUNCTION BELOW (getPlayerInfo) V

      if config.debug = true then
         print("Looking for player; steam ID: " .. targetSteam)
      end
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @steam",
    {
      ['@steam'] = targetSteam
    },
      function(result)
          if config.debug = true then
             print('[setupPlayerDB] Player search returned: ' .. json.encode(result))
          end
          data = result

          setupXP = data[1].rp_xp
          setupRank = data[1].rp_rank
          if config.debug = true then
             print("Retrieved name: " ..data[1].name)
             print("Retrieved XP: " ..data[1].rp_xp)
             print("Retrieved Level: " .. data[1].rp_rank)
          end 

     end)
     Wait(200) -- wait long enough for MqSQL query to complete

    -- if identifier wasn't found, add player to DB
    if json.encode(data) == '[]' then
      print('^3[setupPlayerDB] No Data in DB, adding player' .. name)
      MySQL.Sync.execute("INSERT INTO `nsrp`.`users` (`identifier`, `name`) VALUES ('".. targetSteam .. "', '" .. name .. "')")
    else -- if it was found, say it was
      print("^2[setupPlayerDB] Loaded info for: " .. name  .. ': ' .. json.encode(data))
      local player = Entity(GetPlayerPed(source))
      player.state.level = setupRank
      TriggerClientEvent('xp:getMyInfo', source, setupRank, setupXP, setupRank)
    end
  -- Reset data
  data = nil
  end)
end


--------------------------------------------------------------
-- SET XP
------------------------------------------------------------
RegisterCommand('setXP', function(source, args) -- this definitely needs to be disabled / restricted once done testing
  local target = args[1]
  local amount = args[2]

  setXP(target, amount, 1)
end, true)

function setXP(target, amount, type) -- target is playerID

  CreateThread(function()

    local targetSteam = getSteam(target)
    local didLevelUp = false

    local data = MySQL.Sync.fetchAll("SELECT rp_rank FROM users WHERE identifier = @steam",
    {['@steam'] = steam},
    function()
    end)
    Wait(200)
    local oldRank = data[1].rp_rank
      if config.debug = true then
         print("[setXP] Old Rank: " .. oldRank)
      end

    local data2 = MySQL.Sync.fetchAll("SELECT name FROM users WHERE identifier = @steam",
    {['@steam'] = steam},
    function()
    end)
    Wait(200)
    name = data2[1].name
    print("[setXP] Name: " .. name)

    MySQL.Async.execute("UPDATE `nsrp`.`users` SET rp_xp = " .. amount .. " WHERE identifier = @steam",
    {
      ['@steam'] = targetSteam,
    },
      function()
        print("^2[setXP] Set XP to " .. amount)
      end) -- set xp, target is player ID, amount is xp amount

    --setRank(amount)
    -- SET RANK

    for rank = 1, #Config.Ranks do
        if tonumber(amount) < 2008000 then

          if Config.Ranks[rank + 1] > tonumber(amount) then
            if config.debug = true then
               print("Set rank got: Level " .. rank)
               print(rank)
            end
            MySQL.Async.execute("UPDATE `nsrp`.`users` SET rp_rank = " .. rank .. " WHERE identifier = @steam",
            {
              ['@steam'] = targetSteam,
            },
              function()
                if config.debug = true then
                   print(oldRank)
                   print(rank)
                end
                if tonumber(oldRank) == tonumber(rank) then
                  didLevelUp = false
                  if config.debug = true then
                     print('No')
                  end
                else
                  didLevelUp = true
                  TriggerClientEvent('levelUpdate', -1,  name, rank, type)
                end

                print("^2[setXP] Set Rank to " .. rank)

                local player = Entity(GetPlayerPed(target))
                player.state.level = rank

                TriggerClientEvent('xp:getMyInfo', target, oldRank, amount, rank)
                TriggerClientEvent('c:updateBar', target, type, didLevelUp)

              end)
            return rank
          end
        else
          MySQL.Async.execute("UPDATE `nsrp`.`users` SET rp_rank = " .. 100 .. " WHERE identifier = @steam",
          {
            ['@steam'] = targetSteam,
          },
            function()

              print("^2[setXP] Set Rank to 100")

              if oldRank ~= 100 then
                TriggerClientEvent('levelUpdate', -1,  name, 100, type)
              end

              local player = Entity(GetPlayerPed(target))
              player.state.level = 100

              TriggerClientEvent('xp:getMyInfo', target, oldRank, amount, 100)
              TriggerClientEvent('c:updateBar', target, 4, false)

            end)
          break
        end
    end
  end)
end

exports('setXP', setXP)

--[[ ADD AND REMOVE XP
------------------------]]

RegisterCommand('addXP', function(source, args)
  addXP(args[1], args [2]) -- args 1 is target args 2 is amount
end, true)

RegisterCommand('remXP', function(source, args)
  remXP(args[1], args [2]) -- args 1 is target args 2 is amount
end, true)

-- ADD XP

function addXP(target, amount) -- add xp to plyaer using set XP and maths, target is player server ID
  CreateThread(function()
    local newXP = nil
    local steam = getSteam(target)

    if IsPlayerAceAllowed(target, 'supporter.xp') then
      print('Is a supporter')
        if config.debug = true then
           print("Normal amount = " .. amount)
        end
      amount = amount*1.5
        if config.debug = true then
           print('Supporter amount = ' .. amount)
        end
    else
        if config.debug = true then
           print('No supporter bonus')
        end
    end

    local xp_table = MySQL.Sync.fetchAll("SELECT  rp_xp FROM users WHERE identifier = @steam",{['@steam'] = steam}, function(result)
          if config.debug = true then
             print('Fetch from table returned: ' .. json.encode(result)) xp = result[1].rp_xp
          end
    end)
    local currentXP = xp_table[1].rp_xp
      if config.debug = true then
         print(currentXP)
      end
    Wait(100)        -- have to have getPlayerXP function inform addXP of xp somehow, it's not passing it.
    local newXP = currentXP + amount

      if config.debug = true then
         print("New XP to set: " .. newXP)
      end
    if newXP > 2008000 then
      setXP(target, 2008000, 2)
    else
      setXP(target, newXP, 2)
    end
    TriggerClientEvent('xp:gainNotify', target, amount)
  end)
end

exports('addXP', addXP)

-- REMOVE XP

function remXP(target, amount) -- remove xp from plyaer using set XP and maths, target is player ID
  CreateThread(function()
    local newXP = nil
    local steam = getSteam(target)

      if config.debug = true then
         print("REM steam: " .. steam)
      end
      ---- THIS IS WHAT I WAS WORKING ON ----

    local xp_table = MySQL.Sync.fetchAll("SELECT  rp_xp FROM users WHERE identifier = @steam",{['@steam'] = steam},
    function(result)
          if config.debug = true then
             print('Fetch from table returned: ' .. json.encode(result)) xp = result[1].rp_xp
          end
    end)
    local currentXP = xp_table[1].rp_xp
      if config.debug = true then
         print(currentXP)
      end
    Wait(100) -- have to have getPlayerXP function inform addXP of xp somehow, it's not passing it.

    print(tonumber(currentXP))
    if tonumber(currentXP) == 2008000 then
      print("RemXP: Player is at max XP")
    else
      print('Not max.')
      if tonumber(currentXP) > tonumber(amount) then
        local newXP = currentXP - amount

          if config.debug = true then
             print("New XP to set: " .. newXP)
          end

        setXP(target, newXP, 3)
        TriggerClientEvent('xp:lossNotify', target, amount)
      else
        setXP(target, 0, 3)
      end
    end
  end)
end

exports('remXP', remXP)
------------------------------------------------------------
-- Misc Functions (GETTING VALUES)
------------------------------------------------------------

-- Periodic XP
RegisterNetEvent('xp:periodic')
AddEventHandler('xp:periodic', function(id)
    addXP(id, 250)
end, true)

-- Get player steam ID
function getSteam(target) -- target is player server ID
  if config.debug = true then
    print("[getSteam] Getting steam for ID: ".. target)
  end
  -- get identifiers
  local identifiers = GetPlayerIdentifiers(target)
  steam = nil

  if config.debug = true then
     print("Found an identifier: " .. identifiers[1])
  end

  -- sort through identifiers to find steam
  for k, v in ipairs(GetPlayerIdentifiers(target)) do
      if string.match(v, "steam:") then
        -- set steam var as steam
         steam = v
         break
      end
    end
  if config.debug = true then
     print('Found Steam ID: ' .. steam)
  end
  return steam
end

-- GET PLAYER INFO ONLY

-- RegisterCommand('getInfo', function(source, args) -- gets xp of specified player, arg is player ID
--   CreateThread(function()
--     local target = args[1]
--     local steam  = getSteam(target)
--     xp = getPlayerXP(steam)
--     Wait(100)
--     print("Got XP for steam: " .. steam .. " XP: " .. xp)
--   end)
-- end)
function getPlayerLevel(source, callback) -- gets level of specified player ID
  local level = nil
  if config.debug = true then
     print("^6[getPlayerLevel] Source: " .. source)
  end

  local targetSteam = getSteam(source)
  if config.debug = true then
     print("[getPlayerLevel] Looking for player; steam ID: " .. targetSteam)
  end

  local result = MySQL.Sync.fetchAll("SELECT rp_rank FROM users WHERE identifier = @steam", {['@steam'] = targetSteam})
  if config.debug = true then
     print('Fetch from table returned: ' .. json.encode(result))
  end
  data = result
  if config.debug = true then
     print("^6[getPlayerLevel] Retrieved Level: " .. data[1].rp_rank)
  end
  level = data[1].rp_rank
  callback(level)

  return level
end

exports('getPlayerLevel', getPlayerLevel)

function getPlayerInfo(source, targetSteam) -- gets xp of specified player by steam ID
  xp = nil
  rank = nil
  name = nil

  print("Looking for player; steam ID: " .. steam)

  MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @steam",
  {
    ['@steam'] = targetSteam
  },
    function(result)
        print('Fetch from table returned: ' .. json.encode(result))
        data = result
      if config.debug = true then
         print("Retrieved name: " ..data[1].name)
         print("Retrieved XP: " ..data[1].rp_xp)
         print("Retrieved Level: " .. data[1].rp_rank)
      end
        name = data[1].name
        xp = data[1].rp_xp
        rank = data[1].rp_rank

        TriggerClientEvent('xp:getMyInfo', source, data[1].rp_xp, data[1].rp_rank)
        return name, xp, rank
    end)

  Wait(200)

end


-----------------------
------ prestige ------
-----------------------

function incPrestige(target)
  local steam = getSteam(target)

  MySQL.Async.execute("UPDATE `nsrp`.`users` SET prestige = prestige + 1 WHERE identifier = @steam",
  {
    ['@steam'] = steam,
  },
    function()
      print("^2[incPrestige] Prestige now: " .. amount)
    end)
end

RegisterNetEvent('xp:prestige')
AddEventHandler('xp:prestige', function()
  setXP(source, 0, 1)
  incPrestige(source)
end)
