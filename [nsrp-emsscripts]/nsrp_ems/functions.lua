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

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

-- get closest player's ID, and return that and their distance
function getNearestPlayerServerId()
  local pedResult = nil
  --print("getNearestPlayerServerId triggered")
  local playerPed = PlayerPedId()
  local playerLoc = GetEntityCoords(playerPed)

  local target = nil
  local activePlayers = GetActivePlayers()

  local lastDistance = 999
  local distance = nil

  for k, v in ipairs(activePlayers) do

    local targetPed = GetPlayerPed(v)
    local targetLoc = GetEntityCoords(targetPed)

		--print("Player Ped: "  .. playerPed)
		--print("Target Ped: " .. targetPed)

		if targetPed ~= playerPed then
			--print("Loop: " .. k)
			--print("Target ID: " .. GetPlayerServerId(v))
			--print("Player Location: " .. playerLoc)
			--print("Target Location: " .. targetLoc)


			distance = GetDistanceBetweenCoords(playerLoc, targetLoc)

			--print("LastDistance: ".. lastDistance)
			--print("Distance: " ..distance)
			if distance < lastDistance then
				lastDistance = distance
				--print("Was less")
				target = GetPlayerServerId(v)
        pedResult = targetPed
			end
		end
  end
  return target, pedResult, lastDistance
end

function showAlert(message, playNotificationSound)
   SetTextComponentFormat('STRING')
   AddTextComponentString(message)
   DisplayHelpTextFromStringLabel(0, 0, playNotificationSound, -1)
end

function tendAnimation(ped)
	local tendLoc = GetOffsetFromEntityInWorldCoords(ped, -0.6, 0.5, -1.0)
	SetEntityCoords(PlayerPedId(), tendLoc)
	local heading = GetHeadingFromVector_2d(tendLoc.x, tendLoc.y)
	print(heading)
	SetEntityHeading(PlayerPedId(), heading + -75)
	ExecuteCommand('e medic')
end

function setNoClip(bool)
  SetEntityCollision(PlayerPedId(), not bool, not bool)
  FreezeEntityPosition(PlayerPedId(), bool)
  SetEntityInvincible(PlayerPedId(), bool)
end
