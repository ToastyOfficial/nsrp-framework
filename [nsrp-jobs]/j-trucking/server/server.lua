--
-- Functions
--

function getXP(playerId)
	-- Insert your framework's method here.
	return(1000)
end

-- client export => can be called on client side only
-- server export => can be called on server side only
function addXP(playerId, payout)
    exports.nsrp_xp:addXP(playerId, payout)
		TriggerClientEvent('xp:notification', payout)
    return true
end

function removeXP(playerId, amount)
	-- Insert your framework's method here.
	return true
end

--
-- Events
--

-- Job success (delivery)

RegisterNetEvent('encore_trucking:loadDelivered')
AddEventHandler('encore_trucking:loadDelivered', function(totalRouteDistance)
	local playerId = source
	local payout   = math.floor(totalRouteDistance * Config.PayPerMeter)

	addXP(playerId, payout)

	TriggerClientEvent('encore_trucking:helper:showNotification', playerId, 'Earned ' .. payout .. ' XP from delivery.')

end)

-- Getting truck

RegisterNetEvent('encore_trucking:rentTruck')
AddEventHandler('encore_trucking:rentTruck', function()
	local playerId = source

	if getXP(playerId) < Config.TruckRentalPrice then
		TriggerClientEvent('encore_trucking:helper:showNotification', playerId, 'You do not have enough XP to rent a truck.')
		return
	end

	removeXP(playerId, Config.TruckRentalPrice)

	TriggerClientEvent('encore_trucking:startJob', playerId)
end)

-- Returning truck

RegisterNetEvent('encore_trucking:returnTruck')
AddEventHandler('encore_trucking:returnTruck', function()
	local playerId = source

	--addXP(playerId, Config.TruckRentalPrice)

	--TriggerClientEvent('encore_trucking:helper:showNotification', playerId, 'Your ' .. Config.TruckRentalPrice .. ' XP was returned to you.')
end)
