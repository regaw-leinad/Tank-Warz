local terrain = EntityManager.derive("base")

terrain.v = {}

function terrain:load(x, y, data)
    local WIDTH_MIN = 10
    local WIDTH_BUFFER = 50
    local HEIGHT_BUFFER = 20
    local START_LOC = 450

    math.randomseed(os.time())

    self.v = {
        0,
        math.random(START_LOC - HEIGHT_BUFFER, START_LOC + HEIGHT_BUFFER)
    }
    -- current vertex
    local current = {
        x = self.v[1],
        y = self.v[2]
    }
    local count = 2 -- we want to start appending at position 3 later

    while current.x < SCREEN_WIDTH do
        -- compute the next vertex we want to generate
        -- uses math.min and math.max to prevent off-screen vertices
        local target = {
            x = math.random(math.min(SCREEN_WIDTH, current.x + WIDTH_MIN), math.min(SCREEN_WIDTH, current.x + WIDTH_BUFFER)),
            y = math.random(math.max(0, current.y - HEIGHT_BUFFER), math.min(SCREEN_HEIGHT, current.y + HEIGHT_BUFFER))
        }

        current.x = target.x
        current.y = target.y

        count = count + 1
        self.v[count] = current.x
        count = count + 1
        self.v[count] = current.y
    end

    -- must add two extra vertices: bottom-right and bottom-left corner
    count = count + 1
    self.v[count] = SCREEN_WIDTH
    count = count + 1
    self.v[count] = SCREEN_HEIGHT

    count = count + 1
    self.v[count] = 0
    count = count + 1
    self.v[count] = SCREEN_HEIGHT
end

function terrain:draw()
    love.graphics.setColor(103, 164, 21, 255)
    love.graphics.polygon("fill", self.v)
end

return terrain