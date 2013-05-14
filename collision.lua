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

            local magic = (leftX * rightY) - (leftX * y) -
                            (leftY * rightX) + (leftY * x) +
                            (rightX * y) - (x * rightY)

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
