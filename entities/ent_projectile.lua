--[[
    ent_projectile.lua
    A projectile with physics support

    Authors:
        Dan Wager
--]]

local projectile = EntityManager.derive("base")

--[[
    data
      image - The projectile's image
      scale - The image scale
      speedScale - The projectile movement's time scale
      power - The magnitude of the force on the projectile
      angle - The angle of launch
      x - The X coordinate
      y - The Y coordinate
      damage - The damage this projectile deals
--]]
function projectile:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    self.image = TextureManager.getImage(data.image or "projectile_grey")
    self.scale = data.scale or 1
    self.speedScale = data.speedScale or 1.2
    self.vx = (data.power or 1) * math.cos(math.rad(data.angle or 0)) * METER_SIZE
    self.vy = (data.power or 1) * math.sin(math.rad(data.angle or 0)) * METER_SIZE
    self.x = data.x or 0
    self.y = data.y or 0
    self.damage = data.damage or 10
    self.parent = data.parent
end

function projectile:update(dt)
    dt = dt * self.speedScale

    self.vx = self.vx + WIND * dt
    self.vy = self.vy + GRAVITY * dt

    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if terrainCollide(self.x, self.y) or tankCollide(self.x, self.y, self.damage) then
        AudioManager.play("boom")
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

    if DEBUG then
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.rectangle("line",
            self.x - self.image:getWidth() / 2,
            self.y - self.image:getHeight() / 2,
            self.image:getWidth(),
            self.image:getHeight())
    end
end

return projectile
