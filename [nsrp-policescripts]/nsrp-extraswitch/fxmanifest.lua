fx_version 'cerulean'
games { 'gta5' }

ui_page('client/html/index.html')

files {
 "client/html/index.html",
 "client/html/sounds/click.ogg",
}

client_scripts {
 'client.lua',
 'client/main.lua',
}

server_scripts {
  'server/main.lua',
}
