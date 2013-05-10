function load(args)
    math.randomseed(os.time())

    projectiles = {"projectile", "cloud", "tank", "barrel", "dirt"}
    proj = 1
    love.graphics.setBackgroundColor(0, 245, 255)

    for i = 1, 4 do
        EntityManager.create("cloud", true, { x = -math.random(100, 256), y = math.random(50, 300) })
    end

    EntityManager.create("terrain", true, { startY = 400, heightBuf = 30, texture = "dirt" })

    EntityManager.create("tank",
        false,
        {
            x = 150,
            y = 350,
            scale = .125,
            direction = "right",
            barrelOffsetY = -16
        })

    EntityManager.create("tank",
        false,
        {
            x = 600,
            y = 400,
            scale = .125,
            barrelOffsetY = -16,
            direction = "left",
            btnShoot = ".",
            btnRotateCW = "p",
            btnRotateCCW = "o",
            btnAdjustPowerUp = "j",
            btnAdjustPowerDown = "m"
        })
end

function love.update(dt)
    EntityManager.update(dt)
end

function love.draw()
    EntityManager.draw()
    love.graphics.print(love.timer.getFPS(), 10, 10)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(EntityManager.getAll("tank")[1]:getPower(), 10, 26)
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

    if k == "d" then
        WIND = ((WIND / METER_SIZE) + 1) * METER_SIZE
    elseif k == "c" then
        WIND = ((WIND / METER_SIZE) - 1) * METER_SIZE
    end

    if k == 'escape' then
      love.event.quit()
    end
end
