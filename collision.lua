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
    local test1 = cross(poly.ax, poly.ay, poly.bx, poly.by, x, y) > 0
    local test2 = cross(poly.bx, poly.by, poly.cx, poly.cy, x, y) > 0
    local test3 = cross(poly.cx, poly.cy, poly.dx, poly.dy, x, y) > 0
    local test4 = cross(poly.dx, poly.dy, poly.ax, poly.ay, x, y) > 0

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

        local sx, sy = tank:getPos()
        local sw, sh = tank:getScaledSize()

        if insideBox(x, y, sx - sw / 2, sy - sh / 2, sw, sh) then
            tank:damage(damage)

            return true
        end
    end

    return false
end
