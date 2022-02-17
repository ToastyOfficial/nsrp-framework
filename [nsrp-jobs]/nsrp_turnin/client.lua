----------------------
----------------------
------- CONFIG -------
----------------------
----------------------

local markerDrawDistance = 30
local markerUseDistance = 2
local callChance = 15

---------------------
---------------------
------- SETUP -------
---------------------
---------------------
local canCall = true
TriggerEvent('money:updateTurnInBlip')

-------------------------
-------------------------
------- FUNCTIONS -------
-------------------------
-------------------------

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

function moneyTxt()
  local messages = {
    "Sorry, had to pack up and move, got too hot here.",
    "We're packing up and moving, catch us at the new location.",
    "Shit got crazy, we're moving, Meet us at the new drop-off.",
    "Cops are on to us, we gotta move. Sent you the new address.",
    "Heat is too heavy here, cops all over. Moving to a new dig."
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
  local subtitle = "Money Bag Turn-In"
  local iconType = 0
  local flash = false -- Flash doesn't seem to work no matter what.
  EndTextCommandThefeedPostMessagetext('CHAR_MP_FAM_BOSS', 'CHAR_MP_FAM_BOSS', flash, iconType, "Collector", subtitle)

  -- Draw the notification
  local showInBrief = true
  local blink = false -- blink doesn't work when using icon notifications.
  EndTextCommandThefeedPostTicker(blink, showInBrief)

  -- Cleanup after yourself!
  UnregisterPedheadshot(handle)
end

function weedTxt()
  local messages = {
    "Sorry, had to pack up and move, got too hot here.",
    "We're packing up and moving, catch us at the new location.",
    "Shit got crazy, we're moving, Meet us at the new drop-off.",
    "Cops are on to us, we gotta move. Sent you the new address.",
    "Heat is too heavy here, cops all over. Moving to a new dig."
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

function tryCalling(message)
	canCall = false
	startCallTimer()
	print("trying to call")
	if math.random(1,100) < callChance then
		print("calling")
		ExecuteCommand('911 I think I see a drug deal going down come quick.')
	end
end

function startCallTimer()
	CreateThread(function()
		Wait(10000)
		canCall = true
		print("Cops could be called")
	end)
end

--------------------------
--------------------------
------- Money Bags -------
--------------------------
--------------------------

local moneyPed = nil
local moneyBlip = nil

RegisterNetEvent('money:updateTurnInBlip')
AddEventHandler('money:updateTurnInBlip', function()
  local player = Entity(PlayerPedId())
	canCall = true

  if player.state.iMoneyBags > 0 then
    print("I have the money bags")
    if moneyBlip then
      RemoveBlip(moneyBlip)
    end

    print("Blip : " .. GlobalState.moneyTurnIn)
    moneyBlip = makeBlip(GlobalState.moneyTurnIn.x, GlobalState.moneyTurnIn.y, 0.0, 500, 8, 'Money Bag Turn-In')
    SetBlipRoute(moneyBlip, true)
    SetBlipRouteColour(moneyBlip, 8)
    moneyTxt()

		local hash = GetHashKey('s_m_y_dealer_01')
		RequestModel(hash)
		while not HasModelLoaded(hash) do Wait(0) end
		moneyPed = CreatePed(28, hash, GlobalState.moneyTurnIn.x, GlobalState.moneyTurnIn.y, GlobalState.moneyTurnIn.z, 0.0, false, false)
		TaskTurnPedToFaceEntity(moneyPed, PlayerPedId(), -1)
  else
    if moneyBlip then
      RemoveBlip(moneyBlip)
    end
  end
end)

CreateThread(function()
  local sleep = 1000
  local setPlayer = true
  local player = Entity(PlayerPedId())
  local cooldown = false

	player.state:set('iMoneyBags', 0, true)
	Wait(1000)

  while true do Wait(sleep)
		--print('thread?')
    if setPlayer then
			--print("set player")
      player = Entity(PlayerPedId())
    end
		--print("My money bags: " .. player.state.iMoneyBags)
    if player.state.iMoneyBags > 0 then
      local playerCoordinates = GetEntityCoords(PlayerPedId())
      local distanceFromBlip = GetDistanceBetweenCoords(playerCoordinates.x, playerCoordinates.y, playerCoordinates.z, GlobalState.moneyTurnIn.x, GlobalState.moneyTurnIn.y, GlobalState.moneyTurnIn.z, true)

      --print()
      --print("Player: " .. playerCoordinates)
      --print("TurnIn: " .. GlobalState.moneyTurnIn)
      --print("Distance: " .. distanceFromBlip)
      if distanceFromBlip < markerDrawDistance then
        --print("Drawing marker")
        sleep = 0
        setPlayer = false
				if canCall then
					tryCalling()
				end
        DrawMarker(1, GlobalState.moneyTurnIn.x, GlobalState.moneyTurnIn.y, GlobalState.moneyTurnIn.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 95, 112, 185, 100, false, true, 2, false, nil, nil, false)

        if distanceFromBlip < markerUseDistance then
          showAlert('Press ~INPUT_PICKUP~ to deliver money bag.', true)

          if IsControlJustReleased(0, 38) then

            TriggerServerEvent('i:takeItem', GetPlayerServerId(PlayerId()), "iMoneyBags", 1)
            TriggerServerEvent('turnin:xp', GetPlayerServerId(PlayerId()), 4000)
            TriggerServerEvent('money:updateTurnIn')
						TaskWanderStandard(moneyPed, 10.0, 10)
          end
        end
      else
        sleep = 1000
        setPlayer = true
      end
		else
			sleep = 1000
			setPlayer = true
    end
  end
end)

CreateThread(function()
  while true do Wait(4000)
    local player = Entity(PlayerPedId())
    if player.state.iMoneyBags == 0 then
      if moneyBlip then
        RemoveBlip(moneyBlip)
      end
    end
  end
end)


--------------------------
--------------------------
---------- WEED ----------
--------------------------
--------------------------

local weedPed = nil
local weedBlip = nil

RegisterNetEvent('weed:updateTurnInBlip')
AddEventHandler('weed:updateTurnInBlip', function(sendMsg)
	print('weed update triggered')
  local player = Entity(PlayerPedId())
	canCall = true

  if player.state.iWeed > 0 then
    print("I have weed")
    if weedBlip then
      RemoveBlip(weedBlip)
    end

    print("Blip : " .. GlobalState.weedTurnIn)
    weedBlip = makeBlip(GlobalState.weedTurnIn.x, GlobalState.weedTurnIn.y, 0.0, 496, 8, 'Weed Buyer')
    SetBlipRoute(weedBlip, true)
    SetBlipRouteColour(weedBlip, 8)

		if sendMsg then
    	weedTxt()
		end

		local hash = GetHashKey('s_m_y_dealer_01')
		RequestModel(hash)
		while not HasModelLoaded(hash) do Wait(0) end
		weedPed = CreatePed(28, hash, GlobalState.weedTurnIn.x, GlobalState.weedTurnIn.y, GlobalState.weedTurnIn.z, 0.0, false, false)
		TaskTurnPedToFaceEntity(weedPed, PlayerPedId(), -1)
  else
    if weedBlip then
      RemoveBlip(weedBlip)
    end
  end
end)

CreateThread(function()
  local sleep = 1000
  local setPlayer = true
  local player = Entity(PlayerPedId())
  local cooldown = false

	player.state:set('iWeed', 0, true)
	Wait(1000)

  while true do Wait(sleep)
		--print('thread?')
    if setPlayer then
			--print("set player")
      player = Entity(PlayerPedId())
    end
		--print("My weed: " .. player.state.iWeed)
    if player.state.iWeed > 0 then
      local playerCoordinates = GetEntityCoords(PlayerPedId())
      local distanceFromBlip = GetDistanceBetweenCoords(playerCoordinates.x, playerCoordinates.y, playerCoordinates.z, GlobalState.weedTurnIn.x, GlobalState.weedTurnIn.y, GlobalState.weedTurnIn.z, true)

      --print()
      --print("Player: " .. playerCoordinates)
      --print("TurnIn: " .. GlobalState.moneyTurnIn)
      --print("Distance: " .. distanceFromBlip)
      if distanceFromBlip < markerDrawDistance then
        --print("Drawing marker")
        sleep = 0
        setPlayer = false
				if canCall then
					tryCalling()
				end
        DrawMarker(1, GlobalState.weedTurnIn.x, GlobalState.weedTurnIn.y, GlobalState.weedTurnIn.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 95, 112, 185, 100, false, true, 2, false, nil, nil, false)

        if distanceFromBlip < markerUseDistance then
          showAlert('Press ~INPUT_PICKUP~ to sell weed.', true)

          if IsControlJustReleased(0, 38) then
						local reward = math.random(3,60) * player.state.iWeed
						print(reward)

            TriggerServerEvent('i:takeItem', GetPlayerServerId(PlayerId()), "iWeed", player.state.iWeed)
            TriggerServerEvent('turnin:xp', GetPlayerServerId(PlayerId()), reward)
						-- TaskWanderStandard(weedPed, 10.0, 10)
          end
        end
      else
        sleep = 1000
        setPlayer = true
      end
		else
			sleep = 1000
			setPlayer = true
    end
  end
end)

CreateThread(function()
  while true do Wait(4000)
    local player = Entity(PlayerPedId())
    if player.state.iWeed == 0 then
      if weedBlip then
        RemoveBlip(weedBlip)
      end
    end
  end
end)
