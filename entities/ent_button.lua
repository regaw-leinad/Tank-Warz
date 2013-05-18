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
--]]
function button:load(data)
    -- Init data if not passed so we don't have errors
    if not data then data = {} end
end

function button:update(dt)

end

function button:draw()

end

function button:onPressed()

end

return projectile
