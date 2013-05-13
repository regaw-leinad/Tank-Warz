--- Override me!
function load()
end

--- Main love.load
function love.load()
    --inspect = require("inspect")
    require("Gameplay")
    require("collision")
    require("util")
    require("TextureManager")
    require("EntityManager")
    require("StateManager")

    StateManager.startup("states/")
    TextureManager.startup("textures/")
    EntityManager.startup("entities/")

    require("LevelManager")
    require("TankManager")
    require("ProjectileManager")

    StateManager.load("game", { lvl = "peaceful"})
end
