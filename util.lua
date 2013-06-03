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

    while count < #poly - 4 do
        t[tCount] =
        {
            poly[count],
            poly[count + 1],

            poly[count + 2],
            poly[count + 3],

            poly[count + 2],
            SCREEN_HEIGHT,

            poly[count],
            SCREEN_HEIGHT
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
    local fixedX = x - refX
    local fixedY = y - refY

    local resultX = fixedX * math.cos(math.rad(angle)) - fixedY *
        math.sin(math.rad(angle)) + refX
    local resultY = fixedX * math.sin(math.rad(angle)) + fixedY *
        math.cos(math.rad(angle)) + refY

    return resultX, resultY
end
