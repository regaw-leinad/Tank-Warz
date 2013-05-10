--- Override me!
function load()
end

--- Main love.load
function love.load()
    --inspect = require("inspect")
    require("util")
    require("TextureManager")
    require("EntityManager")
    require("StateManager")
    require("LevelManager")

    StateManager.startup("states/")
    TextureManager.startup("textures/")
    EntityManager.startup("entities/")

    StateManager.load("game", "ahhh")
end
