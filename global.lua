--[[
    global.lua
    Constants and global values for the application

    Authors:
        Dan Wager
--]]

-- The width of the screen
SCREEN_WIDTH = 800
-- The height of the screen
SCREEN_HEIGHT = 600
-- The size of a meter in pixels
METER_SIZE = 10
-- The gravity in m/s^2
GRAVITY = 9.8
-- The wind in m/s
WIND = 0

-- Adjust the wind and gravity to scale
GRAVITY = GRAVITY * METER_SIZE
WIND = WIND * METER_SIZE

BUBBLE_FONT = nil