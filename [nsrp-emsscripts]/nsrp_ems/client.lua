----------------------------
----------------------------
------- CPR AND SUCH -------
----------------------------
----------------------------

local tendRange = 3


local entity = Entity(PlayerPedId())
entity.state:set('cpr_tries', 0, true)
entity.state:set('tended', false, true)

patientPed = nil
patientPly = nil
local nearestPly = nil
local nearestePed = nil
local distance = nil
local myAmbulance = nil
local wasCuffed = false

local tending = false
local doingCPR = false
local tries = 0

-- looping thread to find nearest player
CreateThread(function()
	while true do
		if not tending then
			entity = Entity(PlayerPedId())

			nearestPly, nearestPed, distance = getNearestPlayerServerId()
			--print(nearestPly)
			--print(nearestPed)
			--print(distance)


		end
		--print("Am I Tended? " .. tostring(entity.state.tended))
		Wait(1000)
	end
end)

-- Draw marker on nearest dead ped
local sleep = 0
CreateThread(function()
	while true do Wait(sleep)
		if entity.state.job == 'ems' then
			if nearestPly then

					sleep = 0
					--local dead = target.state.dead
					--print(dead)

					if IsPedDeadOrDying(nearestPed) then
						local targetLoc = GetEntityCoords(nearestPed)
						local pedLoc = GetEntityCoords(PlayerPedId())

						local distance = #(targetLoc - pedLoc)
						if distance < tendRange then
							if myAmbulance then
								showAlert('Press ~INPUT_PICKUP~ to tend to patient.', true)
								if IsControlJustReleased(0, 38) then
									if myAmbulance then
										patientPed = nearestPed
										patientPly = nearestPly
										TriggerEvent('tend', nearestPly)
										TriggerServerEvent('patient:setStateTended', patientPly, true)
										setNoClip(true)
									end
								end
							else
								showAlert('You do not have a vehicle to transport the patient.', true)
							end
							DrawMarker(2, targetLoc.x, targetLoc.y, targetLoc.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 95, 112, 185, 100, true, true, 2, false, nil, nil, false)
						end
					end

			else
				sleep = 1000
			end
		else
			sleep = 1000
		end
	end
end)

RegisterNetEvent('ems:setAmbulance')
AddEventHandler('ems:setAmbulance', function(vehicle)
	print("Setting ambulance?")
	if GetVehicleClass(vehicle) == 18 then
		entity = Entity(PlayerPedId())
		if entity.state.job == 'ems' then
			print("My Ambulace : " .. vehicle)
			myAmbulance = vehicle
		end
	end
end)

-- start tending (revive entity, set them to laying down and disable controls?)
AddEventHandler('tend', function(target)
	print('test')
	--tending = true
	CreateThread(function()
		TriggerServerEvent('ems:revivePlayer', target, VehToNet(myAmbulance))
		Wait(200)

		print(myAmbulance)

		--print(myAmbulance)
		--print('Doing the thing')


		tendAnimation(patientPed)
		tending = true
		-- reset patient CPR tries
		TriggerServerEvent('patient:setCPR_Tries', patientPly, 0)

		-- Wait(4000)
		-- print('hello')
		-- print(patientPly)
		-- TriggerServerEvent('ems:falseRevive', patientPly)
		-- setNoClip(false)

		while true do Wait(0)
		--print(tending)
			if tending then

				if IsControlJustReleased(0, 73) then
					setNoClip(false)
					tending = false
					TriggerServerEvent('patient:setStateTended', patientPly, false)
					Wait(100)
					TriggerServerEvent('ems:falseRevive', patientPly)
					--TriggerServerEvent('patient:setCPR_Tries', patientPly, 0)

					patientPed = nil
					patientPly = nil
				end

				if not doingCPR then
					showAlert('Press ~INPUT_PICKUP~ to transport. Press ~INPUT_VEH_DUCK~ to help up.')
					--showAlert('Press ~INPUT_PICKUP~ to begin CPR. Press to stop tending.')
				end

			end
		end
	end)
end)



