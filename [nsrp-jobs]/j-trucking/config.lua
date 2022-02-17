--
-- Constants
--

CONST_NOTWORKING     = 0
CONST_WAITINGFORTASK = 1
CONST_PICKINGUP      = 2
CONST_DELIVERING     = 3

--
-- Configuration
--

Config = {}

Config.TruckRentalPrice = 500
Config.TruckModel       = 'packer'
Config.PayPerMeter      = .80

Config.JobStart = {
	Coordinates = vector3(158.91, 2756.45, 42.27),
	Heading     = 274.0,
}

Config.Blip = {
	SpriteID = 477,
	ColorID  = 0,
	Scale    = 0.9,
}

Config.Marker = {
	DrawDistance = 100.0,
	Size = vector3(4.0, 4.0, 2.0),
	Color = {
		r = 102,
		g = 102,
		b = 204,
	},
	Type = 1,
}

-- tanker = oil tanker
-- tvtrailer = Fame or Shame trailer
-- trailers3 = Big Goods trailer
-- trailers2 = multiple food trailers
-- trailers4 = blank rusty trailer
-- trailers = blank trailer
-- trflat = emtpy flatbed trailer
-- tr4 = car trailer
-- tr2 = empty car trailer
-- tr3 = sailboat trailer
-- docktrailer = Blank dock box trailer
-- armytrailer2 = Flatbed with excavator
-- trailerlogs

