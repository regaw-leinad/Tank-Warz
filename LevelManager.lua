LevelManager = {}

--[[
    level params:
      terrainTexture - The terrain's texture
      skyTexture - The sky's texture
      skyColor - The sky's color
      skyEntities - Table with entity types and number of each
      wind - The amount of initial wind in m/s
      gravity - The y gravity in m/s^2
--]]

LevelManager.PEACEFUL = 1
LevelManager.AHHH = 2

local levels = {
    ["peaceful"] =
    {
        terrainTexture = "terrain_dirt",
        skyTexture = nil,
        skyColor = { 0, 245, 255 },
        skyEntities = { ["cloud"] = 2 },
        wind = 0,
        gravity = 9.8
    },

    ["ahhh"] =
    {
        terrainTexture = "terrain_dirt",
        skyTexture = nil,
        skyColor = { 255, 0, 0 },
        skyEntities = { },
        wind = math.random(-10, 10),
        gravity = 4
    }
}

function LevelManager.get(lvl)
    if levels[lvl] then
        return deepCopy(levels[lvl])
    else
        print("No level \'" .. lvl .. "\'")
        return nil
    end
end

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
        return nil
    end
end
