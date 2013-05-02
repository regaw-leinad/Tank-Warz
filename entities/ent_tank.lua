local tank = EntityManager.derive("base")

function tank:load(x, y, data)
    self.bodyImage = TextureManager.get("tank")
    self.barrelImage = TextureManager.get("barrel")
    self.barrelAngle = 0
    self:setPos(x, y)
    self.barrelSpeed = 30
    self.scale = .25
    self.size = 512
    self.hp = 100
end

function tank:update(dt)
    if love.keyboard.isDown("w") then
        self.barrelAngle = self.barrelAngle + self.barrelSpeed * dt
    end

    if love.keyboard.isDown("q") then
        self.barrelAngle = self.barrelAngle - self.barrelSpeed * dt
    end

    if self.barrelAngle > 0 then
        self.barrelAngle = 0
    elseif self.barrelAngle < -90 then
        self.barrelAngle = -90
    end

    if self.hp <= 0 then
        EntityManager.destroy(self.id)
    end
end

function tank:draw()
    local bx, by = self:getBarrelPos()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.barrelImage, bx, by, self:getBarrelRads(),
        self.scale, self.scale, 0, 16)

    love.graphics.draw(self.bodyImage, self.x, self.y, 0, self.scale, self.scale, 256, 128)

    love.graphics.print(self.barrelAngle, 10, 10)
end

function tank:damage(n)
    self.hp = self.hp - n
end

function tank:getBarrelRads()
    return self.barrelAngle * math.pi / 180
end

function tank:getBarrelPos()
    return self.x, (self.y + 16 * self.scale)
end

function tank:shoot()
    local a = self:getBarrelRads()
    local x, y = self:getBarrelPos()

    EntityManager.create("projectile", x + math.cos(a) * 250 * self.scale,
        y + math.sin(a) * 250 * self.scale,
        { power = 200, angle = -tank.barrelAngle, scale = self.scale })
end

function tank:rotateBarrel(deg)
    self.barrelAngle = self.barrelAngle + deg
end

return tank