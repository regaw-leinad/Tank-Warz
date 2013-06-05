--[[
    ent_button.lua
    A button for menus, etc.

    Authors:
        Dan Wager
--]]

local button = EntityManager.derive("base")

--[[
    data
      imageNormal - The normal image
      imageHover - The image when the mouse is hovering
      imagePressed - The image when the button is pressed
      scale - The button scale
      onPressed - Function callback to run when pressed
--]]
function button:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end

    self:setPos(data.x, data.y)
    self.imageNormal = TextureManager.getImage(data.imageNormal)
    self.imageHover = TextureManager.getImage(data.imageHover)

    self.hover = false
    self.hoverSound = true
    self.scale = data.scale
    self:setSize(TextureManager.getImageDimensions(data.imageNormal))
    self.onPressed = data.onPressed
end

function button:update(dt)
    local mx, my = love.mouse.getPosition()

    if insideBox(mx, my, self.x - self.w / 2 * self.scale, self.y - self.h / 2 * self.scale,
        self.w * self.scale, self.h * self.scale) then
        self.hover = true

        if self.hoverSound then
            AudioManager.play("hover")
            self.hoverSound = false
        end
    else
        self.hover = false
        self.hoverSound = true
    end

end

function button:draw()
    love.graphics.setColor(255, 255, 255, 255)

    if self.hover then
        love.graphics.draw(self.imageHover,
            self.x,
            self.y,
            0,
            self.scale,
            self.scale,
            self.w / 2,
            self.h / 2)
    else
        love.graphics.draw(self.imageNormal,
            self.x,
            self.y,
            0,
            self.scale,
            self.scale,
            self.w / 2,
            self.h / 2)
    end
end

function button:onPressed()
    self.onPressed()
end

return button
