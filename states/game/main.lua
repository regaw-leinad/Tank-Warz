-- Main game state
-- args - level name
local level

function load(args)
    level = LevelManager.getLevelData(args)

    if level.skyColor then
        love.graphics.setBackgroundColor(unpack(level.skyColor))
    elseif level.skyTexture then
        -- Ian's tile texturizing algorithm
    end

    -- Draw the terrain
    EntityManager.create("terrain", true,
        {
            texture = level.terrainTexture
        })

    for ent,num in pairs(level.skyEntities) do
        for i = 1, num do
            EntityManager.create(ent, true)
        end
    end

    if level.wind then
        WIND = level.wind * METER_SIZE
    end

    if level.gravity then
        GRAVITY = level.gravity * METER_SIZE
    end

    EntityManager.create("tank",
        false,
        {
            image = "tank2",
            x = 100,
            y = 350,
            barrelImage = "barrel2",
        })

    EntityManager.create("tank",
        false,
        {
            image = "tank2",
            x = 500,
            y = 350,
            barrelImage = "barrel2",
            direction = "left",
            btnShoot = ".",
            btnRotateCW = "p",
            btnRotateCCW = "i",
            btnAdjustPowerDown = "m",
            btnAdjustPowerUp = "j"

        })
end

function love.update(dt)
    EntityManager.update(dt)
end

function love.draw()
    EntityManager.draw()

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(WIND / METER_SIZE, 10, 10)
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
