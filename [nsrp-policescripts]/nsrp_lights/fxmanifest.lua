fx_version 'cerulean'
games { 'gta5' }

-- Tell FiveM's NUI system what the main html file is for this resource
ui_page "ui/lights.html"

-- Add the files that need to be used/loaded
files {
	"ui/lights.html",
	"ui/lights.js",
	"ui/lights.css",
}

-- Initiate the clientside lua script
client_scripts {
	'client.lua',
}

server_scripts {
	'server.lua',
}
