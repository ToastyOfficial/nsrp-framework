fx_version 'cerulean'
games { 'gta5' }

-- Tell FiveM's NUI system what the main html file is for this resource
ui_page "nui/ui.html"

files {
	"nui/ui.html",
	"nui/ui.js",
	"nui/ui.css",
	"nui/Roboto.ttf"
}

client_scripts {
  'client.lua',
  'cl_action.lua',
	'data.lua',
}

server_scripts {
  'server.lua',
}

shared_scripts {
  'functions.lua',
}
