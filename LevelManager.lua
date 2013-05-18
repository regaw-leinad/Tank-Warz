--[[
    LevelManager.lua
    Manages the different levels in the application

    Authors:
        Dan Wager
--]]

LevelManager = {}

-- The peaceful level
LevelManager.PEACEFUL = 1
-- The hell-ish level
LevelManager.AHHH = 2

-- Table of levels with values
local levels =
{
    [LevelManager.PEACEFUL] =
    {
        terrainTexture = "terrain_dirt",
        skyTexture = nil,
        skyColor = { 0, 245, 255 },
        skyEntities = { ["cloud"] = 2 },
        wind = 3,
        gravity = 9.8
    },

    [LevelManager.AHHH] =
    {
        terrainTexture = "terrain_dirt",
        skyTexture = nil,
        skyColor = { 255, 0, 0 },
        skyEntities = { },
        wind = math.random(-10, 10),
        gravity = 4
    }
}

-- Gets a copy of the level's value table
-- @param lvl The level
-- @return The table of values for the specified level (table)
local function get(lvl)
    if levels[lvl] then
        return deepCopy(levels[lvl])
    else
        print("No level \'" .. lvl .. "\'")
        return nil
    end
end

-- Gets a table containing the initialization data for the specified level
-- @param lvl The level
-- @return The table of init data for the specified level (table)
function LevelManager.getData(lvl)
    return get(lvl)
end

-- Loads a level for playing
-- @param lvl The level
function LevelManager.load(lvl)
    if levels[lvl] then
        if levels[lvl].skyColor then
            love.graphics.setBackgroundColor(unpack(levels[lvl].skyColor))
        elseif level.skyTexture then
            -- Ian's tile texturizing algorithm
        end

        EntityManager.create("terrain", true,
        {
            texture = levels[lvl].terrainTexture
        })

        for ent,num in pairs(levels[lvl].skyEntities) do
            for i = 1, num do
                EntityManager.create(ent, true)
            end
        end

        if levels[lvl].wind then
            WIND = levels[lvl].wind * METER_SIZE
        end

        if levels[lvl].gravity then
            GRAVITY = levels[lvl].gravity * METER_SIZE
        end
    else
        print("No level \'" .. lvl .. "\'")
    end
end
