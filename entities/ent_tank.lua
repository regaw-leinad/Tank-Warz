--[[
    ent_tank.lua
    A tank with a moveable barrel that can shoot

    Authors:
        Dan Wager
--]]

local tank = EntityManager.derive("base")

--[[
    data
      bodyImage - name of tank texture
      barrelImage - name of barrel texture
      x - x-coord in world
      y - y-coord in world
      scale - image scale
      power - initial tank power
      barrelAngle - initial angle of barrel
      barrelSpeed - speed of barrel movement
      maxHp - max health
      hp - initial health
      btnShoot - KeyConstant for shooting a projectile
      btnRotateCW - KeyConstant for rotating barrel CW
      btnRotateCCW - KeyConstant for rotating barrel CCW
      direction - Which way the tank faces
--]]
function tank:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    self.bodyImage = TextureManager.getImage(data.bodyImage or "tank")
    self.barrelImage = TextureManager.getImage(data.barrelImage or "barrel")
    self:setPos(data.x or 0, data.y or 0)
    self.scale = data.scale or 1
    self.power = data.power or 10
    self.barrelSpeed = data.barrelSpeed or 50
    self.maxHp = data.maxHp or 100
    self.hp = data.hp or 100
    self.btnShoot = data.btnShoot or " "
    self.btnRotateCW = data.btnRotateCW or "e"
    self.btnRotateCCW = data.btnRotateCCW or "q"

    local dir = data.direction or "right"
    if dir == "right" then
        self.direction = 1
        self.angleOffset = 0
    elseif dir == "left" then
        self.direction = -1
        self.angleOffset = 180
    end

    self.barrelAngle = (data.barrelAngle or 0) + self.angleOffset
end

function tank:update(dt)
    ---[[
    if self:getRelativeBarrelAngle() < 0 then
        self.barrelAngle = 0 + self.angleOffset
    elseif self:getRelativeBarrelAngle() > 90 then
        self.barrelAngle = (90 * self.direction * -1) + self.angleOffset
    end
    --]]

    if love.keyboard.isDown(self.btnRotateCW) then
        self.barrelAngle = self.barrelAngle + self.barrelSpeed * dt
    end

    if love.keyboard.isDown(self.btnRotateCCW) then
        self.barrelAngle = self.barrelAngle - self.barrelSpeed * dt
    end

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
        self.scale,
        self.scale,
        0,
        self.barrelImage:getHeight() / 2)

    love.graphics.draw(self.bodyImage,
        self.x,
        self.y,
        0,
        self.scale * self.direction,
        self.scale,
        self.bodyImage:getWidth() / 2,
        self.bodyImage:getHeight() / 2)

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.circle("fill", self.x, self.y, 5)
end

function tank:getScaledSize()
    return self.bodyImage:getWidth() * self.scale, self.bodyImage:getHeight() * self.scale
end

function tank:damage(n)
    if self:isAlive() then
        self.hp = self.hp - n
    end
end

function tank:getBarrelRads()
    return math.rad(self.barrelAngle)
end

function tank:getBarrelDeg()
    return self.barrelAngle
end

function tank:getRelativeBarrelAngle()
    return (self.barrelAngle - self.angleOffset) * (self.direction * -1)
end

function tank:getPower()
    return self.power
end

function tank:isAlive()
    return self.hp > 0
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
    if self:isAlive() then
        local a = self:getBarrelRads()
        local x, y = self:getBarrelPos()

        EntityManager.create("projectile",
        {
            image = projectiles[proj],
            x = x + math.cos(a) * (self.barrelImage:getWidth() - 10 * self.scale) * self.scale,
            y = y + math.sin(a) * (self.barrelImage:getWidth() - 10 * self.scale) * self.scale,
            power = self.power,
            angle = tank.barrelAngle,
            scale = self.scale
        })
    end
end

return tank
