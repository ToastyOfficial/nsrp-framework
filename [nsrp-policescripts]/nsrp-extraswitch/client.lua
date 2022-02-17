mainOn = true
secOn = false
takeOn = false
steadyOn = false
warnOn = false
alleyOn = false
isPolice = false

local colors = {
	[true] = {130, 155, 220},
	[false] = {100, 100, 100}
}

local vehicleEnabled = false
local ambulance = false

function DrawAdvancedText(x,y ,w,h,sc, text, color,a,font,jus)
	local r, g, b = table.unpack(color)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

enabledVehicles= {
	'sp20',
	'sp16',
	'sp18chrg',
	'pd20',
	'pd16',
	'pd18chrg',
	'pdram',
	'rambulance2',

}

RegisterNetEvent('isVehicleEnabled')
AddEventHandler('isVehicleEnabled', function()

	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	local model = GetEntityModel(vehicle)
	--local hash = GetHashKey(model)


	for k, v in pairs(enabledVehicles) do
		print('My vehicle hash: ' .. model)

		print(GetHashKey(v))
		if model == GetHashKey(v) then -- if the vehicle is a supporter vehicle
			print('Vehicle found in table.')
			vehicleEnabled = true
			if v == 'rambulance2' then -- our ambulance needs this for some dumbass reason
				ambulance = true
			else
				ambulance = false
			end
			break
		else
			print('Vehicle not in table.')
			vehicleEnabled = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local vehClass = GetVehicleClass(veh)


		local ped = PlayerPedId()



		--if IsControlJustPressed(0, 124) then -- Numpad 4 Main Light Bar 7
			--local veh = GetVehiclePedIsIn(ped, false)
			--local ison = IsVehicleExtraTurnedOn(veh, 7)
			--SetVehicleAutoRepairDisabled(veh, not ambulance)
			--SetVehicleExtra(veh, 7, ison)
			--mainOn = not ison
		if IsControlJustPressed(0, 126) and isPolice then -- Numpad 5 Rear Flashers 8 ("Stage 2")

			PlaySoundFrontend(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1)
			local veh = GetVehiclePedIsIn(ped, false)
			local ison = IsVehicleExtraTurnedOn(veh, 8)
			SetVehicleAutoRepairDisabled(veh, not ambulance)
			SetVehicleExtra(veh, 8, ison)
			secOn = not ison

		elseif IsControlJustPressed(0, 125) and isPolice then -- Front Takedown Flashers 9 ("TA")
			PlaySoundFrontend(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1)
			local veh = GetVehiclePedIsIn(ped, false)
			local ison = IsVehicleExtraTurnedOn(veh, 9)
			SetVehicleAutoRepairDisabled(veh, not ambulance)
			SetVehicleExtra(veh, 9, ison)
			takeOn = not ison

		elseif IsControlJustPressed(0, 117) and isPolice then -- Cruise Lights 10 ("Aux")
			PlaySoundFrontend(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1)
			local veh = GetVehiclePedIsIn(ped, false)
			local ison = IsVehicleExtraTurnedOn(veh, 10)
			SetVehicleAutoRepairDisabled(veh, not ambulance)
			SetVehicleExtra(veh, 10, ison)
			steadyOn = not ison

		elseif IsControlJustPressed(0, 127) and isPolice then -- Yellow Rear Flashers 11 ("Aux 2")
			PlaySoundFrontend(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1)
			local veh = GetVehiclePedIsIn(ped, false)
			local ison = IsVehicleExtraTurnedOn(veh, 11)
			SetVehicleAutoRepairDisabled(veh, not ambulance)
			SetVehicleExtra(veh, 11, ison)
			warnOn = not ison

		elseif IsControlJustPressed(0, 118) and isPolice then -- Alley Lights 12 ("Scene")
			PlaySoundFrontend(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1)
			local veh = GetVehiclePedIsIn(ped, false)
			local ison = IsVehicleExtraTurnedOn(veh, 12)

			SetVehicleAutoRepairDisabled(veh, not ambulance)
			SetVehicleExtra(veh, 12, ison)
			alleyOn = not ison
			if ambulance then
				if alleyOn then
					TriggerEvent('c:sceneOn')
				else
					TriggerEvent('c:sceneOff')
				end
			end
		--elseif IsControlJustPressed(0, 96) then -- Fix Vehicle
			--local veh = GetVehiclePedIsIn(ped, false)
			--SetVehicleFixed(veh)
		end


		if IsPedInAnyVehicle(ped, true) and vehClass == 18 then
			if vehicleEnabled then
				isPolice = true
				DrawRect(0.485, 0.95, 0.160, 0.030, 0, 0, 0, 150)
				DrawAdvancedText(0.524, 0.955, 0.005, 0.0028, 0.3, "Stage 1", colors[mainOn], 255, 6, 0)
		    DrawAdvancedText(0.552, 0.955, 0.005, 0.0028, 0.3, "Stage 2", colors[secOn], 255, 6, 0)
		   	DrawAdvancedText(0.580, 0.955, 0.005, 0.0028, 0.3, "TA", colors[takeOn], 255, 6, 0)
		   	DrawAdvancedText(0.604, 0.955, 0.005, 0.0028, 0.3, "Aux", colors[steadyOn], 255, 6, 0)
		   	DrawAdvancedText(0.624, 0.955, 0.005, 0.0028, 0.3, "Aux 2", colors[warnOn], 255, 6, 0)
		   	DrawAdvancedText(0.642, 0.955, 0.005, 0.0028, 0.3, "Scene", colors[alleyOn], 255, 6, 0)
			else
				isPolice = false
			end
		else

			isPolice = false
		end
	end
end)


------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------
