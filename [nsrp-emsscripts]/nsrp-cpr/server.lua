RegisterServerEvent('reviveServer')
AddEventHandler('reviveServer', function(closestID)
	TriggerClientEvent('reviveClient', closestID)
end)

RegisterServerEvent('reviveEMSCall')
AddEventHandler('reviveEMSCall', function(playerPed, message, x, y)
	TriggerClientEvent('paramedicEMSPageClient', -1, x, y)

    TriggerClientEvent('chatMessage', -1, '', {255, 255, 255}, '^8[SAFR]^2 ' .. GetPlayerName(source) .. '^0 has been reported incapacitated and needing CPR near ' .. message)
end)

RegisterServerEvent('createEMSBlipServer')
AddEventHandler('createEMSBlipServer', function(x, y, z)
	TriggerClientEvent('createEMSBlip', -1, x, y, z, GetPlayerName(source))
end)

RegisterServerEvent('messageveryonexd')
AddEventHandler('messageveryonexd', function()
    local Source = source
    TriggerClientEvent('chatMessage', -1, '', {255, 255, 255}, '^8[SAFR]^7 ' .. GetPlayerName(Source) .. ' just used the admin revive command')
end)
