weedPlants = {}

local tries = 0

RegisterNetEvent('removePlant')
AddEventHandler('removePlant', function(id)
	print('got remove event for ID: ' .. id)
	TriggerClientEvent('c:removePlant', -1, id)
	for k, v in pairs(weedPlants) do
		if v.id == id then
			print('Found ID in server table.')
			table.remove(weedPlants, k)
		end
	end
end)

--periodic spawning
CreateThread(function()
	while true do Wait(10000)
		tries = 0
		local players = GetPlayers()
		if #players > 0 then
			while not trySpawningPlant() do
			end
		end
	end
end)

function trySpawningPlant()

	local aopPlants = possiblePlants[GlobalState.aop]
	local newMarker = aopPlants[math.random(1, #aopPlants)].marker
	local newId = math.random(1,99999)

	local newPlant = {marker = newMarker,
		id = newId,
	}

	local isDuplicate = false


	Wait(500)
	for k, v in pairs(weedPlants) do -- i'm checking only if it has the same coords as the first item, not all items
		--print("Markers: " .. v.marker .. " | " .. newPlant.marker)
		--print("Markers: " .. v.id .. " | " .. newPlant.id)
		if v.marker == newPlant.marker or v.id == newId then
			tries = tries + 1
			--print("DUPLICATE PLANT, Tries: " .. tries)
			return
		end
		if tries > 15 then
			--print("20 Tries, fields probably full")
			return true
		end
	end

	TriggerClientEvent('spawnWeedPlant', -1, vector3(newPlant.marker.x, newPlant.marker.y, newPlant.marker.z - 1.0), newId)
	table.insert(weedPlants, newPlant)
	print('Made new weed plant @ ' .. newPlant.marker .. " with ID: " .. newId)
	return true

end
