function load()
    world = {}
    love.graphics.setBackgroundColor(0, 245, 255)

    world.terrain = EntityManager.create("terrain", 0 , 0, { texture = "dirt" })
    world.tank = EntityManager.create("tank", 180, 400, { scale = .51 })
end

function love.update(dt)
    EntityManager.update(dt)

    if love.keyboard.isDown("w") then
        world.tank:rotateBarrel("cw", dt)
    end

    if love.keyboard.isDown("q") then
        world.tank:rotateBarrel("ccw", dt)
    end
end

function love.draw()
    EntityManager.draw()

    local sx, sy = world.tank:getPos()
    local sw, sh = world.tank:getScaledSize()

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("line", sx - sw / 2, sy - sh / 2, sw, sh)

    local infoX, helpX = 10, 200

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print("Tank Info", infoX, 10)
    love.graphics.print("--------------", infoX, 18)
    love.graphics.print("Barrel angle: " .. round(-world.tank:getBarrelDeg()), infoX, 32)
    love.graphics.print("Power: " .. world.tank:getPower(), infoX, 48)
    love.graphics.print("HP: " .. world.tank:getHp() .. "/" .. world.tank:getMaxHp(), infoX, 64)

    love.graphics.print("Help", helpX, 10)
    love.graphics.print("--------", helpX, 18)
    love.graphics.print("Press SPACE to shoot", helpX, 32)
    love.graphics.print("Press Q or W to rotate barrel", helpX, 48)
    love.graphics.print("Press A or Z to adjust power", helpX, 64)
    love.graphics.print("Click on tank to damage (hitbox is outlined in red)", helpX, 80)
    love.graphics.print("Press ESCAPE to quit", helpX, 96)
end

function love.keypressed(k)
    if k == " " then
        world.tank:shoot()
    end

    if k == "a" then
        world.tank:adjustPower(1)
    end

    if k == "z" then
        world.tank:adjustPower(-1)
    end

    if k == 'escape' then
      love.event.quit()
    end
end

function love.mousepressed(x, y, btn)
    local sx, sy = world.tank:getPos()
    local sw, sh = world.tank:getScaledSize()

    if insideBox(x, y, sx - sw / 2, sy - sh / 2, sw, sh) then
        if (world.tank:isAlive()) then
            world.tank:damage(1)
        end
    end
end