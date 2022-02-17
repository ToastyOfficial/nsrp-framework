local truckId      	        = nil
local jobStatus    		    = CONST_NOTWORKING
local currentRoute          = nil
local currentDestination    = nil
local routeBlip             = nil
local trailerId             = nil
local lastDropCoordinates   = nil
local totalRouteDistance    = nil
local working = false

--
-- Threads
--

-- Create job blip
Citizen.CreateThread(function()
	EncoreHelper.CreateBlip(Config.JobStart.Coordinates, 'Job: Trucking', Config.Blip.SpriteID, Config.Blip.ColorID, Config.Blip.Scale)

-- every frame
	while true do
		Citizen.Wait(0)

		local playerId             = PlayerPedId()
		local playerCoordinates    = GetEntityCoords(playerId)
		local distanceFromJobStart = GetDistanceBetweenCoords(playerCoordinates, Config.JobStart.Coordinates, false)
		local sleep                = 1000

		-- if close enough to job start location...
		if distanceFromJobStart < Config.Marker.DrawDistance then
			sleep = 0
			-- draw marker
			DrawMarker(Config.Marker.Type, Config.JobStart.Coordinates, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Size,  Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, 100, false, true, 2, false, nil, nil, false)
			-- keep checking, true once player is close enough (based on size of marker)
			if distanceFromJobStart < Config.Marker.Size.x then
				-- keep checking, if ped is already in a truck, show return alert
				if truckId and GetVehiclePedIsIn(playerId, false) == truckId and GetPedInVehicleSeat(truckId, -1) == playerId then
					EncoreHelper.ShowAlert('Press ~INPUT_PICKUP~ to return your truck.', true)
					-- if ped is already in a truck and 38 is just released then delete truck and...
					if IsControlJustReleased(0, 38) then
						TriggerServerEvent('encore_trucking:returnTruck')
						-- abort job
						abortJob()
					end
				-- if ped is not already in truck, then wait for control to spawn truck
				elseif not IsPedInAnyVehicle(playerId, false) then

					EncoreHelper.ShowAlert('Press ~INPUT_PICKUP~ to get truck', true)
					-- if 38 just released then spawn truck
					if IsControlJustReleased(0, 38) then
						print("e")
						TriggerServerEvent('encore_trucking:rentTruck')
						working = true
					end
				end
			end
		end

		if jobStatus ~= CONST_NOTWORKING then
			sleep = 0

			-- if waiting for task, assign task
			if jobStatus == CONST_WAITINGFORTASK then
				assignTask()
			-- if picking up then do pickingUpThread function
			elseif jobStatus == CONST_PICKINGUP then
				pickingUpThread(playerId, playerCoordinates)
			-- if delivering then do deliveringThread function
			elseif jobStatus == CONST_DELIVERING then
				deliveringThread(playerId, playerCoordinates)
			end

			-- Abort Hotkey
			--if IsControlJustReleased(0, Config.AbortKey) then
				--abortJob()
			--end
		end

		if sleep > 0 then
			Citizen.Wait(sleep)
		end
	end
end)

-- Picking up (after getting job or finishing delivery)

function pickingUpThread(playerId, playerCoordinates)
	if not trailerId and GetDistanceBetweenCoords(playerCoordinates, currentRoute.PickupCoordinates, true) < 100.0 then
		trailerId = EncoreHelper.SpawnVehicle(currentRoute.TrailerModel, currentRoute.PickupCoordinates, currentRoute.PickupHeading)
	end

	if trailerId and IsEntityAttachedToEntity(trailerId, truckId) then
		RemoveBlip(routeBlip)
		routeBlip = EncoreHelper.CreateRouteBlip(currentDestination)

		EncoreHelper.ShowNotification('Take the delivery to the drop off point! GPS Set.')

		jobStatus = CONST_DELIVERING
	end
end

-- Delivering (after picking up)

