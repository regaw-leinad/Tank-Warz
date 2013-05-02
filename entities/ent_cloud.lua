local cloud = EntityManager.derive("base")

function cloud:load(x, y, data)
    self.image = TextureManager.getImage("cloud")
    math.randomseed(os.time())
    self.speed = math.random(1, 4)
    self:setPos(-math.random(256, 400), math.random(0, 200))
end

function cloud:update(dt)
    self.x = self.x + 32 * self.speed * dt

    if self.x >= (SCREEN_WIDTH) then
        EntityManager.destroy(self.id)
    end
end

function cloud:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.image, self.x, self.y)
end

function cloud:die()
    math.randomseed(os.time())
    EntityManager.create("cloud", -math.random(256, 400), math.random(0, 200))
end

return cloud