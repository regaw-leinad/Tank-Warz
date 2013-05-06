--[[
    ent_box.lua
    A black box, just as an example

    Authors:
        Dan Wager
--]]

local box = EntityManager.derive("base")

function box:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    self:setPos(data.x or 0, data.y or 0)
    self:setSize(data.w or 64, data.h or 64)
    self.speed = data.speed or 32
end

function box:update(dt)
    self.y = self.y + self.speed * dt
end

function box:draw()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return box
