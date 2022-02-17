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
	if player.state.job == 'ems' then
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
	if ( data == "b_tend" ) then

	elseif ( data == "b_remFromAmb" ) then
		ClearPedTasksImmediately(patientPed)
	elseif ( data == "b_strecher" ) then

	elseif ( data == "b_doors" ) then
		ExecuteCommand('trunk')
		ExecuteCommand('door 3')
		ExecuteCommand('door 4')
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


-- RegisterNetEvent('p:noClockPerms')
-- AddEventHandler('p:noClockPerms', function()
-- 	showNotification('You must be a cop to clock in. Apply in Discord.', 'error', 5000)
-- end)
--
-- RegisterNetEvent('p:tooMany')
-- AddEventHandler('p:tooMany', function()
-- 	showNotification('There are too many cops, try again later.', 'error', 5000)
-- end)
--
--
-- RegisterNetEvent('p:clockMeOut')
-- AddEventHandler('p:clockMeOut', function()
-- 	clockedIn = false
-- 	exports.nsrp_jobhandler:setHasJob(false)
-- 	TriggerServerEvent('updateCopCount', false)
-- 	showNotification('Clocked out.', 'success', 5000)
-- end)
--
--
RegisterKeyMapping('open_eMenu', "Open EMS Menu", 'keyboard', 'F5')
RegisterCommand('open_eMenu', function()
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
