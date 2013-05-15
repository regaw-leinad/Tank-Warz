--[[
    TankManager.lua
    Manages the different tanks in the application

    Authors:
        Dan Wager
--]]

TankManager = {}

-- The red tank
TankManager.RED = 1
-- Ian's grey tank
TankManager.GREY = 2

-- Table of tanks with values
local tanks =
{
    [TankManager.RED] =
    {
        image = "tank_red",
        imageW, imageH = TextureManager.getImageDimensions("tank_red"),
        barrelImage = "tank_red_barrel",
        barrelImageW, barrelImageH = TextureManager.getImageDimensions("tank_red_barrel"),
        barrelOffsetX = 0,
        barrelOffsetY = -16,
        scale = .125,
        power = 20,
        barrelSpeed = 30,
        maxHp = 100,
        hp = 100
    },

    [TankManager.GREY] =
    {
        image = "tank_grey",
        imageW, imageH = TextureManager.getImageDimensions("tank_grey"),
        barrelImage = "tank_grey_barrel",
        barrelImageW, barrelImageH = TextureManager.getImageDimensions("tank_grey"),
        barrelOffsetX = 3,
        barrelOffsetY = 0,
        barrelPivotOffset = 9,
        barrelOnTop = false,
        scale = 1,
        power = 20,
        barrelSpeed = 50,
        maxHp = 200,
        hp = 200
    }
}

-- Gets a copy of the tank's value table
-- @param tank The tank
-- @return The table of values for the specified tank (table)
local function get(tank)
    if tanks[tank] then
        return shallowCopy(tanks[tank])
    else
        print("No tank \'" .. tank .. "\'")
        return nil
    end
end

-- Gets a table containing the initialization data for the specified tank
-- @param tank The tank
-- @return The table of init data for the specified tank (table)
function TankManager.getData(tank)
    return get(tank)
end

-- Creates a new tank entity
-- @param tank The tank
-- @param x The X coordinate of the tank
-- @param y The Y coordinate of the tank
-- @param direction The direction of the tank
-- @param angle The tank angle
-- @param barrelAngle The initial relative barrel angle
function TankManager.create(tank, x, y, direction, angle, barrelAngle)
    local tankData = get(tank)

    tankData.x = x
    tankData.y = y
    tankData.direction = direction
    tankData.angle = angle or 0
    tankData.barrelAngle = barrelAngle or 0

    if tankData then
        EntityManager.create("tank", false, tankData)
    end
end

-- Gets a value indicating the count of all tank entities in the current state
-- @return The number of tank entities in the current state (int)
function TankManager.getCount()
    return EntityManager.getCount("tank")
end

-- Gets the tanks entity for the specified player
-- @param player The player
-- @return The tank entity for the specified player (tank entity/table)
function TankManager.getPlayerTank(player)
    for _,tank in ipairs(EntityManager.getAll("tank")) do
        if tank.player == player then
            return tank
        end
    end

    print("No tank for player " .. player)
    return nil
end
