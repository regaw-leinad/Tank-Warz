local ent = EntityManager.derive("base")

function ent:load(x, y)
    self.image = TextureManager.get("projectile")
    self.initX = 10
    self.initY = 600
    self.vx = 1000
    self.startTime = love.timer.getTime()
    --self.vy = -20
end

function ent:update(dt)
    local time = love.timer.getTime() - self.startTime

    self.y = self.initY - (self.vx * math.sin(math.pi / 2)) * time + .5 * 9.8 * METER_SIZE * time * time
    self.x = self.x + self.vx * math.cos(math.pi / 2) * dt
end

function ent:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.image, self.x, self.y)
end

return ent