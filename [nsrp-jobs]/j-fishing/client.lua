-- Variables

--[[ MOVED TO FISH.LUA

jobStart = {
 	x = 1302.76,
	y = 4225.21,
	z = 32.90,
 }

 jobReset = {
  	x = 1298.50,
 	y = 4216.95,
 	z = 32.90,
  }


 boatSpawn = {
	 x = 1306.86,
	 y = 4222.16,
	 z = 29.94,
	 heading = 173.0,
 }]]

 local ped = GetPlayerPed(-1)
 local caughtFish = nil

 -- Config
 local markerDrawDistance = 100
 local markerSize = 3.0
 local rareLevel = 20
 local exoticLevel = 45

 local sleep = 0
 local closestStart = nil
 local usedStart = nil
 local working = false
 local fishing = false
 local boat = nil

 local catchChance = 1
 local minCatchTime = 8000 -- seconds
 local maxCatchTime = 24000
 local eventMult = 1
 local locMult = 1


 local pLevel = 1

-- Functions

function makeBlip(x, y, z, sprite, color, name)

	local blip = AddBlipForCoord(x, y, z)

	SetBlipSprite(blip, sprite) -- Blip Sprite
	SetBlipColour(blip, color) -- Blip Color
	SetBlipAsShortRange(blip, true)


	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)

	return(blip)
end

function showAlert(message, playNotificationSound)
   SetTextComponentFormat('STRING')
   AddTextComponentString(message)
   DisplayHelpTextFromStringLabel(0, 0, playNotificationSound, -1)
end

function showNotification(message, type)
  TriggerEvent("pNotify:SendNotification", {
    text = message,
    type = type,
    timeout = 10000,
    layout = "centerLeft",
    animation = {
      open = "gta_effects_fade_in",
      close = "gta_effects_fade_out",
    },
  })
end

function spawnVehicle(name, x, y, z, heading)

	model = GetHashKey(name)
	RequestModel(model)
	print(name)

	while not HasModelLoaded(name) do
			Citizen.Wait(100)
			print('loading')
	end

	local vehicle = CreateVehicle(model, x, y, z, heading, true, true)

	SetEntityAsMissionEntity(vehicle, true, true)
	SetModelAsNoLongerNeeded(model)

	SetPedIntoVehicle(playerId, vehicle, -1)

	return vehicle
end

--[[ CONTROL PLAYER LEVEL GATE
rare only available at certain level
exotic only available at certain level
get a new boat and new doc location at certain LEVEL]]

RegisterNetEvent('fishing:recPlayerLevel')
AddEventHandler('fishing:recPlayerLevel', function(level)
  pLevel = level
  --print(pLevel)
end)

-- Choose fish

