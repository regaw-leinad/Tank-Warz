--[[
    ent_terrain.lua
    Randomly generated terrain

    Authors:
        Dan Wager
        Daniel Rolandi
--]]

local terrain = EntityManager.derive("base")

-- Daniel Rolandi's random terrain generation
local function generateTerrain(xStart, yStart, wMin, wBuff, hBuff)
    math.randomseed(os.time())

    local v = {
        0,
        math.random(yStart - hBuff, yStart + hBuff)
    }

    -- current vertex
    local current = {
        x = v[1],
        y = v[2]
    }

    -- we want to start appending at position 3 later
    local count = 2

    while current.x < SCREEN_WIDTH do

        -- compute the next vertex we want to generate
        -- uses math.min and math.max to prevent off-screen vertices
        local target = {
            x = math.random(math.min(SCREEN_WIDTH, current.x + wMin), math.min(SCREEN_WIDTH, current.x + wBuff)),
            y = math.random(math.max(0, current.y - hBuff), math.min(SCREEN_HEIGHT, current.y + hBuff))
        }

        current.x = target.x
        current.y = target.y

        count = count + 1
        v[count] = current.x
        count = count + 1
        v[count] = current.y
    end

    -- must add two extra vertices: bottom-right and bottom-left corner
    count = count + 1
    v[count] = SCREEN_WIDTH
    count = count + 1
    v[count] = SCREEN_HEIGHT

    count = count + 1
    v[count] = 0
    count = count + 1
    v[count] = SCREEN_HEIGHT

    return v
end

function terrain:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    local widthMin = data.widthMin or 10
    local widthBuf = data.widthBuf or 50
    local heightBuf = data.heightBuf or 20
    local startX = data.startX or 0
    local startY = data.startY or 450

    self.coords = generateTerrain(startX, startY, widthMin, widthBuf, heightBuf)
    self.polygons = polygonCut({1, 2, 3, 4}, self.coords)
    self.terrain = TextureManager.makeTexturedPoly(self.coords, TextureManager.getImageData(data.texture))

    --print(inspect(self.coords))
end

function terrain:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.terrain, 0, SCREEN_HEIGHT - self.terrain:getHeight() + 1)

    --love.graphics.polygon("fill", self.coords)
    -- love.graphics.setColor(0, 0, 0, 100)
    -- love.graphics.polygon("line", self.coords)
end

function terrain:getCoords()
    return self.coords
end

function terrain:getPointCount()
    return #self.coords - 4
end

return terrain
