blacklist = {
	"steam:000000000000000",
	"steam:000000000000000",
}


AddEventHandler('playerConnecting', function(playerName, setKickReason)
local numIds = GetNumPlayerIdentifiers(source)
	for i,blacklisted in ipairs(blacklist) do
		for i = 0, numIds-1 do
			if blacklisted == GetPlayerIdentifier(source,i) then
				setKickReason('You have been permanently banned from this server. This is probably non-negotiable.')
				print("Connection Refused Permanent Ban!\n")
				CancelEvent()
			end
		end
	end
end)
