function load()
    math.randomseed(os.time())

    projectiles = {"projectile", "cloud", "tank", "barrel", "dirt"}
    proj = 1
    love.graphics.setBackgroundColor(0, 245, 255)

    for i = 1, 4 do
        EntityManager.create("cloud", true, { x = -math.random(100, 256), y = math.random(50, 300) })
    end

    -- EntityManager.create("projectile", false,
    -- {
    --     image = "cloud",


    -- })

    local terrain = EntityManager.create("terrain", true, { texture = "dirt" })

    local halfX = terrain:getPointCount() / 2



    EntityManager.create("tank",
        false,
        {
            x = 150,
            y = 350,
            scale = .3,
            direction = "right"
            --bodyAngle = 45
        })

    EntityManager.create("tank",
        false,
        {
            x = 800,
            y = 400,
            scale = .3,
            direction = "left",
            btnShoot = ".",
            btnRotateCW = "p",
            btnRotateCCW = "o"
            --bodyAngle = 45
        })

    print(#EntityManager.getAll("tank"))
end

function love.update(dt)
    EntityManager.update(dt)

    if WIND / METER_SIZE < 0 then
        windDir = "left"
    elseif WIND / METER_SIZE > 0 then
        windDir = "right"
    else
        windDir = ""
    end
end

function love.draw()
    EntityManager.draw()
end

function love.keypressed(k)
    for _,tank in pairs(EntityManager.getAll("tank")) do
        if k == tank.btnShoot then
            tank:shoot()
        end
    end

    if k == "a" then
        tank:adjustPower(1)
    end

    if k == "z" then
        tank:adjustPower(-1)
    end

    if k == "s" then
        proj = proj % #projectile + 1
    end

    if k == "x" then
        proj = proj - 1

        if proj < 1 then
            proj = #projectiles
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

function love.mousepressed(x, y, btn)
    local sx, sy = tank:getPos()
    local sw, sh = tank:getScaledSize()

    if insideBox(x, y, sx - sw / 2, sy - sh / 2, sw, sh) then
        if (tank:isAlive()) then
            tank:damage(10)
        end
    end
end
