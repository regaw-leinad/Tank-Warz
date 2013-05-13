--- Override me!
function load()
end

--- Main love.load
function love.load()
    --inspect = require("inspect")
    require("collision")
    require("util")
    require("TextureManager")
    require("EntityManager")
    require("StateManager")
    require("LevelManager")
    require("TankManager")
    require("ProjectileManager")

    StateManager.startup("states/")
    TextureManager.startup("textures/")
    EntityManager.startup("entities/")

    StateManager.load("game", { lvl = "peaceful"})
end
