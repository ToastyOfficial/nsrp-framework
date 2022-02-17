--[[------------------------------------------------------------------------

	ActionMenu - v1.0.1
	Created by WolfKnight
	Additional help from lowheartrate, TheStonedTurtle, and Briglair.

------------------------------------------------------------------------]]--

-- Define the variable used to open/close the menu
local menuEnabled = false
clockedIn = false

-- AOP
aop = nil
aopText = nil
-- Other Variables
local sz = nil -- for traffic control (sz = speed zone)

local teleported = false -- for clock in logic

--[[------------------------------------------------------------------------
	ActionMenu Toggle
	Calling this function will open or close the ActionMenu.
------------------------------------------------------------------------]]--
function ToggleActionMenu()
	-- Make the menuEnabled variable not itself
	-- e.g. not true = false, not false = true
	local player = Entity(PlayerPedId())
	if player.state.job == 'leo' then
		menuEnabled = not menuEnabled

		if ( menuEnabled ) then
			-- Focuses on the NUI, the second parameter toggles the
			-- onscreen mouse cursor.
			SetNuiFocus( true, true )

			-- Sends a message to the JavaScript side, telling it to
			-- open the menu.
			SendNUIMessage({
				showmenu = true
			})
		else
			-- Bring the focus back to the game
			SetNuiFocus( false )

			-- Sends a message to the JavaScript side, telling it to
			-- close the menu.
			SendNUIMessage({
				hidemenu = true
			})
		end
	else -- if not clocked in
		--showNotification('You must use /clockin in to open the LEO menu!', 'error', 5000)
	end
end

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

local function getClosestPlayerId()
	local playerPed = PlayerPedId()
  local playerLoc = GetEntityCoords(playerPed)

  local target = nil
  local activePlayers = GetActivePlayers()
  local lastDistance = 999
	local distance = nil

  for k, v in ipairs(activePlayers) do

    local targetPed = GetPlayerPed(v)
    local targetLoc = GetEntityCoords(targetPed)

		print("Player Ped: "  .. playerPed)
		print("Target Ped: " .. targetPed)

		if targetPed ~= playerPed then
			print("Loop: " .. k)
			print("Target ID: " .. GetPlayerServerId(v))
			print("Player Location: " .. playerLoc)
			print("Target Location: " .. targetLoc)

			distance = GetDistanceBetweenCoords(playerLoc, targetLoc)

			print("LastDistance: ".. lastDistance)
			print("Distance: " ..distance)
			if distance < lastDistance then
				lastDistance = distance
				print("Was less")
				target = GetPlayerServerId(v)
			end
		end
  end
	return target, lastDistance
end

--[[------------------------------------------------------------------------
	ActionMenu HTML Callbacks
	This will be called every single time the JavaScript side uses the
	sendData function. The name of the data-action is passed as the parameter
	variable data.
------------------------------------------------------------------------]]--
RegisterNUICallback( "ButtonClick", function( data, cb )
	if ( data == "b_cuff" ) then
	ExecuteCommand('cuff')
	elseif ( data == "b_escort" ) then
		ExecuteCommand('drag')
	elseif ( data == "b_put" ) then
		--showNotification('This is not yet functional, please use /seat [ID]', 'error', 5000)
		-- local target = getClosestPlayerId()
		-- print("Target :" .. target)
		ExecuteCommand('seat')
	elseif ( data == "b_remove" ) then
		--	showNotification('This is not yet functional, please use /unseat [ID]', 'error', 5000)
		-- local target = getClosestPlayerId()
		-- print("Target :" .. target)
		ExecuteCommand('unseat')
	-- Open MDT
	elseif ( data == "b_mdt" ) then
		ExecuteCommand('mdt')

	-- Open radar
	elseif ( data == "b_radar" ) then
		CreateThread( function() -- Add async to fix NUI cursor compatibility issue
			Wait(100)
			if IsPedInAnyVehicle(PlayerPedId()) then
				--ExecuteCommand('radar_remote')
				TriggerEvent('wk:openRemote')
			else
				showNotification('You must be in a police vehicle to open the radar.', 'error', 5000)
			end
		end)

	--[[ TRAFFIC CONTROL SCRIPT BUTTONS ]]
	-- Stop the traffics
	elseif ( data == "b_stopTraffic" ) then
		--ExecuteCommand('stopTraffic')

	-- Slow the traffics
	elseif ( data == "b_slowTraffic" ) then
		--ExecuteCommand('slowTraffic')

	-- Resume the traffics
	elseif ( data == "b_resumeTraffic" ) then
		--ExecuteCommand('resTraffic')




		-- We toggle the ActionMenu and return here, otherwise the function
		-- call below would be executed too, which would just open the menu again
		ToggleActionMenu()
		return
	end

	-- This will only be called if any button other than the exit button is pressed
	ToggleActionMenu()
end )


