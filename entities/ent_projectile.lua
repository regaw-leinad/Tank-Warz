local ent = EntityManager.derive("base")

-- data needs: power, angle (in degrees), scale
function ent:load(x, y, data)
    if not data then data = {} end

    self.image = TextureManager.getImage("projectile")

    self.scale = data.scale or 1
    self.startTime = love.timer.getTime()

    self.vx = (data.power or 1) * math.cos(math.rad(data.angle or 0)) * METER_SIZE
    self.vy = data.power * math.sin(math.rad(data.angle or 0)) * METER_SIZE

    self.x = x
    self.y = y
    self.initY = y
end

function ent:update(dt)
    dt = dt

    self.vy = self.vy + 9.8 * METER_SIZE * dt

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if self.x >= SCREEN_WIDTH or self.y >= SCREEN_HEIGHT then
        EntityManager.destroy(self.id)
    end
end

function ent:draw()
    local ox, oy = self:getImageOffsets()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, ox, oy)
end

function ent:getImageOffsets()
    return (self.image:getWidth() * .5 * self.scale), (self.image:getHeight() * .5 * self.scale)
end

return ent