function chooseFish()
  local typeInt = 1

  Citizen.Wait(100)
  -- choose fish Type

  -- get player level
  TriggerServerEvent('fishing:getLevel', GetPlayerServerId(PlayerId()))
  -- set allowed fish rarity based on level
  if pLevel < rareLevel then
    typeInt = 1 -- always common
  elseif pLevel < exoticLevel then
    typeInt = math.random(99) -- common or rare
  else
    local typeInt = math.random(100) -- common rare or exotic
  end

  -- rarity control
  if typeInt < 75 then
    fishType = 'Common'
  elseif typeInt < 99 then
    fishType = 'Rare'
  else
    fishType = 'Exotic'
  end
  print('Rarity: ' .. fishType)

  -- choose fish from rarity
  if fishType == 'Common' then
    caughtFish = commonFish[math.random(0, #commonFish)]
  else
    if fishType == 'Rare' then
      caughtFish = rareFish[math.random(0, #rareFish)]
    else
      if fishType == 'Exotic' then
        caughtFish = exoticFish[math.random(0, #exoticFish)]
      end
    end
  end

  -- if flag = ocean
  if caughtFish.flag == 'ocean' then
    if IsEntityInZone(ped, 'OCEANA') and pLevel >= rareLevel then
      print('Caught ocean fish!')
    else -- if not in ocean
      print('An oceanic fish can only be caught in the ocean once ocean fishing is unlocked')
      chooseFish()
    end
  else
    -- if flag = river
    if caughtFish.flag == 'river' then
      if IsEntityInZone(ped, 'CCREAK') then
        print('Caught river fish!')
      else
        print('A river fish can only be caught in the river.')
        chooseFish()
      end
    else
      -- if flag = night
      if caughtFish.flag == 'night' then
        if GetClockHours() > 21 or GetClockHours() < 5 then
          print(GetClockHours())
          print('Caught night fish!')
        else
          print(GetClockHours())
          print('A night fish can only be caught at night')
          chooseFish()
        end
      else
        -- if flag = event
        if caughtFish.flag == 'event' then
          if not event then
            print('Event fish not available')
            chooseFish()
          else
            print('Caught event fish!')
          end
        end
      end
    end
  end

  return caughtFish
end


 -- Thread

Citizen.CreateThread(function()
  TriggerServerEvent('fishing:getLevel', GetPlayerServerId(PlayerId()))
  Wait(500)
  print(pLevel)

  -- Draw Blips
  for k, v in pairs(jobStarts) do
    print("Blip level: " .. v.level)
    print("Player level :" .. pLevel)
    if v.level <= pLevel then -- if job start level is lower than player's level then draw
      print(v.marker)
      makeBlip(v.marker.x, v.marker.y, 0, 427, 0, 'Job: Fishing')
    end
  end

	while true do
    Citizen.Wait(sleep)

    playerId = PlayerPedId()
    local playerCoordinates = GetEntityCoords(playerId)

    -- Find closest spawner
		local lastDistance = 9999
		closestStart = nil

		for k, v in pairs(jobStarts) do
		local distance = GetDistanceBetweenCoords(playerCoordinates, v.marker)

			if distance < lastDistance then
				lastDistance = distance
				--print(lastDistance)
				closestStart = v
			end
		end

    if not working then

      local coords = closestStart.marker
      local spawn = closestStart.spawn
      local heading = closestStart.h

  		local playerCoordinates = GetEntityCoords(playerId)
  		local distanceFromJobStart = GetDistanceBetweenCoords(playerCoordinates, coords, false)

  		-- check every second if player is close enough to marker to draw (checks using sleep)
  		if distanceFromJobStart < markerDrawDistance then
  			-- check/do every frame
  			sleep = 0
  			-- draw marker
        if closestStart.level < pLevel then
    			DrawMarker(1, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerSize, markerSize, 2.0, 95, 112, 185, 100, false, true, 2, false, nil, nil, false)
    			-- is player within marker (based on marker size)?
    			if distanceFromJobStart < markerSize then
            showAlert('Press ~INPUT_PICKUP~ to start fishing.', true)
    				if IsControlJustReleased(0, 38) then
              if not exports.nsrp_jobhandler:getHasJob() then -- if they don't already have a job
      					DoScreenFadeOut(500)
      					working = true
                TriggerServerEvent('j:setJob', 'fishing')
                exports.nsrp_jobhandler:setHasJob(true)
                usedStart = closestStart
                print(usedStart.reset)

                Citizen.Wait(500)
      					-- Spawn boat
      					boat = spawnVehicle(closestStart.boat, spawn.x, spawn.y, spawn.z, heading)
      					DoScreenFadeIn(500)
                print(boat)

                showNotification('Press [ R ] to cast your line.', 'info')
                Citizen.Wait(3000)
                showNotification('Press [ R ] again to reel in early.', 'info')
                Citizen.Wait(3000)
                showNotification('To cancel job, and return to dock, press [ J ].', 'info')
              else
                showNotification('You already have another job.', 'error')
              end
    				end
    			end
        end
  		else
  		-- if not close enough only check every second
  		  sleep = 1000
  		end
    end
 	end
end)


CreateThread(function()
  while true do
    if not working then
      pLevel = exports.nsrp_jobhandler:returnPlayerLevel()
    end
    Wait(60000)
  end
end)


-- Events
-- Actually fish
RegisterCommand('fish', function()
  local ped = GetPlayerPed(-1)
  local playerCoords = GetEntityCoords(ped)
  local hash = GetHashKey('dhingy2')
  local pedLoc = GetEntityCoords(ped)
  local boatLoc = nil

  --print(boatLoc)
  --print(pedLoc)

  if fishing then -- if already fishing
    ExecuteCommand('stopfish')
  else
    if working then
      ExecuteCommand('stopfish')
      -- check if ped should be able to fish
      -- if ped is on lake or ocean or river
      if IsEntityInZone(ped, 'ALAMO') or IsEntityInZone(ped, 'OCEANA') or IsEntityInZone(ped, 'CCREAK') or IsEntityInZone(ped, 'PALCOV') or IsEntityInZone(ped, 'CHU') then

        print('Player is near water')
        if not IsPedInAnyVehicle(ped, true) then
          print('Player is not in vehicle')
          if not IsPedSwimming(ped) then
            print('Player is not swimming')

            vehicleTable = GetGamePool('CVehicle')

            local closestDistance = 99999
            local closestVehicle = nil
            for k, v in ipairs(vehicleTable) do
              local vehLoc = GetEntityCoords(vehicleTable[k])
              local distance = GetDistanceBetweenCoords(vehLoc, pedLoc, true)
              if distance < closestDistance then
                closestVehicle = vehicleTable[k]
                closestDistance = distance
              end
            end
            print(closestVehicle)
            print(closestDistance)

            if IsEntityInWater(closestVehicle) then

              boatLoc = GetEntityCoords(closestVehicle)
              print(GetDistanceBetweenCoords(boatLoc, pedLoc, true))

              if GetDistanceBetweenCoords(boatLoc, pedLoc, true) < 15 then
                -- start fishing animation
                TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_FISHING", 0, false)
                -- pick random catch chance
                local timer = math.random(minCatchTime, maxCatchTime) / eventMult / locMult

                --print('Catch time:' .. timer)
                fishing = true
                  while true do
                    if not fishing then break end
                    Wait(1) -- every ms

                    if timer <= 0 then

                        print('Fish caught!')
                        fishing = false
                        ExecuteCommand('stopfish')

                        -- choose random fish from type (handles events and time)
                        chooseFish()

                        -- Calculate value
                        fishSize = math.random(caughtFish.minSize, caughtFish.maxSize)
                        fishValue = fishSize * caughtFish.value
                        print('Fish: ' .. caughtFish.name)
                        print('Flag: '.. caughtFish.flag)
                        print('Size: ' .. fishSize .. ' inches')
                        print('Value: ' .. fishValue .. 'xp')

                        TriggerServerEvent('fishing:xp', GetPlayerServerId(PlayerId()), fishValue)

                        showNotification('Fish caught: ' .. caughtFish.name, 'info')
                        Citizen.Wait(200)
                        showNotification('Size: ' .. fishSize .. ' inches', 'info')
                        Citizen.Wait(200)
                        showNotification('Value: ' .. fishValue .. 'xp', 'success')


                        if fishType == 'Rare' or fishType == 'Exotic' then
                          local source = GetPlayerName(PlayerId())
                          TriggerServerEvent('fishChat', source, fishSize, caughtFish.name, fishType,  fishValue)
                        end



                    else -- if timer ~= 0
                      print('Fish not caught...')
                      timer = timer - 10
                      --print(timer)
                    end
                  end
                else
                print('Ped is not near boat')
                end -- if not near boat
            else -- if closest vehicle to player is not in water
              print ('Player is not near water')
              showNotification('Cant fish here...', 'warning')
            end
          else
            print ('Player is swimming')
          end -- if not swimming
        else
             print('Ped is in vehicle')
        end -- if not in vehicle
      else
        print(IsEntityInZone(ped, 'CHU'))
        print ('Player is not near water')
      end -- if on water
    end -- if working
  end -- if fishing
end, false)

-- Cancel job and reset
RegisterCommand('fishing:abortjob', function()
     if working then

      vehToDelete = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    	Citizen.Wait(100)
      local coords = usedStart.reset
      print(usedStart.reset)

      -- exports.nsrp_tp:testExport('this is a test of an export')
      exports.nsrp_tp:nsrpTeleport(PlayerPedId(), 3, coords.x, coords.y, coords.z)

      working = false
      usedStart = nil
      TriggerServerEvent('j:clearJob')
      exports.nsrp_jobhandler:setHasJob(false)


      DeleteVehicle(vehToDelete)

      --SetPedCoordsKeepVehicle(GetPlayerPed(-1),jobReset.x, jobReset.y, jobReset.z)


     end
end, false)

RegisterCommand('stopfish', function()
  -- stop animation
  local ped2 = PlayerPedId()
  ClearPedTasks(ped2)

  -- delete fishing pole
  local fishingPole = GetHashKey('prop_fishing_rod_01')
  local objPool = GetGamePool('CObject')
  print(fishingPole)
  for i = 1, #objPool do
    local obj = objPool[i]
    local model = GetEntityModel(obj)
    if model == fishingPole then
      print('Found fishing pole to delete')
      SetEntityAsMissionEntity(obj)
      DeleteEntity(obj)
      break
    end
  end

  -- set fishing false
  fishing = false

end, false)

-- Keymappings

 RegisterKeyMapping('fish', 'Start Fishing', 'keyboard', 'r')
 RegisterKeyMapping('fishing:abortjob', 'Reset Fishing Job', 'keyboard', 'j')
 RegisterKeyMapping('stopfish', 'Stop Fishing', 'keyboard', 'x')
