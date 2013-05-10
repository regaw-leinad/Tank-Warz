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

-- Define levels HERE
local levels = {
    ["peaceful"] =
    {
        terrainTexture = "dirt",
        skyTexture = nil,
        skyColor = { 0, 245, 255 },
        skyEntities = { ["cloud"] = 2 },
        wind = 0,--math.random(-3, 3),
        gravity = 9.8
    },

    ["ahhh"] =
    {
        terrainTexture = "dirt",
        skyTexture = nil,
        skyColor = { 255, 0, 0 },
        skyEntities = { },--["cloud"] = 2 },
        wind = math.random(-10, 10),
        gravity = 4
    }
}

function LevelManager.getLevelData(lvl)
    if levels[lvl] then
        return levels[lvl]
    else
        print("No level \'" .. lvl .. "\'")
        return nil
    end
end