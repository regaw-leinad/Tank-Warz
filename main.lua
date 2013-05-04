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

    StateManager.startup()
    TextureManager.startup()
    EntityManager.startup()

    StateManager.loadState("game")
end