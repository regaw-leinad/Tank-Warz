--[[
    ent_projectile.lua
    A projectile with physics support

    Authors:
        Dan Wager
--]]

local projectile = EntityManager.derive("base")

function projectile:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    self.image = TextureManager.getImage(data.image or "projectile")
    self.scale = data.scale or 1
    self.speedScale = data.speedScale or 1
    self.vx = (data.power or 1) * math.cos(math.rad(data.angle or 0)) * METER_SIZE
    self.vy = (data.power or 1) * math.sin(math.rad(data.angle or 0)) * METER_SIZE
    self.x = data.x or 0
    self.y = data.y or 0
    self.initY = self.y
end

function projectile:update(dt)
    dt = dt * self.speedScale

    self.vy = self.vy + 9.8 * METER_SIZE * dt

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if worldCollide(self) then
        EntityManager.destroy(self.id)
    end

    if self.x >= SCREEN_WIDTH or self.y >= SCREEN_HEIGHT or self.x <= 0 then
        EntityManager.destroy(self.id)
    end
end

function projectile:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.image,
        self.x,
        self.y,
        0,
        self.scale,
        self.scale,
        self.image:getWidth() / 2,
        self.image:getHeight() / 2)
end

return projectile
