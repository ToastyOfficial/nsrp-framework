local pLevel = 1
local sleep = 1000
local sleep2 = 1000
local sleep3 = 1000
local markerDrawDistance = 80
local markerSize = 3.0
local usedStart = nil
local working = false


local activePoints = {}
local blips = {}
local currentGoal = nil
local currentGoalIndex = 1

RegisterNetEvent('postal:recPlayerLevel')
AddEventHandler('postal:recPlayerLevel', function(level)
  pLevel = level
  --print(pLevel)
end)

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

-- keep level updated
CreateThread(function()
  while true do
    if not working then
      pLevel = exports.nsrp_jobhandler:returnPlayerLevel()
    end
		Wait(120000)
  end
end)

-- Main Thread (Drawing blips/markers)

Citizen.CreateThread(function()
  TriggerServerEvent('postal:getLevel', GetPlayerServerId(PlayerId()))
  Wait(500)
  print(pLevel)

  -- Draw Blips
  for k, v in pairs(jobStarts) do
    print("Blip level: " .. v.level)
    print("Player level :" .. pLevel)
    if v.level <= pLevel then -- if job start level is lower than player's level then draw
      print(v.marker)
      makeBlip(v.marker.x, v.marker.y, 0, 67, 0, 'Job: Postal')
    end
  end

	while true do
    Wait(sleep)

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
            showAlert('Press ~INPUT_PICKUP~ to deliver mail.', true)
    				if IsControlJustReleased(0, 38) then
              if not exports.nsrp_jobhandler:getHasJob() then -- if they don't already have a job
      					-- DoScreenFadeOut(500)
      					working = true
                TriggerServerEvent('j:setJob', 'postal')
                exports.nsrp_jobhandler:setHasJob(true)
                usedStart = closestStart
                print(usedStart.reset)

                Citizen.Wait(500)
      					-- Spawn truck
      					truck = spawnVehicle(closestStart.truck, spawn.x, spawn.y, spawn.z, heading)
                local aop = exports.nsrp_aop_res:getAOP()
                setupRoute(aop)
      					-- DoScreenFadeIn(500)
                print(truck)
                print("AOP: " .. aop)

                showNotification('Go to the first delivery point.', 'info')
                Citizen.Wait(3000)
                showNotification('Press [ E ] to deliver package.', 'info')
                Citizen.Wait(3000)
                showNotification('To cancel job, and return to warehouse, press [ J ].', 'info')
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

-- setup blips and first goal
function setupRoute(aop)
	local ped = PlayerPedId()
	local pedLoc = GetEntityCoords(ped)
	local distance = nil
	local lastDistance = 9999
	local firstRouteDrawn = false
	local routes = nil


  if working then
		currentGoalIndex = 1

		if aop == 1 then
			routes = destinations[1]
		elseif aop == 2 then
			routes = destinations[2]
		else
			routes = destinations[math.random(1,2)]
		end

		--local routes = destinations[aop]
		local points = routes[math.random(1, #routes)]
    -- Draw Blips
    for k, v in pairs(points) do
      if math.random(1, 100) > 33 then
        local coords = v.blip
        local blip = makeBlip(coords.x, coords.y, coords.z, 1, 14, 'Postal Delivery')
				table.insert(blips, blip)
				if firstRouteDrawn == false then
					currentGoal = blip

					SetBlipRoute(blip, true)
					SetBlipColour(blip, 5)
					SetBlipRouteColour(blip, 5)
					firstRouteDrawn = true
				end
      end
    end
  end
end

-- handle working
CreateThread(function()
	while true do
		if working then
			local goalCoords = GetBlipCoords(currentGoal)
			local pedCoords = GetEntityCoords(PlayerPedId())
  		local distanceFromGoal = GetDistanceBetweenCoords(pedCoords, goalCoords, false)

  		-- check every second if player is close enough to marker to draw (checks using sleep)
  		if distanceFromGoal < markerDrawDistance then
				sleep2 = 0
				DrawMarker(0, goalCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 95, 112, 185, 100, false, true, 2, false, nil, nil, false)

				if distanceFromGoal < 1 then
					showAlert('Press ~INPUT_PICKUP~ to deliver package.', true)
					if IsControlJustReleased(0, 38) then
						RemoveBlip(currentGoal)
						-- give XP
						local reward = math.random(100,400)
						showNotification('Package delivered. Go to next location!', 'success')
						TriggerServerEvent('postal:xp', GetPlayerServerId(PlayerId()), reward)
						getNextGoal() -- get next goal
					end
				end
			else -- if not in draw distance of blip then check every second
				sleep2 = 1000
			end
		end
		Wait(sleep2)
	end
end)

-- get next delivery point, triggers after delivering a package
function getNextGoal()
	print("Last blip: " .. GetBlipCoords(currentGoal))

	currentGoalIndex = currentGoalIndex + 1
	local nextGoal = blips[currentGoalIndex]
	currentGoal = nextGoal

	if nextGoal then
		print("Next blip: " .. GetBlipCoords(currentGoal))
		SetBlipRoute(currentGoal, true)
		SetBlipColour(currentGoal, 5)
		SetBlipRouteColour(currentGoal, 5)
	else -- if all blips have been completed
		print('done!')
		showNotification('Route completed!.', 'success')
		showNotification('Go to pickup location to start a new route.', 'success')
		TriggerServerEvent('postal:xp', GetPlayerServerId(PlayerId()), 1000)

		local pickup = makeBlip(closestStart.pickup.x, closestStart.pickup.y, closestStart.pickup.z, 1, 14, 'Postal Pickup')
		SetBlipRoute(pickup, true)

		while true do
			local pickupCoords = GetBlipCoords(pickup)
			local pedCoords = GetEntityCoords(PlayerPedId())
  		local distanceFromPickup = GetDistanceBetweenCoords(pedCoords, pickupCoords, false)

			print(pickupCoords)
			print(distanceFromPickup)
			-- check every second if player is close enough to marker to draw (checks using sleep)
			if distanceFromPickup < markerDrawDistance then
				sleep3 = 0
				DrawMarker(1, pickupCoords.x, pickupCoords.y, pickupCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 95, 112, 185, 100, false, true, 2, false, nil, nil, false)

				if distanceFromPickup < 1 then
					showAlert('Press ~INPUT_PICKUP~ to pickup mail.', true)
					if IsControlJustReleased(0, 38) then
						setupRoute()
						RemoveBlip(pickup)
						break
					end
				end
			else -- if not in draw distance of blip then check every second
				sleep3 = 1000
			end
			Wait(sleep3)
		end
	end
end

-- once route is complete



-- Cancel job and reset
RegisterCommand('postal:abortjob', function()
     if working then

      vehToDelete = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    	Citizen.Wait(100)
      local coords = usedStart.reset
      print(usedStart.reset)

      -- exports.nsrp_tp:testExport('this is a test of an export')
      exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, coords.x, coords.y, coords.z)

      working = false
      usedStart = nil
      TriggerServerEvent('j:clearJob')
      exports.nsrp_jobhandler:setHasJob(false)


      DeleteVehicle(vehToDelete)

			for k, v in pairs(blips) do
				RemoveBlip(v)
			end
      --SetPedCoordsKeepVehicle(GetPlayerPed(-1),jobReset.x, jobReset.y, jobReset.z)
     end
end, false)

RegisterKeyMapping('postal:abortjob', 'Reset Postal Job', 'keyboard', 'j')
