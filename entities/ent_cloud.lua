--[[
    ent_cloud.lua
    A cloud

    Authors:
        Dan Wager
--]]

local cloud = EntityManager.derive("base")

function cloud:load(x, y, data)
    if not data then data = {} end

    self.image = TextureManager.getImage("cloud")
    math.randomseed(os.time())

    self.scale = data.scale or 1
    self.speed = data.speed or math.random(1, 4)
    self:setPos(-math.random(256, 400), math.random(0, 200))
end

function cloud:update(dt)
    self.x = self.x + 32 * self.speed * dt

    if self.x + self.image:getWidth() / 2 >= (SCREEN_WIDTH) then
        EntityManager.destroy(self.id)
    end
end

function cloud:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.image,
        self.x,
        self.y,
        0,
        self.scale,
        self.scale,
        self.image:getWidth(),
        self.image:getHeight())
end

function cloud:die()
    math.randomseed(os.time())
    EntityManager.create("cloud", -math.random(256, 400), math.random(0, 200), { scale = self.scale })
end

return cloud