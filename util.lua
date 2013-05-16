--[[
    util.lua
    Utility functions

    Authors:
        Dan Wager
        Daniel Rolandi
--]]

-- Checks if a string starts with a specified string
-- @param String The string to check
-- @param Start The string to check for
-- @return If the string starts with the specified string (boolean)
function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
end

-- Checks if a string ends with a specified string
-- @param String The string to check
-- @param Start The string to check for
-- @return If the string ends with the specified string (boolean)
function string.ends(String, End)
   return End == '' or string.sub(String, -string.len(End)) == End
end

-- Rounds a value to a certain number of decimal places
-- @param val The value
-- @param decimal The number of places to round to
-- @return The rounded number (decimal)
function round(val, decimal)
    if (decimal) then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    end
    -- if no place specified, round to nearest whole number
    return math.floor(val + 0.5)
end

-- Cuts a polygon into multiple triangular polygons
-- @param midX The mid X coordinate
-- @param midY The mid Y coordinate
-- @param poly The polygon to cut
-- @return A table containing multiple smaller polygons (table)
function polygonCut(midX, midY, poly)
    local t = {}

    local count = 1
    local tCount = 1

    t[tCount] = { poly[count], poly[count + 1], midX, midY, poly[#poly - 1], poly[#poly] }

    tCount = tCount + 1

    while count < #poly - 4 do
        t[tCount] =
        {
            poly[count],
            poly[count + 1],
            midX,
            midY,
            poly[count + 2],
            poly[count + 3]
        }

        tCount = tCount + 1
        count = count + 2
    end

    return t
end

-- Copies a table on one level only
-- @param orig The table
-- @return The copy of the table (table)
function shallowCopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == "table" then
        copy = {}

        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end

    return copy
end

-- Copies a table recursively
-- @param orig The table
-- @return The copy of the table (table)
function deepCopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == "table" then
        copy = {}

        for orig_key, orig_value in next, orig, nil do
            copy[deepCopy(orig_key)] = deepCopy(orig_value)
        end

        setmetatable(copy, deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Rotates a bounding box and returns the rotated polygon
-- @param refX The pivot X coordinate
-- @param refY The pivot Y coordinate
-- @param angle The angle to rotate, in degrees CW
-- @param points The bounding box (as polygon)
-- @return Table of rotated polygon points (table)
function rotateBox(refX, refY, angle, points)
    local ax, ay = rotatePoint(refX, refY, angle, points[1], points[2])
    local bx, by = rotatePoint(refX, refY, angle, points[3], points[4])
    local cx, cy = rotatePoint(refX, refY, angle, points[5], points[6])
    local dx, dy = rotatePoint(refX, refY, angle, points[7], points[8])

    return
    {
        round(ax),
        round(ay),
        round(bx),
        round(by),
        round(cx),
        round(cy),
        round(dx),
        round(dy)
    }
end

-- Rotates a point x,y and returns the point x',y'
-- @param refX The pivot X coordinate
-- @param refY The pivot Y coordinate
-- @param angle The angle to rotate, in degrees CW
-- @param x The X coordinate of the point
-- @param y The Y coordinate of the point
-- @return Point x',y' after rotation (int, int)
function rotatePoint(refX, refY, angle, x, y)
    local fixX = x - refX
    local fixY = y - refY

    local resultX = fixX * math.cos(math.rad(angle)) - fixY *
        math.sin(math.rad(angle)) + refX
    local resultY = fixX * math.sin(math.rad(angle)) + fixY *
        math.cos(math.rad(angle)) + refY

    return resultX, resultY
end

-- Gets the location and angle of a new tank
-- @param x The X coordinate of the tank
-- @return The X and Y coordinate and angle (CW = positive) of the tank (int, int, int)
function getTankDrop(x)
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

            return x - dropBuf * math.sin(angle),
                resultY - dropBuf * math.cos(angle),
                math.deg(angle)
        end
    end
end
