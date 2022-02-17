jobStarts = {
  { -- Los Santos goPostal
    marker = vector3(132.48, 95.57, 82.51), -- Enter Marker
    spawn = vector3(63.4, 121.18, 79.14), -- Spawn spawnation
    h = 159.4,
    reset = vector3(123.72, 97.39, 81.68),
    level = 1,
    truck = 'speedo',
  },
  { -- Paleto
    marker = vector3(-405.27, 6146.99, 30.47), -- Enter Marker
    spawn = vector3(-400.27, 6163.99, 31.48), -- Spawn spawnation
    h = 356.55,
    reset = vector3(-399.62, 6150.69, 31.48),
    pickup = vector3(-412.41, 6180.13, 31.48),
    level = 1,
    truck = 'speedo',
  },
  { -- Grapeseed
    marker = vector3(1659.42, 4839.18, 41.04), -- Enter Marker
    spawn = vector3(1650.69, 4824.66, 41.0), -- Spawn spawnation
    h = 247.0,
    reset = vector3(1659.55, 4844.24, 40.98),
    pickup = vector3(1659.24, 4826.38, 41.0),
    level = 1,
    truck = 'speedo',
  },
  { -- Grapeseed -231.57, -913.37, 32.31, 78.16
    marker = vector3(-231.57, -913.37, 32.31), -- Enter Marker
    spawn = vector3(-230.16, -892.05, 29.94), -- Spawn spawnation
    h = 250.0,
    reset = vector3(-220.91, -905.86, 31.22),
    pickup = vector3(-248.54, -1007.59, 29.05),
    level = 1,
    truck = 'speedo',
  },
}

destinations = {
  { -- Blaine County
    { -- Route 68
     {blip = vector3(1838.59, 2590.6, 45.95)},
     {blip = vector3(1985.88, 3053.82, 47.22)},
     {blip = vector3(1202.07, 2656.17, 37.85)},
     {blip = vector3(1039.43, 2665.98, 39.55)},
     {blip = vector3(980.57, 2669.14, 40.06)},
     {blip = vector3(652.11, 2728.11, 42.0)},
     {blip = vector3(562.67, 2740.92, 42.79)},
     {blip = vector3(471.23, 2608.02, 44.48)},
     {blip = vector3(734.46, 2523.7, 73.23)},
     {blip = vector3(701.48, 2340.48, 50.45)},
     {blip = vector3(2674.8, 3266.44, 55.24)},
    },
    { -- Sandy
     {blip = vector3(387.89, 3586.14, 33.29)},
     {blip = vector3(464.7, 3565.96, 33.24)},
     {blip = vector3(910.97, 3643.24, 32.68)},
     {blip = vector3(905.57, 3587.69, 33.35)},
     {blip = vector3(1384.48, 3660.66, 34.92)},
     {blip = vector3(1425.02, 3671.25, 34.17)},
     {blip = vector3(1413.57, 3664.89, 34.21)},
     {blip = vector3(1532.81, 3778.53, 34.51)},
     {blip = vector3(1662.44, 3820.76, 35.47)},
     {blip = vector3(1658.47, 3799.62, 35.02)},
     {blip = vector3(1690.22, 3867.06, 34.91)},
     {blip = vector3(1839.58, 3672.01, 34.28)},
    },
    { -- sandy 1
     {blip = vector3(1691.09, 3581.1, 35.62)},
     {blip = vector3(1705.81, 3779.53, 34.76)},
     {blip = vector3(1729.1, 3851.07, 34.76)},
     {blip = vector3(1802.74, 3914.07, 37.06)},
     {blip = vector3(1879.63, 3920.71, 33.19)},
     {blip = vector3(1860.2, 3681.63, 33.79)},
    },
    { -- sandy 2
     {blip = vector3(3512.73, 3754.44, 29.97)},
     {blip = vector3(2986.19, 3484.79, 71.38)},
     {blip = vector3(2696.39, 4325.53, 45.85)},
     {blip = vector3(2569.33, 4275.41, 41.74)},
     {blip = vector3(2483.05, 4099.93, 38.13)},
     {blip = vector3(2420.55, 4020.45, 36.84)},
     {blip = vector3(1929.99, 3720.95, 32.83)},
     {blip = vector3(1391.82, 3597.58, 35.04)},
     {blip = vector3(1263.36, 3545.47, 35.17)},
    },
    { -- sandy 3
      {blip = vector3(1777.41, 3327.7, 41.43)},
      {blip = vector3(1989.87, 3055.17, 47.22)},
      {blip = vector3(1224.83, 2727.34, 38.0)},
      {blip = vector3(983.84, 2718.91, 39.5)},
      {blip = vector3(545.61, 2674.33, 42.16)},
      {blip = vector3(317.43, 2623.01, 44.46)},
    },
    { -- Greapseed
     {blip = vector3(1664.23, 4776.29, 41.99)},
     {blip = vector3(1665.33, 4739.95, 41.99)},
     {blip = vector3(1683.93, 4689.68, 43.07)},
     {blip = vector3(1674.35, 4658.13, 43.37)},
     {blip = vector3(1966.42, 4635.21, 40.77)},
     {blip = vector3(2030.62, 4980.24, 42.1)},
     {blip = vector3(2455.11, 4955.82, 45.02)},
     {blip = vector3(2157.55, 4790.28, 41.1)},
     {blip = vector3(2476.76, 4445.81, 35.36)},
     {blip = vector3(2568.24, 4275.12, 41.7)},
     {blip = vector3(2638.91, 4246.5, 44.77)},
     {blip = vector3(2726.89, 4143.04, 44.29)},
    },
    { -- Zancudo
      {blip = vector3(1855.38, 3681.89, 34.27)},
      {blip = vector3(1395.83, 3598.76, 34.98)},
      {blip = vector3(-456.27, 2857.99, 34.29)},
      {blip = vector3(-1123.27, 2682.63, 18.74)},
      {blip = vector3(-1732.39, 2960.32, 32.81)},
      {blip = vector3(-1312.28, 2507.33, 21.92)},
      {blip = vector3(-2544.01, 2317.32, 33.22)},
    },
  },
  {
    { -- RT 1 shore houses
     {blip = vector3(-3088.89, 221.4, 14.07)},
     {blip = vector3(-3106.13, 312.02, 8.38)},
     {blip = vector3(-3093.08, 349.04, 7.53)},
     {blip = vector3(-3071.41, 442.32, 6.36)},
     {blip = vector3(-3038.78, 492.84, 6.77)},
     {blip = vector3(-3029.33, 568.6, 7.81)},
     {blip = vector3(-3077.49, 659.3, 11.64)},
     {blip = vector3(-3106.66, 719.24, 20.61)},
     {blip = vector3(-3101.54, 743.73, 21.28)},
     {blip = vector3(-3017.84, 746.28, 27.59)},
     {blip = vector3(-2994.9, 682.63, 25.04)},
     {blip = vector3(-2972.8, 642.39, 25.99)},
    },
  }
}
