-- Main game state
-- args - level name
function load(args)
    LevelManager.load(args.lvl)
    TankManager.create("grey", 150, 400, "right")
    TankManager.create("grey", 400, 400, "left")
end

function love.update(dt)
    if love.keyboard.isDown("q") then
        EntityManager.getAll("tank")[1]:rotateBarrel("CCW", dt)
    elseif love.keyboard.isDown("e") then
        EntityManager.getAll("tank")[1]:rotateBarrel("CW", dt)
    end

    EntityManager.update(dt)
end

function love.draw()
    EntityManager.draw()

    love.graphics.print(tostring(love.timer.getFPS()), 10, 10)
end

function love.keypressed(k)
    for _,tank in pairs(EntityManager.getAll("tank")) do
        if k == tank.btnShoot then
            tank:shoot()
        elseif k == tank.btnAdjustPowerUp then
            tank:adjustPower(1)
        elseif k == tank.btnAdjustPowerDown then
            tank:adjustPower(-1)
        end
    end

    if k == 'escape' then
      love.event.quit()
    end
end