function deliveringThread(playerId, playerCoordinates)
	local distanceFromDelivery = GetDistanceBetweenCoords(playerCoordinates, currentDestination, true)

	if distanceFromDelivery < Config.Marker.DrawDistance then
		DrawMarker(Config.Marker.Type, currentDestination, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Size,  Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, 100, false, true, 2, false, nil, nil, false)

		if distanceFromDelivery < Config.Marker.Size.x then
			EncoreHelper.ShowAlert('Press ~INPUT_PICKUP~ to deliver trailer.', true)

			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('encore_trucking:loadDelivered', totalRouteDistance)
				cleanupTask()
			end
		end
	end

	if trailerId and (not DoesEntityExist(trailerId) or not IsEntityAttachedToEntity(trailerId, truckId)) then
		if DoesEntityExist(trailerId) then
			DeleteVehicle(trailerId)
		end

		RemoveBlip(routeBlip)

		currentRoute        = nil
		currentDestination  = nil
		lastDropCoordinates = playerCoordinates

		EncoreHelper.ShowNotification('You lost your trailer... Pickup a new one.')

		jobStatus = CONST_WAITINGFORTASK
	end
end

--
-- Functions
--

function cleanupTask()
	if DoesEntityExist(trailerId) then
		DeleteVehicle(trailerId)
	end

	RemoveBlip(routeBlip)

	trailerId          = nil
	routeBlip          = nil
	currentDestination = nil
	currentRoute       = nil

	jobStatus = CONST_WAITINGFORTASK
end

RegisterKeyMapping('abortJob', 'Abort Trucking Job', 'keyboard', 'j')
RegisterCommand('abortJob', function()
	if not abortInProgress then
		if working then
			abortInProgress = true
			print('Pressed Abort Job Button')
			abortJob()
		else
			print('Can only abort when working!')
		end
	else
		print('Already aborting job')
	end
end)

function abortJob()

	 exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, 157.67, 2766.48, 42.17)

	 if truckId and DoesEntityExist(truckId) then
	 	DeleteVehicle(truckId)
	 end
	 if trailerId and DoesEntityExist(trailerId) then
	 	DeleteVehicle(trailerId)
	 end
 		if routeBlip then
 			RemoveBlip(routeBlip)
 		end
	 truckId  		    = nil
	 trailerId		    = nil
	 routeBlip			= nil
	 currentDestination  = nil
	 --currentRoute        = nil
	 lastDropCoordinates = nil
	 totalRouteDistance  = nil

	 working = false
	 abortInProgress = false
end

-- Assign route
function assignTask()
	-- Pick random route
	currentRoute       = Config.Routes[math.random(1, #Config.Routes)]
	-- Pick random destination
	currentDestination = currentRoute.Destinations[math.random(1, #currentRoute.Destinations)]
	-- Create route blip
	routeBlip          = EncoreHelper.CreateRouteBlip(currentRoute.PickupCoordinates)

	-- Get distance of route
	local distanceToPickup   = GetDistanceBetweenCoords(lastDropCoordinates, currentRoute.PickupCoordinates)
	local distanceToDelivery = GetDistanceBetweenCoords(currentRoute.PickupCoordinates, currentDestination)

	totalRouteDistance  = distanceToPickup + distanceToDelivery
	lastDropCoordinates = currentDestination

	EncoreHelper.ShowNotification('Head to the pickup location on your GPS.')
	-- Set status to picking up (start job)
	jobStatus = CONST_PICKINGUP
end

--
-- Events
--

-- When player gets job
RegisterNetEvent('encore_trucking:startJob')
AddEventHandler('encore_trucking:startJob', function()
	local playerId = PlayerPedId()

	truckId = EncoreHelper.SpawnVehicle(Config.TruckModel, Config.JobStart.Coordinates, Config.JobStart.Heading)

	SetPedIntoVehicle(playerId, truckId, -1)

	lastDropCoordinates = Config.JobStart.Coordinates

	jobStatus = CONST_WAITINGFORTASK
end)

RegisterNetEvent('xp:notification')
AddEventHandler('xp:notification', function(amount)
	TriggerEvent("pNotify:SendNotification", {
		text = "You have earned " .. amount .. " XP for the delivery.",
		type = "success",
		timeout = 10000,
		layout = "centerLeft",
		animation = {
			open = "gta_effects_fade_in",
			close = "gta_effects_fade_out",
		},
	})
end)
