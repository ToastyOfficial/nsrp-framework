
vehicles = {
  '911turboS',
  'frauscher16',
}


function showNotification(message, type, time)
  TriggerEvent("pNotify:SendNotification", {
    text = message,
    type = type,
    timeout = time,
    layout = "centerLeft",
    animation = {
      open = "gta_effects_fade_in",
      close = "gta_effects_fade_out",
    },
  })
end

function spawnVehicle(name, x, y, z, heading)

	-- if they are already in a vehicle, delete it
	if IsPedInAnyVehicle(PlayerPedId()) then
		local vehToDelete = GetVehiclePedIsIn(PlayerPedId())
		DeleteVehicle(vehToDelete)
	end

	-- load model
	model = GetHashKey(name)
	print("[spawnVehicle] Model: " .. model)
	RequestModel(model)
	print("[spawnVehicle] Name: " .. name)
	print("X: " .. x)
	print("Y: " .. y)
	print("Z: " .. z)
	print("H: " .. heading)
	-- wait for model to load
	while not HasModelLoaded(name) do
			Citizen.Wait(1000)
			print('loading')
	end
	-- spawn vehicle
	local vehicle = CreateVehicle(model, x, y, z, heading, true, true)
	print('created' .. vehicle)

	SetEntityAsMissionEntity(vehicle, true, true)
	SetModelAsNoLongerNeeded(model)

	SetPedIntoVehicle(PlayerPedId(), vehicle, -1)

	return vehicle
end

RegisterNetEvent('c:checkVehicle')
AddEventHandler('c:checkVehicle', function(supporter)

  print("Supporter: " .. tostring(supporter))
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped)
  local model = GetEntityModel(vehicle)
  --local hash = GetHashKey(model)


  for k, v in pairs(vehicles) do
    print('My vehicle hash: ' .. model)

    print(GetHashKey(v))
    if model == GetHashKey(v) then -- if the vehicle is a supporter vehicle
      print('Vehicle found in table.')
      if not supporter then -- if the player is not a supporter
        print('Not supporter')
        ClearPedTasksImmediately(ped)
        showNotification('You must be a supporter to drive that.', 'warning', 5000)
      else
        print('Supporter')
      end
      break
    else
      print('Vehicle not in table.')
    end
  end
end)

RegisterNetEvent('spawnSupVeh')
AddEventHandler('spawnSupVeh', function(choice)
  print(choice)
  local canSpawn = true
  local override = false

  local spawner = exports.nsrp_vehSpawn:returnClosestSpawner()
  local spawnerLoc = spawner.marker

  local ped = PlayerPedId()
  local pedLoc = GetEntityCoords(ped)

  local distance = GetDistanceBetweenCoords(pedLoc, spawnerLoc)
  print("Distance from spawner: " .. distance)

  if tonumber(choice) == 2 then -- if they chose yacht check if ped is in water
    override = true
    if not IsEntityInWater(PlayerPedId()) then
      canSpawn = false
      showNotification('You must be in water to spawn that.', 'error', 3000)
    end
  end

  if canSpawn then
    if tonumber(choice) <= #vehicles then
      print(override)
      if not override then -- if player doesnt need to be near a spawner just spawn
        if distance <= 15.0 then
          local name = vehicles[tonumber(choice)]
          local coords = GetEntityCoords(PlayerPedId())
          local heading = GetEntityHeading(PlayerPedId())
          spawnVehicle(name, coords.x, coords.y, coords.z, heading)

        else
          print("Too far from spawner.")
          showNotification('You must be near a vehicle spawner.', 'error', 5000)
        end
      else
        local name = vehicles[tonumber(choice)]
        local coords = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        spawnVehicle(name, coords.x, coords.y, coords.z, heading)
      end
    else
      showNotification('Invalid selection', 'error', 5000)
    end
  end
end)
