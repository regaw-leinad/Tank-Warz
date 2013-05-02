function load()
    love.graphics.setBackgroundColor(0, 245, 255)

    EntityManager.create("terrain", 0 , 0, { texture = "dirt" })
    --EntityManager.create("projectile", 10, 300, { power = 520, angle = 45 })
    --tank = EntityManager.create("tank", 200, 450)
end

function love.update(dt)
    EntityManager.update(dt)
end

function love.draw()
    EntityManager.draw()
end

function love.keypressed(k)
    if k == " " then
        tank:shoot()
    end
end