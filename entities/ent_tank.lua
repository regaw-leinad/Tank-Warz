local ent = EntityManager.derive("base")

function ent:load(x, y)
    self.bodyImage = TextureManager.get("tank")
    self:setPos(x, y)
    self.scale = .25
    self.size = 512
    self.hp = 100
end

function ent:update(dt)
    if self.hp <= 0 then
        EntityManager.destroy(self.id)
    end
end

function ent:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.bodyImage, self.x, self.y, 0, self.scale, self.scale)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(self.hp, 10, 10)
end

function ent:damage(n)
    self.hp = self.hp - n
end

function ent:die()

end

return ent;