Config.Routes = {
	-- Blaine County
	-- Oil Pickup
	{
		TrailerModel      = 'tanker',
		PickupCoordinates = vector3(299.38, 2889.27, 42.61),
		PickupHeading     = 210.0,
		Destinations = {
			vector3(2764.09, 1706.93, 23.59), -- Power plant (856)
			vector3(2698.39, 3283.81, 54.24), -- Senora Gas station (815)
			vector3(-2534.03, 2341.78, 33.05), -- Gas station (830)
			vector3(201.32, 6608.47, 31.66), -- Paleto Gas station (711)
			vector3(31.68, 6284.37, 30.25),	-- Paleto Train yard (708)
			vector3(2904.73, 4379.47, 49.37),	-- Power plant (919)
			vector3(1703.94, 4946.21, 41.36),	-- Grapeseed gas (902)
			vector3(2108.99, 4774.33, 40.00), -- grapeseed airfield 906
		}
	},
	-- Oil pickup 2
	{
		TrailerModel      = 'tanker',
		PickupCoordinates = vector3(2909.21, 4363.66, 49.32),
		PickupHeading     = 20.91,
		Destinations = {
			vector3(2764.09, 1706.93, 23.59), -- Power plant (856)
			vector3(2698.39, 3283.81, 54.24), -- Senora Gas station (815)
			vector3(-2534.03, 2341.78, 33.05), -- Gas station (830)
			vector3(201.32, 6608.47, 31.66), -- Paleto Gas station (711)
			vector3(31.68, 6284.37, 30.25),	-- Paleto Train yard (708)
			vector3(2904.73, 4379.47, 49.37),	-- Power plant (919)
			vector3(1703.94, 4946.21, 41.36),	-- Grapeseed gas (902)
			vector3(2108.99, 4774.33, 40.00), -- grapeseed airfield 906
		}
	},
	-- Logs pickup
	{
		TrailerModel      = 'trailerlogs',
		PickupCoordinates = vector3(-597.43, 5299.10, 69.27),
		PickupHeading     = 7.24,
		Destinations = {
			vector3(2326.20, 4935.39, 41.69), -- 910
			vector3(2664.43, 3533.99, 52.12), -- You Tool (815)
			vector3(1210.68, 1865.51, 78.92), -- 857 small factory
			vector3(31.68, 6284.37, 30.25),	-- Paleto Train yard (708)
			vector3(2244.43, 5137.48, 55.10), -- 908
			vector3(350.44, 4460.88, 62.55), -- 900
		}
	},
	-- misc goods pickup (paleto)
	{
		TrailerModel      = 'trailers',
		PickupCoordinates = vector3(-279.15, 6032.87, 30.50),
		PickupHeading     = 42.44,
		Destinations = {
			vector3(2664.43, 3533.99, 52.12), -- You Tool (815)
			vector3(2764.09, 1706.93, 23.59), -- Power plant (856)
			vector3(-68.57, 6499.76, 31.49), -- Store, Paleto 707
			vector3(129.82, 6625.31, 31.74), -- Paleto gas 711
			vector3(-769.12, 5526.77, 32.48), -- ATV cabin paleto
			vector3(3566.89, 3656.15, 33.89), -- Science lab
			vector3(2532.92, 2634.61, 36.94), -- Rex's Diner
			vector3(1851.91, 2721.44, 44.94), -- Prison
			vector3(1210.68, 1865.51, 78.92), -- 857 small factory
			vector3(589.58, 2796.50, 42.043), -- route 68 supermarket
			vector3(276.99, 2857.47, 43.64), -- 841 factory near job start
			vector3(-2223.04, 4234.62, 46.97), -- hookies restaurant 831
			vector3(-681.49, 5781.91, 17.33), -- paleto lodge 701
			vector3(2108.99, 4774.33, 40.00), -- grapeseed airfield
			vector3(1768.02, 3308.26, 40.16), -- sandy airfield 808
			vector3(877.41, 2183.53, 50.71), -- 844 barn
			vector3(-2534.03, 2341.78, 33.05), -- Gas station (830)
		}
	},
	-- misc 2 (senora)
	{
		TrailerModel      = 'trailers',
		PickupCoordinates = vector3(2893.48, 4381.72, 49.36),
		PickupHeading     = 289.80,
		Destinations = {
			vector3(2664.43, 3533.99, 52.12), -- You Tool (815)
			vector3(31.68, 6284.37, 30.25),	-- Paleto Train yard (708)
			vector3(2764.09, 1706.93, 23.59), -- Power plant (856)
			vector3(-68.57, 6499.76, 31.49), -- Store, Paleto 707
			vector3(129.82, 6625.31, 31.74), -- Paleto gas 711
			vector3(-769.12, 5526.77, 32.48), -- ATV cabin paleto
			vector3(3566.89, 3656.15, 33.89), -- Science lab
			vector3(2532.92, 2634.61, 36.94), -- Rex's Diner
			vector3(1851.91, 2721.44, 44.94), -- Prison
			vector3(1210.68, 1865.51, 78.92), -- 857 small factory
			vector3(589.58, 2796.50, 42.043), -- route 68 supermarket
			vector3(276.99, 2857.47, 43.64), -- 841 factory near job start
			vector3(-2223.04, 4234.62, 46.97), -- hookies restaurant 831
			vector3(-681.49, 5781.91, 17.33), -- paleto lodge 701
			vector3(2108.99, 4774.33, 40.00), -- grapeseed airfield
			vector3(1768.02, 3308.26, 40.16), -- sandy airfield 808
			vector3(877.41, 2183.53, 50.71), -- 844 barn
			vector3(-2534.03, 2341.78, 33.05), -- Gas station (830)
		}
	},
	-- food (paleto)
	{
		TrailerModel      = 'trailers2',
		PickupCoordinates = vector3(-121.18, 6215.38, 30.20),
		PickupHeading     = 88.33,
		Destinations = {
			vector3(2664.43, 3533.99, 52.12), -- You Tool (815)
			vector3(-68.57, 6499.76, 31.49), -- Store, Paleto 707
			vector3(2532.92, 2634.61, 36.94), -- Rex's Diner
			vector3(1851.91, 2721.44, 44.94), -- Prison
			vector3(589.58, 2796.50, 42.043), -- route 68 supermarket
			vector3(-2223.04, 4234.62, 46.97), -- hookies restaurant 831
			vector3(-681.49, 5781.91, 17.33), -- paleto lodge 701
			vector3(-2534.03, 2341.78, 33.05), -- Gas station (830)
		}
	},
	-- Los Santos
	-- Car delivery 1
	-- {
	-- 	TrailerModel      = 'tr4',
	-- 	PickupCoordinates = vector3(508.94, -3047.27, 6.32),
	-- 	PickupHeading     = 0.0,
	-- 	Destinations = {
	-- 		vector3(-15.93, -1104.25, 25.67), -- PDM
	-- 		vector3(-810.84, -228.29, 36.21), -- Luxury Autos
	-- 		vector3(868.27, -915.56, 25.03), -- Maibatsu Motors Factory
	-- 	}
	-- },

}
