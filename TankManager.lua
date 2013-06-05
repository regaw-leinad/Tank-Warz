--[[
    TankManager.lua
    Manages the different tanks in the application

    Authors:
        Dan Wager
--]]

TankManager = {}

-- The red tank
TankManager.RED = 2
-- Ian's grey tank
TankManager.GREY = 1

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
        barrelImage = "tank_grey_barrel1",
        barrelImageW, barrelImageH = TextureManager.getImageDimensions("tank_grey"),
        barrelOffsetX = 6,
        barrelOffsetY = -4,
        barrelPivotOffset = 9,
        scale = 1,
        power = 20,
        barrelSpeed = 50,
        maxHp = 20,
        hp = 20
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

-- Gets the location and angle of a new tank
-- @param x The X coordinate of the tank
-- @return The X and Y coordinate and angle (CW = positive) of the tank (int, int, int)
local function getTankDrop(x)
    local terrain = EntityManager.getAll("terrain")[1]
    local v = terrain:getCoords()
    local points = terrain:getPointCount()

    -- raises the tank a few pixels above the terrain
    local dropBuf = 12

    -- prevents the tank from dropping too close to a vertex
    local vertexBuf = 15

    for i = 1, points, 2 do
        local leftX = v[i]
        local leftY = v[i+1]
        local rightX = v[i+2]
        local rightY = v[i+3]

        if leftX <= x and x <= rightX then
            -- repositions the tank drop if too close to either vertex
            if (leftX + vertexBuf) >= (rightX - vertexBuf) then
                -- between leftX and rightX happens to be too narrow
                x = (leftX + rightX) / 2
            elseif x < (leftX + vertexBuf) then
                -- too close to the left vertex
                x = leftX + vertexBuf
            elseif (rightX - vertexBuf) < x then
                -- too close to the right vertex
                x = rightX - vertexBuf
            end

            local resultY = (x - leftX) * (rightY - leftY) / (rightX - leftX) + leftY
            local angle = math.atan2(rightY - leftY, rightX - leftX)

            return x - dropBuf * -math.sin(angle),
                resultY - dropBuf * math.cos(angle),
                math.deg(angle)
        end
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
-- @param xMin The minimum X coordinate of the tank
-- @param xMax The maximum X coordinate of the tank
-- @param direction The direction of the tank
-- @param ai The Ai
-- @return The tank entity
function TankManager.create(tank, xMin, xMax, direction, ai)
    if tanks[tank] then
        local tankData = get(tank)

        tankData.x, tankData.y, tankData.angle = getTankDrop(math.random(xMin, xMax))
        tankData.direction = direction
        tankData.barrelAngle = 0
        tankData.ai = ai or AI.NONE

        return EntityManager.create("tank", false, tankData)
    else
        print("No tank \'" .. tank .. "\'")
        return nil
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