RegisterKeyMapping('e:cpr', "Begin CPR", 'keyboard', "E")
RegisterCommand('e:cpr', function()
	if tending then
		print('hello?')
		setNoClip(false)
		ExecuteCommand('e c')
		tending = false

		Wait(100)
		TriggerServerEvent('ems:falseRevive', patientPly)
		Wait(100)
		TriggerServerEvent('patient:setIntoAmbulance', nearestPly, VehToNet(myAmbulance))
	end
	-- if tending then
	-- 	local tries = patient.state.cpr_tries
	-- 	print(tries)
	--
	-- 	if tries < 10 then
	-- 		doingCPR = true
	-- 		local chance = math.random(0, 100)
	-- 		loadAnimDict("mini@cpr@char_a@cpr_str")
	-- 		loadAnimDict("mini@cpr@char_a@cpr_def")
	--
	-- 		TaskPlayAnim(PlayerPedId(), "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
	-- 		Citizen.Wait(7000)
	-- 		TaskPlayAnim(PlayerPedId(), "mini@cpr@char_a@cpr_def", "cpr_success", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
	--
	-- 		patient.state:set('cpr_tries', tries + 1, true)
	--
	-- 		if chance <= 25 then
	-- 			doingCPR = false
	-- 			tending = false
	-- 			TriggerServerEvent('ems:falseRevive', nearestPly) -- replace with strecher stuff
	-- 			TriggerEvent('chatMessage', '', {255, 255, 255}, '^8[SAFR] You successfully revived ^2' .. GetPlayerName(nearestPly) .. '^0 (' .. tries ..'/10 Used)')
	-- 			exports.nsrp_xp:addXP(target, 1000)
	-- 		else
	-- 			doingCPR = false
	-- 			TriggerEvent('chatMessage', '', {255, 255, 255}, '^8[SAFR]^0 You failed to revived ^3' .. GetPlayerName(nearestPly) .. '^0 try again! (' .. tries ..'/10 Used)')
	-- 			tendAnimation(nearestPed)
	-- 		end
	-- 	end
	-- end
end)

-- cpr command
	-- if patient then
	-- set tries state to 0
	-- perform cpr
	-- if fail set tries state to 1 and do fail stuff
	-- if success set tries state to 0 and do success stuff
		-- cancel ped animations and allow movement





-- Hospitalization
-- Hospital Markers
CreateThread(function()
	while true do
		Wait(sleep)
		local ped = PlayerPedId()

		local playerCoordinates = GetEntityCoords(ped)

		-- Find closest hospital
		local lastDistance = 9999
		closestHospital = nil

			for k, v in pairs(hospitals) do
			local distance = GetDistanceBetweenCoords(playerCoordinates, v.marker)

				if distance < lastDistance then
					lastDistance = distance
					--print(lastDistance)
					closestHospital = v
				end
			end

		-- Check distance of entity from closest spawner
		local distanceFromMarker = GetDistanceBetweenCoords(playerCoordinates, closestHospital.marker, false)
		--print("Distance from closest marker: ".. distanceFromMarker)

		if distanceFromMarker < 25 and patientPly then
			-- check/do every frame
			sleep = 0
			-- draw marker
			DrawMarker(1, closestHospital.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 95, 112, 185, 100, false, false, 2, true, nil, nil, false)
			-- is entity within marker (based on marker size)?
			if distanceFromMarker < 2.0 then
				showAlert('Press ~INPUT_PICKUP~ to hospitalize patient.', true)
				if IsControlJustReleased(0, 38) then
					TriggerServerEvent('hosPatient', patientPly)
					exports.nsrp_xp:addXP(GetPlayerServerId(Player(-1)), 2000)
					patientPed = nil
					patientPly = nil
				end
			end
		else
		-- if not close enough only check every second
			sleep = 1000
		end
	end
end)

------------------------------
------------------------------
------- PATIENT EVENTS -------
------------------------------
------------------------------

RegisterNetEvent('tendMe')
AddEventHandler('tendMe', function(vehicle)
	print('hello?')
	Wait(100)
	ExecuteCommand('e passout2') -- I SHOULD FIND THE ACTUAL ANIMATION AND DISABLE CONTROLS SO THEY CANT /E C
	setNoClip(true)
	wasCuffed = false

	entity = Entity(PlayerPedId())
	if entity.state.cuffed == true then
		wasCuffed = true
		entity.state:set('cuffed', false, true)
	end




end)

-- set me tended
RegisterNetEvent('setMeTended')
AddEventHandler('setMeTended', function(bool)
	entity = Entity(PlayerPedId())
	print(bool)

	entity.state:set('tended', bool, true)
end)

-- set my CPR tries
RegisterNetEvent('setMyCPR')
AddEventHandler('setMyCPR', function(tries)
	entity = Entity(PlayerPedId())
	entity.state:set('cpr_tries', tries, true)
end)

RegisterNetEvent('falseReviveMe')
AddEventHandler('falseReviveMe', function()

	-- need to cancel ped animations to allow them to stand up and move
	setNoClip(false)
	ExecuteCommand('e c')
end)

RegisterNetEvent('transportMe', function(vehicle)
	SetPedIntoVehicle(PlayerPedId(), NetToVeh(vehicle), 1)
end)

RegisterCommand('hpme', function()
	TriggerEvent('hosMe')
end)
-- Hospitalize me
RegisterNetEvent('hosMe')
AddEventHandler('hosMe', function()
	entity = Entity(PlayerPedId())
	entity.state:set('hospitalized', true, true)
	-- send to hospital bed
	local bedIndex = math.random(1,#closestHospital.beds)
	local bedLoc = closestHospital.beds[bedIndex].coords
	print(bedLoc)

	SetEntityCoords(entity, bedLoc)
	ExecuteCommand('e passout2')
	Wait(15000)
	SetEntityCoords(entity, closestHospital.out)
	entity.state:set('tended', false, true)
	ClearPedTasksImmediately(entity)
end)

-- Tended thread
CreateThread( function()
	while true do
		if entity.state.tended then
			DisableControlAction(0, 22, true) -- Jumping (SPACE)
			DisableControlAction(0, 23, true) -- Entering vehicle (F)
			DisableControlAction(0, 24, true) -- Punching/Attacking
			DisableControlAction(0, 29, true) -- Pointing (B)
			DisableControlAction(0, 30, true) -- Moving sideways (A/D)
			DisableControlAction(0, 31, true) -- Moving back & forth (W/S)
			DisableControlAction(0, 37, true) -- Weapon wheel
			DisableControlAction(0, 44, true) -- Taking Cover (Q)
			DisableControlAction(0, 140, true) -- Hitting your vehicle (R)
			DisableControlAction(0, 166, true) -- F5
			DisableControlAction(0, 168, true) -- F7
			DisableControlAction(0, 288, true) -- F1
			DisableControlAction(0, 289, true) -- F2
			DisableControlAction(1, 323, true) -- Handsup (X)
		end
		Wait(0)
	end
end)
----------------------------------
----------------------------------
------- ON DEATH EMS CALLS -------
----------------------------------
----------------------------------


RegisterNetEvent('createEMSBlip')
AddEventHandler('createEMSBlip', function(x, y, z, name)
	local entity = Entity(PlayerPedId())
	if entity.state.job == 'ems' then
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 61)
		SetBlipAsShortRange(blip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("~r~EMS Call: ~s~" .. name)
		EndTextCommandSetBlipName(blip)
		SetBlipColour(blip, 49)
		Citizen.Wait(1 * 60000) -- 1 Minute
		SetBlipAsMissionCreatorBlip(blip, false)
		RemoveBlip(blip)
		blip = nil
	end
end)

RegisterNetEvent('paramedicEMSPageClient')
AddEventHandler('paramedicEMSPageClient', function(x, y)
	--local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	--local vehicleClass = GetVehicleClass(vehicle)
	local entity = Entity(PlayerPedId())
	if entity.state.job == 'ems' then

		--if vehicleClass == 18 then
			SetNewWaypoint(x, y)
			PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
			Citizen.Wait(250)
			PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
			Citizen.Wait(250)
			PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
			TriggerEvent('chatMessage', '', {255, 255, 255}, '^8[SAFR]^0 A new EMS call has been issued!')
		--end
	end
end)

--------------------------------
--------------------------------
------- CLOCK IN AND OUT -------
--------------------------------
--------------------------------
local clockedIn = false

RegisterNetEvent('e:clockMeIn')
AddEventHandler('e:clockMeIn', function()

	CreateThread( function()
		local teleported = false
		ped = PlayerPedId()

		if not clockedIn then
			if not exports.nsrp_jobhandler:getHasJob() then
				-- Get AOP
				aop, aopText = exports.nsrp_aop_res:getAOP()
				print('AOP = ' .. aop)
				-- Teleport to PD based on AOP
				if aop == 1 then -- if AOP Blaine County
					teleported = exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, -386.31, 6125.27, 31.48) -- sets variable from return AND performs export interestingly
				elseif aop == 2 then -- if AOP Los Santos
					teleported = exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, 433.86, -974.28, 30.71)
				else -- if AOP Statewide
					local rand = math.random(1,2)
					if rand == 1 then
						teleported = exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, -386.31, 6125.27, 31.48)
					elseif rand == 2 then
						teleported = exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, 433.86, -974.28, 30.71)
					end
				end
				-- if teleport completed then
				if teleported then
				  showNotification('Clocked in!', 'success', 5000)
					clockedIn = true
					TriggerServerEvent('updateMedicCount', true)
					ExecuteCommand('eloadout')
					exports.nsrp_jobhandler:setHasJob(true)
				else -- if teleport did not complete
					showNotification('Complete teleport to clock in!', 'warning', 5000)
				end

			else -- if already has job
				showNotification('You already have another job', 'error', 5000)
			end
		else
			showNotification('Already clocked in.', 'warning', 5000)
		end
	end)
end)

RegisterNetEvent('e:tooMany')
AddEventHandler('e:tooMany', function()
	showNotification('There are too many medics, try again later.', 'error', 5000)
end)

RegisterNetEvent('e:noClockPerms')
AddEventHandler('e:noClockPerms', function()
	showNotification('You must be EMS to clock in. Apply in Discord.', 'error', 5000)
end)

RegisterNetEvent('e:clockMeOut')
AddEventHandler('e:clockMeOut', function()
	clockedIn = false
	exports.nsrp_jobhandler:setHasJob(false)
	TriggerServerEvent('updateMedicCount', false)
	showNotification('Clocked out.', 'success', 5000)
end)

RegisterNetEvent('e:returnClientClocked')
AddEventHandler('e:returnClientClocked', function()
	local entity = Entity(PlayerPedId())
	if entity.state.job == 'ems' then
		TriggerServerEvent('updateMedicCount', true)
	end
end)
