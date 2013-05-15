--[[
    collision.lua
    Collision detection functions

    Authors:
        Dan Wager
        Daniel Rolandi
--]]

-- Checks if point px,py is inside of a defined box
-- @param px The X coordinate of the point
-- @param py The Y coordinate of the point
-- @param bx The X coordinate of the upper left corner of the box
-- @param bx The Y coordinate of the upper left corner of the box
-- @param bw The width of the box
-- @param bh The height of the box
-- @return If the point is inside the box (boolean)
function insideBox(px, py, bx, by, bw, bh)
    if px > bx and px < bx + bw then
        if py > by and py < by + bh then
            return true
        end
    end

    return false
end

-- Checks if point x, y is inside of the poly
-- @param x The X coordinate of the point
-- @param y The Y coordinate of the point
-- @param poly The table of polygon points
-- @return If the point is inside the poly (boolean)
function insidePoly(x, y, poly)
    local test1 = cross(poly[1], poly[2], poly[3], poly[4], x, y) > 0
    local test2 = cross(poly[3], poly[4], poly[5], poly[6], x, y) > 0
    local test3 = cross(poly[5], poly[6], poly[7], poly[8], x, y) > 0
    local test4 = cross(poly[7], poly[8], poly[1], poly[2], x, y) > 0

    -- the point x,y is inside abcd iff all tests are true
    -- otherwise the point is outside
    return test1 and test2 and test3 and test4
end

-- Calculates the cross product of the three points ABP
-- @param ax The X coordinate of the point a
-- @param ay The Y coordinate of the point a
-- @param bx The X coordinate of the point b
-- @param by The Y coordinate of the point b
-- @param px The X coordinate of the point p
-- @param py The Y coordinate of the point p
-- @return The cross product of ABP
function cross(ax, ay, bx, by, px, py)
    return (ax * by) - (ax * py) -
            (ay * bx) + (ay * px) +
            (bx * py) - (px * by)
end

-- Checks if the point has collided with the terrain
-- @param x The X coordinate
-- @param y The Y coordinate
-- @return If there is a collision (boolean)
function terrainCollide(x, y)
    local terrain = EntityManager.getAll("terrain")[1]
    local v = terrain:getCoords()
    local points = terrain:getPointCount()

    for i = 1, points, 2 do
        local leftX = v[i]
        local leftY = v[i+1]
        local rightX = v[i+2]
        local rightY = v[i+3]

        if leftX <= x and x <= rightX then

            local magic = cross(leftX, leftY, rightX, rightY, x, y)

            -- No collision
            if magic < 0 then
                return false
            else
                return true
            end
        end
    end
end

-- Checks if the point has collided with a tank
-- @param x The X coordinate
-- @param y The Y coordinate
-- @param damage The damage the projectile will do to a tank if collided
-- @return If there is a collision (boolean)
function tankCollide(x, y, damage)
    for _,tank in ipairs(EntityManager.getAll("tank")) do
        if insidePoly(x, y, tank:getBoundingPoly()) then
            tank:damage(damage)
            return true
        end
    end

    return false
end
