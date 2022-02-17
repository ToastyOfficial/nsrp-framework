blacklist = {
	"steam:110000136dc14de",
	"steam:110000106f6317e",
	"steam:110000131c76444",
	"steam:11000010cb130d3",
	"steam:110000103eb2799",
	"steam:110000105de2497",
	"steam:110000106c4ced1",
	"steam:110000110a80f28",
	"steam:1100001366e7991",
	"steam:11000010c092e7c",
	"steam:11000010eb355ab",
	"steam:11000013e242b3f",
	"steam:110000134a7b638",
	"steam:11000013f2c173a",
	"steam:11000010f69883f",
	"steam:110000100f04958",
	"steam:1100001329fc39c",
	"steam:11000013bc4d19c",
	"steam:110000117c92393",
	"steam:1100001130d1a57",
	"steam:11000010c833c13",
	"steam:11000011cb59853",
	"steam:110000143effcc9",
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
