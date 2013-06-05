-- Main menu state

local function onBack()
    StateManager.resume("mainMenu")
end

function load(args)
    bg = TextureManager.getImage("menu_background")

    ButtonManager.create(ButtonManager.BACK, 110, 560, .75, onBack)

    title = TextureManager.getImage("btn_controls_h")

    titleFont = love.graphics.newFont(60)
    controlsFont = love.graphics.newFont(28)
end

function love.update(dt)
    EntityManager.update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(bg)


    love.graphics.draw(title,
        400,
        title:getHeight() / 2 * 2 + 20,
        0,
        2,
        2,
        title:getWidth() / 2,
        title:getHeight() / 2)


    -- love.graphics.setFont(titleFont)
    -- love.graphics.print("Controls", 265, 40)
    love.graphics.setColor(0, 0, 0, 255)
    local x, y = 230, 175


    love.graphics.setFont(controlsFont)
    love.graphics.print("Space - Shoot Projectile", x, y)
    love.graphics.print("Left/Right - Switch Projectile", x, y + 50)
    love.graphics.print("Q - Rotate Barrel CCW", x, y + 100)
    love.graphics.print("W - Rotate Barrel CW", x, y + 150)
    love.graphics.print("A - Increase Power", x, y + 200)
    love.graphics.print("Z - Decrease Power", x, y + 250)
    love.graphics.print("D - Toggle Debug View", x, y + 300)






    EntityManager.draw()
end

function love.mousereleased(x, y, btn)
    ButtonManager.press()
end

