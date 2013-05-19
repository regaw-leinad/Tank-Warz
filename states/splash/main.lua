local Intro = require("states/splash/Intro")

function load()
    I=Intro()
    local t1=I:addText('Tank Warz'):setPosition(20, 50):setColor(0, 255, 0):setFont(60):center()
    local t2=I:addText('Made by the NSCC Comp Sci Club'):setPosition(200, 200):setColor(0, 0, 255):setFont(30):center()
    local t3=I:addText('(C) 2013'):setPosition(10, 500):setColor(255,0,0):setFont(40):center()
    --I:addImage('logo.png'):setPosition(200, 180)

    --I:addAudio('splash.ogg')
    I:setDuration(5)
    I:setDelay(5)
    I:setBlinks(2, t1, t2)
    I:start()
end

function love.update(dt)
    StateManager.load("game", { lvl = LevelManager.PEACEFUL })
end

function love.draw()

end