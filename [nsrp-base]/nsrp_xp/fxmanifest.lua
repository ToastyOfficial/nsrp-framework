fx_version 'adamant'

game 'gta5'

-- description 'NSRP XP Rank System'
--
-- author 'Night Shift Studios'
--
-- version '1.2'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    -- 'utils.lua',
    'server/main.lua'
}

client_scripts {
    'config.lua',
    -- 'utils.lua',
    'client/main.lua',
}

ui_page 'ui/xp.html'

files {
  'ui/xp.html',
  'ui/xp.css',
  'ui/xp.js'
}


export 'addXP'
export 'removeXP'
export 'setXP'
export 'getPlayerLevel'
-- client
export 'getLevel'
