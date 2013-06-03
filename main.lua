--- Override me!
function load()
end

--- Main love.load
function love.load()
    require("collision")
    require("util")
    require("ai")

    require("TextureManager")
    require("EntityManager")
    require("StateManager")
    require("AudioManager")
    require("ButtonManager")

    StateManager.startup("states/")
    TextureManager.startup("textures/")
    EntityManager.startup("entities/")
    AudioManager.startup("sounds/")

    require("LevelManager")
    require("TankManager")
    require("ProjectileManager")

    StateManager.load("mainMenu")
end
