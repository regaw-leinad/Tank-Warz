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
      maxPower - The max power of the tank
      angle - The angle of the tank
      barrelAngle - The initial angle of the barrel
      barrelSpeed - The speed of barrel's movement
      maxHp - The max health of the tank
      hp - The initial health of the tank
      direction - The direction the tank faces ("left" or "right")
--]]
function tank:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    local dir = data.direction or "right"
    if dir == "left" then
        self.direction = -1
        self.angleOffset = 180
    else -- default to right
        self.direction = 1
        self.angleOffset = 0
    end

    -- Set properties
    self.image = TextureManager.getImage(data.image or "tank_red")
    self.angle = data.angle or 0
    self:setPos(data.x or 0, data.y or 0)
    self.barrelImage = TextureManager.getImage(data.barrelImage or "tank_red_barrel")
    self.barrelOffsetX = data.barrelOffsetX or 0
    self.barrelOffsetY = data.barrelOffsetY or 0
    self.barrelPivotOffset = data.barrelPivotOffset or 0
    self.barrelOnTop = data.barrelOnTop or false
    self.scale = data.scale or 1
    self.power = data.power or 20
    self.maxPower = data.maxPower or 40
    self.barrelSpeed = data.barrelSpeed or 50
    self.maxHp = data.maxHp or 100
    self.hp = data.hp or 100
    self.player = EntityManager.getCount("tank") + 1

    self:setRelativeBarrelAngle(data.barrelAngle or 0)

    -- The initial hitbox (not rotated)
    local box =
    {
        self.x - self.image:getWidth() / 2 * self.scale,
        self.y - self.image:getHeight() / 2 * self.scale,
        self.x + self.image:getWidth() / 2 * self.scale,
        self.y - self.image:getHeight() / 2 * self.scale,
        self.x + self.image:getWidth() / 2 * self.scale,
        self.y + self.image:getHeight() / 2 * self.scale,
        self.x - self.image:getWidth() / 2 * self.scale,
        self.y + self.image:getHeight() / 2 * self.scale,
    }

    self.poly = rotateBox(self.x, self.y, self.angle, box)
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

    -- love.graphics.setColor(255, 0, 0, 255)
    -- love.graphics.polygon("line", self:getBoundingPoly())
    -- love.graphics.circle("fill", self.x, self.y, 2)
end

function tank:drawBody()
    love.graphics.draw(self.image,
        self.x,
        self.y,
        math.rad(self.angle),
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
        math.rad(self.barrelAngle + self.angle),
        self.scale,
        self.scale,
        self.barrelPivotOffset,
        self.barrelImage:getHeight() / 2)
end

-- Rotates the barrel
-- @param dir The direction of rotation
-- @param dt Delta time
function tank:rotateBarrel(dir, dt)
    if dir == "CW" then
        self.barrelAngle = self.barrelAngle + self.barrelSpeed * dt
    elseif dir == "CCW" then
        self.barrelAngle = self.barrelAngle - self.barrelSpeed * dt
    end

    local angle = self:getRelativeBarrelAngle()

    if angle <= 0 then
        self:setRelativeBarrelAngle(0)
    elseif angle >= 180 then
        self:setRelativeBarrelAngle(180)
    end
end

-- Gets a value indicating the size of the scaled tank image
-- @return The scaled dimensions of the tank (int, int)
function tank:getScaledSize()
    return self.image:getWidth() * self.scale, self.image:getHeight() * self.scale
end

-- Applies damage to the tank's hp
-- @param n The amount of damage
function tank:damage(n)
    if self:isAlive() then
        self.hp = self.hp - n
    end
end

-- Heals the tank
-- @param n The amount of healing
function tank:heal(n)
    self.hp = self.hp + n

    if self.hp > self.maxHp then
        self.hp = self.maxHp
    end
end

-- Gets a value indicating the angle of the barrel in relation to the tank's angle
-- @return The angle of the barrel (int, int)
function tank:getRelativeBarrelAngle()
    return (self.barrelAngle - self.angleOffset) * (-self.direction)
end

-- Sets the angle of the barrel in relation to the tank's angle
-- @param a The angle
function tank:setRelativeBarrelAngle(a)
    self.barrelAngle = a * (-self.direction) + self.angleOffset
end

-- Gets the exact barrel angle
-- @return The barrel angle
function tank:getAbsoluteBarrelAngle()
    return self.angle + self.barrelAngle
end

-- Gets a value indicating the power of the tank
-- @return The power of the tank (int)
function tank:getPower()
    return self.power
end

-- Gets a value indicating the max power of the tank
-- @return The max power of the tank
function tank:getMaxPower()
    return self.maxPower
end

-- Gets a value indicating if the tank is alive
-- @return If the tank is alive (boolean)
function tank:isAlive()
    return self.hp > 0
end

-- Adjusts the power of the tank
-- @param n The change in power
function tank:adjustPower(n)
    self.power = self.power + n

    if self.power < 0 then
        self.power = 0
    elseif self.power > self.maxPower then
        self.power = self.maxPower
    end
end

-- Gets the X and Y coordinates of the beginning of the barrel
-- @return The barrel's position (int, int)
function tank:getBarrelPos()
    return self.x + math.cos(math.rad(self.angle)) * self.barrelOffsetX * self.direction * self.scale,
        self.y + math.sin(math.rad(self.angle)) * self.barrelOffsetY * self.direction * self.scale
end

-- Gets the X and Y coordinate of where the projectile will start from
-- @return The projectile's initial coordinates (int, int)
function tank:getProjectileStartPos()
    local x, y = self:getBarrelPos()

    return
        x + math.cos(math.rad(self.barrelAngle + self.angle)) * (self.barrelImage:getWidth() -
            self.barrelPivotOffset * self.scale) * self.scale,

        y + math.sin(math.rad(self.barrelAngle + self.angle)) * (self.barrelImage:getWidth() -
            self.barrelPivotOffset * self.scale) * self.scale
end

-- Returns the bounding polygon
-- @return The bounding polygon (table)
function tank:getBoundingPoly()
    return self.poly
end

-- Gets the tank's current HP
-- @return The tank's current HP (int)
function tank:getHp()
    return self.hp
end

-- Gets the tank's max HP
-- @return The tank's max HP (int)
function tank:getMaxHp()
    return self.maxHp
end

-- Shoots a projectile from the tank
-- @param projectile The projectile
function tank:shoot(projectile)
    if self:isAlive() then
        local px, py = self:getProjectileStartPos()
        ProjectileManager.create(projectile, px, py, self.barrelAngle + self.angle, self.power, self)
    end
end

return tank
