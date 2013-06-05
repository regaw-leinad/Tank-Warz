
local function onMainMenu()
    StateManager.load("mainMenu", { noAudioReload = true })
end

function load(args)
    StateManager.destroy("game")

    bg = TextureManager.getImage("menu_background")
    ButtonManager.create(ButtonManager.MENU, 400, 450, 1, onMainMenu)

    winner = args.winner

    titleFont = love.graphics.newFont(60)
    winnerFont = love.graphics.newFont(40)

    AudioManager.setLooping("game", false)
    fade = 1
    AudioManager.play("menu", 0, true)
end

function love.update(dt)
    if fade >= 0 then
        fade = fade - dt / 3
        crossFade("game", "menu", fade)
    end

    EntityManager.update(dt)
end

function love.draw()
    love.graphics.draw(bg)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(titleFont)
    love.graphics.print("Winner!", 280, 50)
    love.graphics.setFont(winnerFont)
    love.graphics.print("Player " .. winner, 315, 200)

    EntityManager.draw()
end

function love.mousereleased(x, y, btn)
    ButtonManager.press()
end
