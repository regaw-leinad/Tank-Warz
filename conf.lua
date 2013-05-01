require("global")

function love.conf(t)
    t.title = "Tank Warz"
    t.author = "NSCC Computer Science Club"
    t.url = "http://forums.regawmod.com"
    t.identity = "TankWarz"
    t.version = "0.8.0"
    t.console = false
    t.release = false
    t.screen.width = SCREEN_WIDTH
    t.screen.height = SCREEN_HEIGHT
    t.screen.fullscreen = false
    t.screen.vsync = true
    t.screen.fsaa = 0
    t.modules.joystick = false
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.physics = true
end