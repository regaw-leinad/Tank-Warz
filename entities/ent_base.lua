--[[
    ent_base.lua
    The base entity all others derive from

    Authors:
        Dan Wager
--]]

local base = {}

base.x = 0
base.y = 0
base.w = 0
base.h = 0

function base:load(data)
end

function base:setPos(x, y)
	self.x = x
	self.y = y
end

function base:getPos()
	return self.x, self.y
end

function base:setSize(w, h)
    self.w = w
    self.h = h
end

function base:getSize()
    return self.w, self.h
end

function base:getID()
    return self.id
end

function base:getType()
    return self.type
end

return base
