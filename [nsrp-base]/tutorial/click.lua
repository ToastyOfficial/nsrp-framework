
local servername = "NightShift RP";

local menuEnabled = false

AddEventHandler("playerSpawned", function(spawn)
  print("PlayerSpawned Event triggered")
   TriggerServerEvent('tutorial:firstspawn')
    end)

RegisterNetEvent("ToggleActionmenu")
AddEventHandler("ToggleActionmenu", function()
  SetEntityCoords(PlayerPedId(), -1044.25, -2748.89, 21.36, 1, 0, 0, 1)
	ToggleActionMenu()
end)

RegisterNetEvent("KillTutorialMenu")
AddEventHandler("KillTutorialMenu", function()
	killTutorialMenu()
end)

function ToggleActionMenu()
	Citizen.Trace("tutorial launch")
	menuEnabled = not menuEnabled
	if ( menuEnabled ) then
		SetNuiFocus( true, true )
		SendNUIMessage({
			showPlayerMenu = true
		})
	else
		SetNuiFocus( false )
		SendNUIMessage({
			showPlayerMenu = false
		})
	end
end

function killTutorialMenu()
SetNuiFocus( false )
		SendNUIMessage({
			showPlayerMenu = false
		})
		menuEnabled = false

end



RegisterNUICallback('close', function(data, cb)
  ToggleActionMenu()
  cb('ok')
end)


RegisterNUICallback('spawnButton', function(data, cb)

	TriggerEvent("tutorial:spawn", source)
	SetNotificationTextEntry("STRING")
  AddTextComponentString("~g~Tutorial completed. ~w~Welcome to ~b~".. servername .."~w~!")
  DrawNotification(true, false)
  	ToggleActionMenu()
  	SetNuiFocus( false )
		SendNUIMessage({
			showPlayerMenu = false
		})
  	cb('ok')
end)
