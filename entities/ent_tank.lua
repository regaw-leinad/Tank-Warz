--[[
    ent_tank.lua
    A tank with a moveable barrel that can shoot

    Authors:
        Dan Wager
--]]

local tank = EntityManager.derive("base")

--[[
    data
      image - The name of the tank texture
      x - The X coordinate
      y - The Y coordinate
      barrelImage - The name of the barrel texture
      barrelOffsetX - The X offset of the barrel from tank's x
      barrelOffsetY - The Y offset of the barrel from tank's y
      barrelPivotOffset - The X offset for the pivot (Y is always center)
      barrelOnTop - If the barrel should be drawn on top of the tank
      scale - The image scale
      power - The initial tank power
      barrelAngle - The initial angle of the barrel
      barrelSpeed - The speed of barrel's movement
      maxHp - The max health of the tank
      hp - The initial health of the tank
      direction - The direction the tank faces ("left" or "right")
--]]
function tank:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    -- Set properties
    self.image = TextureManager.getImage(data.image or "tank_red")
    self:setPos(data.x or 0, data.y or 0)
    self.barrelImage = TextureManager.getImage(data.barrelImage or "tank_red_barrel")
    self.barrelOffsetX = data.barrelOffsetX or 0
    self.barrelOffsetY = data.barrelOffsetY or 0
    self.barrelPivotOffset = data.barrelPivotOffset or 0
    self.barrelOnTop = data.barrelOnTop or false
    self.scale = data.scale or 1
    self.power = data.power or 10
    self.barrelSpeed = data.barrelSpeed or 50
    self.maxHp = data.maxHp or 100
    self.hp = data.hp or 100
    self.player = EntityManager.getCount("tank") + 1

    local dir = data.direction or "right"
    if dir == "left" then
        self.direction = -1
        self.angleOffset = 180
    else -- default to right
        self.direction = 1
        self.angleOffset = 0
    end

    self.barrelAngle = (data.barrelAngle or 0) + self.angleOffset
end

function tank:update(dt)
    if self.hp <= 0 then
        EntityManager.destroy(self.id)
    end
end

function tank:draw()
    love.graphics.setColor(255, 255, 255, 255)

    if self.barrelOnTop then
        self:drawBody()
        self:drawBarrel()
    else
        self:drawBarrel()
        self:drawBody()
    end
end

function tank:drawBody()
    love.graphics.draw(self.image,
        self.x,
        self.y,
        0,
        self.scale * self.direction,
        self.scale,
        self.image:getWidth() / 2,
        self.image:getHeight() / 2)
end

function tank:drawBarrel()
    local bx, by = self:getBarrelPos()

    love.graphics.draw(self.barrelImage,
        bx,
        by,
        math.rad(self.barrelAngle),
        self.scale,
        self.scale,
        self.barrelPivotOffset,
        self.barrelImage:getHeight() / 2)
end

function tank:rotateBarrel(dir, dt)
    if dir == "CW" then
        self.barrelAngle = self.barrelAngle + self.barrelSpeed * dt
    elseif dir == "CCW" then
        self.barrelAngle = self.barrelAngle - self.barrelSpeed * dt
    end

    if self:getRelativeBarrelAngle() <= 0 then
        self.barrelAngle = 0 + self.angleOffset
    elseif self:getRelativeBarrelAngle() >= 90 then
        self.barrelAngle = (90 * -self.direction) + self.angleOffset
    end
end

function tank:getScaledSize()
    return self.image:getWidth() * self.scale, self.image:getHeight() * self.scale
end

function tank:damage(n)
    if self:isAlive() then
        self.hp = self.hp - n
    end
end

function tank:heal(n)
    self.hp = self.hp + n

    if self.hp >self.maxHp then
        self.hp = self.maxHp
    end
end

function tank:getBarrelRads()
    return math.rad(self.barrelAngle)
end

function tank:getBarrelDeg()
    return self.barrelAngle
end

function tank:getRelativeBarrelAngle()
    return (self.barrelAngle - self.angleOffset) * (-self.direction)
end

function tank:getPower()
    return self.power
end

function tank:isAlive()
    return self.hp > 0
end

function tank:adjustPower(n)
    self.power = self.power + n

    if self.power < 0 then
        self.power = 0
    end
end

function tank:getBarrelPos()
    return self.x + self.barrelOffsetX * self.scale, self.y + self.barrelOffsetY * self.scale
end

function tank:getProjectileStartPos()
    local x, y = self:getBarrelPos()

    return x + math.cos(math.rad(self.barrelAngle)) * (self.barrelImage:getWidth() - self.barrelPivotOffset * self.scale) * self.scale,
        y + math.sin(math.rad(self.barrelAngle)) * (self.barrelImage:getWidth() - self.barrelPivotOffset * self.scale) * self.scale
end

function tank:getHp()
    return self.hp
end

function tank:getMaxHp()
    return self.maxHp
end

function tank:shoot()
    if self:isAlive() then
        local px, py = self:getProjectileStartPos()
        ProjectileManager.create(ProjectileManager.BLACK, px, py, self:getBarrelDeg(), self.power)
    end
end

return tank