--[[------------------------------------------------------------------------
	ActionMenu Control and Input Blocking
	This is the main while loop that opens the ActionMenu on keypress. It
	uses the input blocking found in the ES Banking resource, credits to
	the authors.
------------------------------------------------------------------------]]--

--[[ ---------------------------------------------
-------------- COMMANDS AND EVENTS----------------
]]------------------------------------------------

-- CLOCK IN AND OUT

RegisterNetEvent('p:clockMeIn')
AddEventHandler('p:clockMeIn', function()

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
					teleported = exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, 1854.65, 3681.32, 34.27) -- sets variable from return AND performs export interestingly
				elseif aop == 2 then -- if AOP Los Santos
					teleported = exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, 433.86, -974.28, 30.71)
				else -- if AOP Statewide
					local rand = math.random(1,2)
					if rand == 1 then
						teleported = exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, 1854.65, 3681.32, 34.27)
					elseif rand == 2 then
						teleported = exports.nsrp_tp:nsrpTeleport(GetPlayerPed(-1), 3, 433.86, -974.28, 30.71)
					end
				end
				-- if teleport completed then
				if teleported then
				  showNotification('Clocked in!', 'success', 5000)
					clockedIn = true
					TriggerServerEvent('updateCopCount', true)
					exports.nsrp_jobhandler:setHasJob(true)
					ExecuteCommand('ploadout')
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

RegisterNetEvent('p:noClockPerms')
AddEventHandler('p:noClockPerms', function()
	showNotification('You must be a cop to clock in. Apply in Discord.', 'error', 5000)
end)

RegisterNetEvent('p:tooMany')
AddEventHandler('p:tooMany', function()
	showNotification('There are too many cops, try again later.', 'error', 5000)
end)


RegisterNetEvent('p:clockMeOut')
AddEventHandler('p:clockMeOut', function()
	clockedIn = false
	exports.nsrp_jobhandler:setHasJob(false)
	TriggerServerEvent('updateCopCount', false)
	showNotification('Clocked out.', 'success', 5000)
end)


RegisterKeyMapping('open_pMenu', "Open LEO Menu", 'keyboard', 'F3')
RegisterCommand('open_pMenu', function()
	ToggleActionMenu()
end)


--[[--------------------------------------------------
				THREADS
-----------------------------------------------------]]

Citizen.CreateThread( function()
	-- This is just in case the resources restarted whilst the NUI is focused.
	SetNuiFocus( false )

	while true do
	    if ( menuEnabled ) then
            local ped = GetPlayerPed( -1 )

            DisableControlAction( 0, 1, true ) -- LookLeftRight
            DisableControlAction( 0, 2, true ) -- LookUpDown
            DisableControlAction( 0, 24, true ) -- Attack
            DisablePlayerFiring( ped, true ) -- Disable weapon firing
            DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
            DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride
        end
		Citizen.Wait( 0 )
	end
end )

function chatPrint( msg )
	TriggerEvent( 'chatMessage', "ActionMenu", { 255, 255, 255 }, msg )
end

function getClocked()
	return clockedIn
end

RegisterNetEvent('returnClientClocked')
AddEventHandler('returnClientClocked', function()
	local player = Entity(PlayerPedId())
	if player.state.job == 'leo' then
		TriggerServerEvent('updateCopCount', true)
	end
end)
