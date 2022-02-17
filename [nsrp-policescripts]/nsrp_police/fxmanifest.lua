fx_version 'cerulean'
games { 'gta5' }

-- Tell FiveM's NUI system what the main html file is for this resource
ui_page "nui/ui.html"

-- Add the files that need to be used/loaded
files {
	"nui/ui.html",
	"nui/ui.js",
	"nui/ui.css",
	"nui/Roboto.ttf"
}

-- Initiate the clientside lua script
client_scripts {
	'client.lua',
	'cl_action.lua',
	'functions.lua',
	'commands/cuff.lua',
	'commands/drag.lua',
	'commands/seat.lua',
	'commands/jail.lua',
	'lights/lights_c.lua',
	'lights/lights_data.lua',
}

server_scripts {
	'server.lua',
	'commands/jailserver.lua',
	'lights/lights_s.lua',
}

export 'getClocked' --client
