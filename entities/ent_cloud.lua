--[[
    ent_cloud.lua
    A cloud

    Authors:
        Dan Wager
--]]

local cloud = EntityManager.derive("base")

local SPEED = 32

function cloud:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    self.image = TextureManager.getImage(data.image or "cloud")
    self.respawn = data.respawn or true
    self.scale = data.scale or 1
    self.speedScale = data.speedScale or math.random(1, 4)
    self:setPos(data.x, data.y)
end

function cloud:update(dt)
    self.x = self.x + SPEED * self.speedScale * dt

    if self.x - self.image:getWidth() / 2 >= SCREEN_WIDTH then
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
        self.image:getWidth() / 2,
        self.image:getHeight() / 2)

    -- Shows the x/y point
    -- love.graphics.setColor(0, 0, 0, 255)
    -- love.graphics.circle("fill", self.x, self.y, 5)
end

function cloud:die()
    if self.respawn then
        EntityManager.create("cloud", { x = -math.random(256, 300), y = math.random(50, 300)})
    end
end

return cloud
