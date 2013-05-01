function load()
    love.graphics.setBackgroundColor(128, 0, 0)

    EntityManager.create("terrain")

    EntityManager.create("projectile")
end

function love.update(dt)
    EntityManager.update(dt)
end

function love.draw()
    EntityManager.draw()
end