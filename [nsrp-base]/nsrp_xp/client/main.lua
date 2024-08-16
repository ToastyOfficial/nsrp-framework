
local myLastRank = 0
local myXp = 1
local myRank = 1

local myRank_XP = nil
local myNextRank_XP = nil

local timerDef = 300
local timer = timerDef


function getLevel()
  return myRank
end
-- Triggers when player just joined

AddEventHandler('playerSpawned', function()
  CreateThread( function()
    ExecuteCommand('DB_Setup')
    Wait(1000)
    getRanksXP()
    TriggerEvent('c:updateBar', 1, true)
  end)
end)

RegisterNetEvent('xp:getMyInfo')
AddEventHandler('xp:getMyInfo', function(oldRank, xp, rank)
  print("xp:getMyInfo | Rank = " .. rank)
  myLastRank = oldRank
  myXP = xp
  myRank = rank

  print('My XP = ' .. myXP)
  print('My Level = ' .. myRank)

  getRanksXP()
if config.debug = true then
   print('My Last Level = ' .. myLastRank)
  end
end)

RegisterNetEvent('levelUpdate')
AddEventHandler('levelUpdate', function(name, rank, type)

  print(name)
  print(rank)
  if rank == 100 then
    local colors = {
      {255, 102, 102},
      {255, 153, 102},
      {255, 255, 102},
      {153, 255, 102},
      {102, 255, 153},
      {0, 255, 255},
      {51, 204, 255},
      {102, 153, 255},
      {204, 102, 255},
      {255, 102, 204},
    }
    for i=1,3 do
      for i=1, #colors do
        Wait(72)
        TriggerEvent('chat:addMessage', {
          color = colors[i],
          multiline = true,
          args = {"^*★ " .. string.upper(name) .. " HAS REACHED LEVEL 100!!!!!!!!!!!!!! ★"}
        })
      end
    end

    if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
		RequestNamedPtfxAsset("scr_indep_fireworks")
  		while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
  		   Wait(10)
  		end
	  end

    for i=1,4 do
      Wait(math.random(1,3000))
      local pedcoords = GetEntityCoords(GetPlayerPed(-1))
    	local ped = GetPlayerPed(-1)
      UseParticleFxAssetNextCall("scr_indep_fireworks")
    	local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", pedcoords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    end

  else
    if type == 1 then
      TriggerEvent('chat:addMessage', {
        color = { 156, 168, 226},
        multiline = true,
        args = {"^*" .. name .. " has been set to level ^*" .. rank .. " by an Admin..."}
      })
    elseif type == 2 then
      TriggerEvent('chat:addMessage', {
        color = { 156, 168, 226},
        multiline = true,
        args = {"^*" .. name .. " has just reached level ^*" .. rank .. "!"}
      })
    elseif type == 3 then
      TriggerEvent('chat:addMessage', {
        color = { 255, 126, 126},
        multiline = true,
        args = {"^*" .. name .. " has just gone down to level ^*" .. rank .. "!"}
      })
    end
  end
end)

RegisterNetEvent('xp:gainNotify')
AddEventHandler('xp:gainNotify', function(amount)
  print("xp:gainNotify: " .. myRank)
  if myRank ~= 100 then
    showNotification('Gained ' .. math.ceil(amount) .. " XP!", 'info')
  else
    print("Max XP")
  end
end)

RegisterNetEvent('xp:lossNotify')
AddEventHandler('xp:lossNotify', function(amount)
  showNotification('You have lost ' .. math.ceil(tonumber(amount)) .. " XP...", 'error')
end)

function showNotification(message, type)
  TriggerEvent("pNotify:SendNotification", {
    text = message,
    type = type,
    timeout = 3000,
    layout = "centerLeft",
    animation = {
      open = "gta_effects_fade_in",
      close = "gta_effects_fade_out",
    },
  })
end

-- THREAD

CreateThread( function()
  Wait(math.random(1,5000))
  ExecuteCommand('DB_Setup')
  Wait(math.random(1,5000))
  getRanksXP()
  Wait(200)
  TriggerEvent('c:updateBar', 1, true)
  playerId = PlayerId()
  id = GetPlayerServerId(playerId)
  print(id)
  while true do
    Wait(1000)
    if timer == 0 then
      TriggerServerEvent('xp:periodic', id)
      timer = timerDef
    else
      timer = timer - 1
      --print(timer)
    end
  end
end)

--[[ XP UI ELEMENTS HERE

XB BAR
SCOREBOARD?
LEADERBOARD?]]

function getRanksXP()
  local index = myRank + 1
  if myRank == 100 then
    myNextRank_XP = 2008000
  else
    myNextRank_XP = Config.Ranks[index]
  end


  print('[getRanksXP] XP needed for level ' .. index .. ': ' ..myNextRank_XP)

  myRank_XP = Config.Ranks[myRank]
  --print('[getRanksXP] Current rank XP: ' .. myRank_XP)
end

RegisterNetEvent('c:updateBar')
AddEventHandler('c:updateBar', function(direction, didLevelUp)
  --print('event triggered')

  local neededXP = myNextRank_XP - myRank_XP -- how much XP is needed for next leve
  --print('[update_XP_bar] XP needed for next rank: ' .. neededXP)

  local XP_inLevel = myXP - myRank_XP -- how much XP has player gained in current level
  --print('[update_XP_bar] XP gained in current level: ' .. XP_inLevel)

  local percent = XP_inLevel * 100 / neededXP
  --print('[update_XP_bar] Percent toward next level: ' .. percent)

  SendNUIMessage({
      type = 'updateBar',
      percent = percent,
      dir = direction,
      didLevelUp = didLevelUp,
      thisLevel = myRank,
      currentXP = myXP,
      nextRank_XP = myNextRank_XP
  })

end)

RegisterKeyMapping('+showBar', 'Show XP/Level', 'MOUSE_BUTTON', 'MOUSE_MIDDLE')

RegisterCommand('+showBar', function()
  SendNUIMessage({
    type = 'showBar',
  })
end)

RegisterCommand('-showBar', function()
  SendNUIMessage({
    type = 'hideBar',
  })
end)

-- function 'update_XP_bar'(xp)
--
-- end


------------------------------
------------------------------
------- Prestige Sytem -------
------------------------------
------------------------------
------------------------------
------------------------------
TriggerEvent('chat:addSuggestion', '/prestige', 'DANGER: RESETS LEVEL FROM 100 TO 0', {})


RegisterCommand('prestige', function()
  ExecuteCommand('DB_Setup')
  Wait(250)
  print(myRank)
  if myRank == 100 then
    print("Doing prestige stuff for " .. GetPlayerName(PlayerId()))
    -- set prestiege to presteige + 1
    -- set level to 1
    -- set xp to 0
  else
    print("You must be level 100 to prestige.")
  end
end)
