--[[
    ent_tank.lua
    A tank with a moveable barrel that can shoot

    Authors:
        Dan Wager
--]]

local tank = EntityManager.derive("base")

function tank:load(x, y, data)
    if not data then data = {} end

    self.bodyImage = TextureManager.getImage("tank")
    self.barrelImage = TextureManager.getImage("barrel")

    self:setPos(x or 0, y or 0)

    self.scale = data.scale or 1

    self.power = 10

    self.barrelAngle = data.barrelAngle or 0
    self.barrelSpeed = data.barrelSpeed or 50

    self.maxHp = 100
    self.hp = 100
end

function tank:update(dt)
    ---[[
    if self.barrelAngle > 0 then
        self.barrelAngle = 0
    elseif self.barrelAngle < -90 then
        self.barrelAngle = -90
    end
    --]]

    if self.hp <= 0 then
        EntityManager.destroy(self.id)
    end
end

function tank:draw()
    local bx, by = self:getBarrelPos()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.barrelImage,
        bx,
        by,
        self:getBarrelRads(),
        self.scale, self.scale,
        0,
        self.barrelImage:getHeight() / 2)

    love.graphics.draw(self.bodyImage,
        self.x, self.y,
        0,
        self.scale, self.scale,
        self.bodyImage:getWidth() / 2,
        self.bodyImage:getHeight() / 2)
end

function tank:damage(n)
    self.hp = self.hp - n
end

function tank:getBarrelRads()
    return math.rad(self.barrelAngle)
end

function tank:getBarrelDeg()
    return self.barrelAngle
end

function tank:getPower()
    return self.power
end

function tank:isAlive()
    return self.hp > 0
end

function tank:getScaledSize()
    return self.bodyImage:getWidth() * self.scale, self.bodyImage:getHeight() * self.scale
end

function tank:adjustPower(n)
    self.power = self.power + n
end

function tank:getBarrelPos()
    return self.x, (self.y - 16 * self.scale)
end

function tank:getHp()
    return self.hp
end

function tank:getMaxHp()
    return self.maxHp
end

function tank:shoot()
    local a = self:getBarrelRads()
    local x, y = self:getBarrelPos()

    EntityManager.create("projectile",
        x + math.cos(a) * (self.barrelImage:getWidth() - 10 * self.scale) * self.scale,
        y + math.sin(a) * (self.barrelImage:getWidth() - 10 * self.scale) * self.scale,
        { power = self.power, angle = tank.barrelAngle, scale = self.scale })
end

function tank:rotateBarrel(dir, dt)
    if dir == "cw" then
        self.barrelAngle = self.barrelAngle + self.barrelSpeed * dt
    elseif dir == "ccw" then
        self.barrelAngle = self.barrelAngle - self.barrelSpeed * dt
    end
end

return tank