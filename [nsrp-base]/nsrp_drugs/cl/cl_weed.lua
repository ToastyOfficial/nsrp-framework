local markerDrawDistance = 3
local markerSize = 1.5
local item = "iWeed"
local closestPlant = nil

local clientWeedPlants = {}

local blips = {
	{x = 2034.28, y = 4905.68},
	{x = 563.06, y = 6487.78},
}

function textMsg()
  local messages = {
    "Yo you got some weed? I'll buy it off you, come to my location.",
    "I heard you got some weed, head to my spot and I'll pay good money for it.",
    "You lookin to sell your weed? I'll be waiting here, careful, cops are around.",
  }

  -- Get the ped headshot image.
  local handle = RegisterPedheadshot(PlayerPedId())
  while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
      Citizen.Wait(0)
  end
  local txd = GetPedheadshotTxdString(handle)

  -- Add the notification text
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(messages[math.random(1, #messages)])

  -- Set the notification icon, title and subtitle.
  local subtitle = "Weed Turn-in"
  local iconType = 0
  local flash = false -- Flash doesn't seem to work no matter what.
  EndTextCommandThefeedPostMessagetext('CHAR_MP_FAM_BOSS', 'CHAR_MP_FAM_BOSS', flash, iconType, "Weed Buyer", subtitle)

  -- Draw the notification
  local showInBrief = true
  local blink = false -- blink doesn't work when using icon notifications.
  EndTextCommandThefeedPostTicker(blink, showInBrief)

  -- Cleanup after yourself!
  UnregisterPedheadshot(handle)
end


CreateThread(function()
	Wait(1000)
	for k, v in pairs(blips) do
		print(v)
		makeBlip(v.x, v.y, 0, 469, 0, 'Job: Weed Harvesting')
	end
end)


RegisterNetEvent('spawnWeedPlant')
AddEventHandler('spawnWeedPlant', function(vector3, recId)
	--print('got spawn plant event')
	--print(vector3)

	local hash = nil

	local size = math.random(1,2)
	if size == 1 then
		hash = GetHashKey('prop_weed_01')
	else
		hash = GetHashKey('prop_weed_02')
	end
	RequestModel(hash)
	while not HasModelLoaded(hash) do Wait(0) end
	local object = {
		plant = CreateObject(hash, vector3, false, false, false),
		coords = vector3,
		id = recId
	}
	table.insert(clientWeedPlants, object)
end)

-- find closest plant
CreateThread(function()
	Wait(1000)
	while true do

		local ped = PlayerPedId()
		local pedLoc = GetEntityCoords(ped)
		local lastDistance = 9999

		for k, v in pairs(clientWeedPlants) do
			--print(v.coords)

			local distance = #(pedLoc - v.coords)
			--print(distance)

			if distance < lastDistance then
				lastDistance = distance
				closestPlant = v
				--rint(closestPlant)
			end
		end

	--print(closestPlant)
	Wait(500)
	end
end)

-- marker logic
local sleep = 1000
CreateThread(function()
	while true do
		Wait(sleep)

		if closestPlant then
			local ped = PlayerPedId()
			local pedLoc = GetEntityCoords(ped)
			local distanceFromMarker = GetDistanceBetweenCoords(pedLoc, closestPlant.coords, false)

			--print(closestPlant.coords)
			if IsPedOnFoot(ped) then

				if distanceFromMarker < markerDrawDistance then
					sleep = 0
					DrawMarker(0, closestPlant.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerSize, markerSize, markerSize, 95, 112, 185, 50, false, false, 2, false, nil, nil, false)

					if distanceFromMarker < markerSize then
						showAlert('Press ~INPUT_PICKUP~ to Harvest Weed', true)
						if IsControlJustReleased(0, 38) then
							local first = false
							TaskStartScenarioInPlace(ped, 'world_human_gardener_plant', 0, false)

							Wait(2000)
							ClearPedTasks(ped)
							Wait(1500)

							print(closestPlant.id)
							local player = Entity(PlayerPedId())
							if player.state.iWeed == 0 then
								first = true
							end
							TriggerServerEvent('removePlant', closestPlant.id)
							TriggerServerEvent('i:giveItem', GetPlayerServerId(PlayerId()), item, math.random(1,5)) --add weed to inven
							Wait(1000)
							if first then
								TriggerEvent('weed:updateTurnInBlip', false)
								textMsg()
							end
						end
					end
				else
					sleep = 1000
				end
			end
		else
			sleep = 1000
		end
	end
end)

RegisterNetEvent('c:removePlant')
AddEventHandler('c:removePlant', function(id)
	print('remove triggered')
	print(#clientWeedPlants)
	for k, v in pairs(clientWeedPlants) do
		--print(id)
		--print(v.id)
		if v.id == id then
			print('found plant with id')
			table.remove(clientWeedPlants, k)
			DeleteObject(v.plant)
		end
	end
end)
