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
    require("AudioManager")

    StateManager.startup("states/")
    TextureManager.startup("textures/")
    EntityManager.startup("entities/")
    AudioManager.startup("sounds/")

    require("LevelManager")
    require("TankManager")
    require("ProjectileManager")

    AudioManager.play("splash")

    --StateManager.load("game", { lvl = LevelManager.PEACEFUL })
end
