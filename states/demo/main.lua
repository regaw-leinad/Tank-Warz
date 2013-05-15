function load(args)
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setFont(love.graphics.newImageFont(TextureManager.getImagePath("font_bubble"),
    " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\""))

    rotate = 10

    t = { 100, 100, 300, 100, 300, 200, 100, 200 }
end

function love.update(dt)
    EntityManager.update(dt)

    t2 = rotateBox(200, 150, rotate, t)

    if insidePoly(love.mouse.getX(), love.mouse.getY(), t) then
        insidet = "YES"
    else
        insidet = "NO"
    end

    if insidePoly(love.mouse.getX(), love.mouse.getY(), t2) then
        insidet2 = "YES"
    else
        insidet2 = "NO"
    end
end

function love.draw()
    EntityManager.draw()

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.polygon("line", t)
    love.graphics.polygon("line", t2)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("Angle: " .. rotate, 10, 10)
    love.graphics.print("Inside t? - " .. insidet, 10, 26)
    love.graphics.print("Inside t2? - " .. insidet2, 10, 42)

    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 580)
end

function love.keypressed(k)
    if k == "left" then
        rotate = rotate - 1
    elseif k == "right" then
        rotate = rotate + 1
    end
end