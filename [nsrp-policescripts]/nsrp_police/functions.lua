function showAlert(message, playNotificationSound)
   SetTextComponentFormat('STRING')
   AddTextComponentString(message)
   DisplayHelpTextFromStringLabel(0, 0, playNotificationSound, -1)
end


-- get closest player's ID, and return that and their distance
function getNearestPlayerServerId()
  print("getNearestPlayerServerId triggered")
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
			end
		end
  end
  return target, lastDistance
end


function rotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end
