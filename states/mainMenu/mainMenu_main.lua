-- Main menu state

local function onPlay()
    StateManager.load("game", { lvl = LevelManager.PEACEFUL })
end

local function onQuit()
    love.event.quit()
end

function load(args)
    love.graphics.setBackgroundColor(255, 255, 255)

    ButtonManager.create(ButtonManager.PLAY, 400, 150, 1, onPlay)
    ButtonManager.create(ButtonManager.QUIT, 400, 450, 1, onQuit)
end

function love.update(dt)
    EntityManager.update(dt)
end

function love.draw()
    EntityManager.draw()
end

function love.mousereleased(x, y, btn)
    ButtonManager.press()
end

