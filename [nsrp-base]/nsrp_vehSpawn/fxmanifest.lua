fx_version 'cerulean'
games { 'gta5' }

ui_page "nui/ui.html"

files {
 "nui/ui.html",
 "nui/ui.js",
 "nui/ui.css",
 "nui/Roboto.ttf",
 "nui/config.css"
}

client_scripts {
 'cl_action.lua',
 'data.lua',
 'saving_c.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
  'saving_s.lua',
}

export "returnClosestSpawner" -- client
