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

function terrain:load(x, y, data)
    local WIDTH_MIN = 10
    local WIDTH_BUFFER = 50
    local HEIGHT_BUFFER = 20
    local START_Y = 450
    local START_X = 0

    self.coords = generateTerrain(START_X, START_Y, WIDTH_MIN, WIDTH_BUFFER, HEIGHT_BUFFER)
    self.terrain = TextureManager.makeTexturedPoly(self.coords, TextureManager.getImageData(data.texture))
end

function terrain:draw()
    love.graphics.draw(self.terrain, self.coords[1], self.coords[2])
end

return terrain