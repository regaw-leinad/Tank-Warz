--[[
    util.lua
    Utility functions

    Authors:
        Dan Wager
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
-- @return A table containing a cut up polygon (table)
function polygonCut(midX, midY, poly)
    local t = {}

    local count = 1
    local tCount = 1

    t[tCount] = { poly[count], poly[count + 1], midX, midY, poly[#poly - 1], poly[#poly] }

    tCount = tCount + 1

    while count < #poly - 4 do
        t[tCount] = { poly[count], poly[count + 1], midX, midY, poly[count + 2], poly[count + 3] }

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
-- @param angle The angle to rotate
-- @param points The bounding box (as polygon)
-- @return Table of rotated polygon points
function rotateBox(refX, refY, angle, points)
    return nil
end

-- Gets the location and angle of a new tank
-- @param x The X coordinate of the tank
-- @param terrainPoly The terrain coordinate points
-- @return The
function getTankDrop(x, terrainPoly)

end
