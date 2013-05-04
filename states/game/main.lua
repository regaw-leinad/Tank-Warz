function load()
    math.randomseed(os.time())

    world = {}
    projectiles = {"projectile", "cloud", "tank", "barrel"}
    proj = 1
    love.graphics.setBackgroundColor(0, 245, 255)

    for i = 1, 4 do
        EntityManager.create("cloud", { x = -256, y = 40 * i })
    end

    world.terrain = EntityManager.create("terrain", { texture = "dirt" })
    world.tank = EntityManager.create("tank", { x = 400, y = 400, scale = .5, direction = "left"})
    world.lastCollision = {}
    world.lastCollision.x = 0
    world.lastCollision.y = 0
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

    local sx, sy = world.tank:getPos()
    local sw, sh = world.tank:getScaledSize()

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("line", sx - sw / 2, sy - sh / 2, sw, sh)

    local infoX, helpX = 10, 200

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print("Info", infoX, 10)
    love.graphics.print("------", infoX, 18)
    love.graphics.print("Barrel angle: " .. round(world.tank:getRelativeBarrelAngle()), infoX, 32)
    love.graphics.print("Power: " .. world.tank:getPower(), infoX, 48)
    love.graphics.print("HP: " .. world.tank:getHp() .. "/" .. world.tank:getMaxHp(), infoX, 64)
    love.graphics.print("Terrain points: " .. world.terrain:getPointCount(), infoX, 80)
    love.graphics.print("Last Collision: " .. round(world.lastCollision.x) .. ", " .. round(world.lastCollision.y), infoX, 96)
    love.graphics.print("Current projectile: " .. projectiles[proj], infoX, 112)
    love.graphics.print("Current wind: " .. WIND / METER_SIZE .. " " .. windDir, infoX, 128)

    love.graphics.print("Help", helpX, 10)
    love.graphics.print("--------", helpX, 18)
    love.graphics.print("Press SPACE to shoot", helpX, 32)
    love.graphics.print("Press Q or E to rotate barrel", helpX, 48)
    love.graphics.print("Press A or Z to adjust power", helpX, 64)
    love.graphics.print("Press S or X to change projectile", helpX, 80)
    love.graphics.print("Press D or C to adjust wind", helpX, 96)
    love.graphics.print("Click on tank to damage (hitbox is outlined in red)", helpX, 112)
    love.graphics.print("Press ESCAPE to quit", helpX, 128)

    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), SCREEN_WIDTH - 60, 10)
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

    if k == "s" then
        proj = proj % 4 + 1

        print(proj)
    end

    if k == "x" then
        proj = proj - 1

        if proj < 1 then
            proj = #projectiles
        end

        print(proj)
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
    local sx, sy = world.tank:getPos()
    local sw, sh = world.tank:getScaledSize()

    if insideBox(x, y, sx - sw / 2, sy - sh / 2, sw, sh) then
        if (world.tank:isAlive()) then
            world.tank:damage(10)
        end
    end
end

function worldCollide(ent)
    local v = world.terrain:getCoords()
    local points = world.terrain:getPointCount()

    for i = 1, points, 2 do
        local leftX = v[i]
        local leftY = v[i+1]
        local rightX = v[i+2]
        local rightY = v[i+3]

        if leftX <= ent.x and ent.x <= rightX then
            local magic = (leftX * rightY) - (leftX * ent.y) - (leftY * rightX) + (leftY * ent.x) + (rightX * ent.y) - (ent.x * rightY)

            -- No collision
            if magic < 0 then
                return false
            else
                world.lastCollision.x = ent.x
                world.lastCollision.y = ent.y
                return true
            end
        end
    end
end
