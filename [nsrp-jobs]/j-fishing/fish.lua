--flags
-- 'none' -- nothing
-- 'night' -- can only be caught at night
-- 'event' -- can only be caught when event is active

jobStarts = {
  { -- Alamo Sea Dock
    marker = vector3(1302.76, 4225.21, 32.90), -- Enter Marker
    spawn = vector3(1306.86, 4222.16, 30), -- Spawn spawnation
    h = 173.0,
    reset = vector3(1298.50, 4216.95, 32.90),
    level = 1,
    boat = 'dinghy2',
  },
  { -- Los Santos Dock
    marker = vector3(-862.75, -1323.8, 0.61), -- Enter Marker
    spawn = vector3(-857.65, -1326.01, -0.1), -- Spawn spawnation
    h = 110.41,
    reset = vector3(-845.56, -1318.53, 5.0),
    level = 20,
    boat = 'suntrap',
  },
  { -- Paleto Cove Ocean Dock
    marker = vector3(-1595.53, 5208.01, 3.31), -- Enter Marker
    spawn = vector3(-1602.77, 5259.57, 0.2), -- Spawn spawnation
    h = 21.58,
    reset = vector3(-1577.94, 5175.46, 19.51),
    level = 20,
    boat = 'suntrap',
  },
}

-- bonusZones = {
--   {loc = vector3(), size = 10},
--   {loc = vector3(), size = 10},
--   {loc = vector3(), size = 10},
--   {loc = vector3(), size = 10},
-- }

fishTypes = {
  'Common', 'Rare', 'Exotic'
}

-- Common
commonFish = {
  [0] = {
    name = 'Largemouth Bass',
    value = 25, -- XP per 1 size
    minSize = 8, -- Lowest possible size (inches)
    maxSize = 20,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Perch',
    value = 25, -- XP per 1 size
    minSize = 5, -- Lowest possible size (inches)
    maxSize = 15,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Carp',
    value = 25, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 26,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'American Shad',
    value = 25, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 24,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Black Bullhead',
    value = 25, -- XP per 1 size
    minSize = 6, -- Lowest possible size (inches)
    maxSize = 14,  -- Highest possible size (inches)
    flag = 'river'
  },
  {
    name = 'Black Crappie',
    value = 25, -- XP per 1 size
    minSize = 4, -- Lowest possible size (inches)
    maxSize = 12,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Blue Catfish',
    value = 25, -- XP per 1 size
    minSize = 25, -- Lowest possible size (inches)
    maxSize = 46,  -- Highest possible size (inches)
    flag = 'night'
  },
  {
    name = 'Blue Chub',
    value = 25, -- XP per 1 size
    minSize = 2, -- Lowest possible size (inches)
    maxSize = 8,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Bluegill',
    value = 25, -- XP per 1 size
    minSize = 4, -- Lowest possible size (inches)
    maxSize = 12,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Brook Trout',
    value = 25, -- XP per 1 size
    minSize = 9, -- Lowest possible size (inches)
    maxSize = 25,  -- Highest possible size (inches)
    flag = 'river'
  },
  {
    name = 'Brown Bullhead',
    value = 25, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 24,  -- Highest possible size (inches)
    flag = 'night'
  },
  {
    name = 'Brown Trout',
    value = 25, -- XP per 1 size
    minSize = 18, -- Lowest possible size (inches)
    maxSize = 28,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Bull Trout',
    value = 25, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 20,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Coastal Fall Chinook Salmon',
    value = 25, -- XP per 1 size
    minSize = 16, -- Lowest possible size (inches)
    maxSize = 24,  -- Highest possible size (inches)
    flag = 'river'
  },
  {
    name = 'Channel Catfish',
    value = 25, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 24,  -- Highest possible size (inches)
    flag = 'night'
  },
  {
    name = 'Chum Salmon',
    value = 25, -- XP per 1 size
    minSize = 14, -- Lowest possible size (inches)
    maxSize = 26,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Common Carp',
    value = 25, -- XP per 1 size
    minSize = 10, -- Lowest possible size (inches)
    maxSize = 20,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Flathaed Catfish',
    value = 25, -- XP per 1 size
    minSize = 20, -- Lowest possible size (inches)
    maxSize = 45,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Grass Carp',
    value = 25, -- XP per 1 size
    minSize = 20, -- Lowest possible size (inches)
    maxSize = 45,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Green Sunfish',
    value = 15, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 24,  -- Highest possible size (inches)
    flag = 'ocean'
  },
  {
    name = 'Lake Trout',
    value = 25, -- XP per 1 size
    minSize = 18, -- Lowest possible size (inches)
    maxSize = 36,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Lost River Sucker',
    value = 25, -- XP per 1 size
    minSize = 16, -- Lowest possible size (inches)
    maxSize = 32,  -- Highest possible size (inches)
    flag = 'river'
  },
  {
    name = 'Shortnose Sucker',
    value = 25, -- XP per 1 size
    minSize = 9, -- Lowest possible size (inches)
    maxSize = 18,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Pink Salmon',
    value = 25, -- XP per 1 size
    minSize = 10, -- Lowest possible size (inches)
    maxSize = 20,  -- Highest possible size (inches)
    flag = 'river'
  },
  {
    name = 'Readeye Bass',
    value = 25, -- XP per 1 size
    minSize = 5, -- Lowest possible size (inches)
    maxSize = 15,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Sacremento Perch',
    value = 25, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 24,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Spotted Bass',
    value = 25, -- XP per 1 size
    minSize = 10, -- Lowest possible size (inches)
    maxSize = 25,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Striped Bass',
    value = 100, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 33,  -- Highest possible size (inches)
    flag = 'none'
  },
}

