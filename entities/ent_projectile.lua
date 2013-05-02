local ent = EntityManager.derive("base")

-- data needs: power, angle (in degrees), scale
function ent:load(x, y, data)
    self.image = TextureManager.get("projectile")
    self.scale = data.scale
    self.timeScale = 1
    self.x = x
    self.initY = y
    self.y = y
    self.vx = data.power
    self.angle = data.angle * math.pi / 180
    self.startTime = love.timer.getTime()
end

function ent:update(dt)
    local time = (love.timer.getTime() - self.startTime) * self.timeScale

    self.y = self.initY - (self.vx * math.sin(self.angle)) * time + .5 * 9.8 * METER_SIZE * time * time
    self.x = self.x + (self.vx * math.cos(self.angle)) * dt * self.timeScale

    -- Check for collision here
    if self.x >= SCREEN_WIDTH or self.y >= SCREEN_HEIGHT then
        EntityManager.destroy(self.id)
    end
end

function ent:getImageOffsets()
    return (self.image:getWidth() * self.scale / 2), (self.image:getHeight() * self.scale / 2)
end

function ent:draw()
    local ox, oy = self:getImageOffsets()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, ox, oy)
end

return ent