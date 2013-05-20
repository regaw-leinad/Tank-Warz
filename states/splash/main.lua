local Intro = require("states/splash/Intro")

function load()
    I=Intro()

    local t1=I:addText('Tank Warz'):setPosition(20, 50):setColor(0, 255, 0):setFont(60):center()
    local t2=I:addText('Designed by:'):setPosition(200, 170):setColor(0, 0, 255):setFont(30):center()
    local t3=I:addText('(C) 2013'):setPosition(10, 500):setColor(255,0,0):setFont(30):center()

    I:addImage('textures/tex_nscc_logo.png'):setPosition(275, 220)

    I:setDuration(3)
    I:setDelay(5)
    I:setBlinks(2, t1, t2)
    I:start()
end

function love.update(dt)
    StateManager.load("game", { lvl = LevelManager.PEACEFUL })
end