-- Rare
rareFish = {
  [0] = {
    name = 'Bonytail',
    value = 100, -- XP per 1 size
    minSize = 6, -- Lowest possible size (inches)
    maxSize = 22,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'White Crappie',
    value = 100, -- XP per 1 size
    minSize = 6, -- Lowest possible size (inches)
    maxSize = 12,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Owlfish',
    value = 100, -- XP per 1 size
    minSize = 6, -- Lowest possible size (inches)
    maxSize = 18,  -- Highest possible size (inches)
    flag = 'night'
  },
  {
    name = 'Clear Lake Hitch',
    value = 200, -- XP per 1 size
    minSize = 6, -- Lowest possible size (inches)
    maxSize = 14,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Eulachon',
    value = 200, -- XP per 1 size
    minSize = 4, -- Lowest possible size (inches)
    maxSize = 12,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Mountain Whitefish',
    value = 100, -- XP per 1 size
    minSize = 8, -- Lowest possible size (inches)
    maxSize = 16,  -- Highest possible size (inches)
    flag = 'river'
  },
  {
    name = 'Starry Flounder',
    value = 200, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 36,  -- Highest possible size (inches)
    flag = 'night'
  },
  {
    name = 'White Bass',
    value = 100, -- XP per 1 size
    minSize = 9, -- Lowest possible size (inches)
    maxSize = 18,  -- Highest possible size (inches)
    flag = 'none'
  },
}

-- Exotic
exoticFish = {
  [0] = {
    name = 'Moonlight Trout',
    value = 500, -- XP per 1 size
    minSize = 6, -- Lowest possible size (inches)
    maxSize = 22,  -- Highest possible size (inches)
    flag = 'night'
  },
  {
    name = 'Golden Shiner',
    value = 500, -- XP per 1 size
    minSize = 2, -- Lowest possible size (inches)
    maxSize = 5,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'Albino Sturgion',
    value = 200, -- XP per 1 size
    minSize = 8, -- Lowest possible size (inches)
    maxSize = 20,  -- Highest possible size (inches)
    flag = 'none'
  },
  {
    name = 'White Sturgeon',
    value = 150, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 200,  -- Highest possible size (inches) v
    flag = 'ocean'
  },
  {
    name = 'Flourescent Parrotfish',
    value = 200, -- XP per 1 size
    minSize = 6, -- Lowest possible size (inches)
    maxSize = 20,  -- Highest possible size (inches) v
    flag = 'ocean' -- Ocean
  },
  {
    name = 'Regal Tang',
    value = 500, -- XP per 1 size
    minSize = 3, -- Lowest possible size (inches)
    maxSize = 12,  -- Highest possible size (inches) v
    flag = 'ocean' -- Ocean
  },
  {
    name = 'Swordfish',
    value = 100, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 176,  -- Highest possible size (inches) v
    flag = 'ocean' -- Ocean
  },
  {
    name = 'Spangled Emperor',
    value = 100, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 24,  -- Highest possible size (inches) v
    flag = 'ocean' -- Ocean
  },
  {
    name = 'White Marlin',
    value = 150, -- XP per 1 size
    minSize = 12, -- Lowest possible size (inches)
    maxSize = 96,  -- Highest possible size (inches)
    flag = 'ocean' -- ocean
  },
}
