function showAlert(message, playNotificationSound)
   SetTextComponentFormat('STRING')
   AddTextComponentString(message)
   DisplayHelpTextFromStringLabel(0, 0, playNotificationSound, -1)
end

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
