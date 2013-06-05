-- Main menu state

local function onPlay()
    StateManager.load("menuSelectTank")
end

local function onQuit()
    love.event.quit()
end

local function onControls()
    StateManager.load("controls")
end

function load(args)
    if not args then args = {} end

    if not args.noAudioReload then
        AudioManager.play("menu", 1, true)
    end

    shouldFade = args.shouldFade or false
    fade = 1

    bg = TextureManager.getImage("menu_background")
    logo = TextureManager.getImage("logo")
    nscc = TextureManager.getImage("nscc_logo")
    nsccScale = .2

    ButtonManager.create(ButtonManager.PLAY, 400, 350, 1, onPlay)
    ButtonManager.create(ButtonManager.CONTROLS, 400, 440, 1, onControls)
    ButtonManager.create(ButtonManager.QUIT, 400, 530, 1, onQuit)
end

function love.update(dt)
    if shouldFade and fade >= 0 then
        fade = fade - dt / 3
        crossFade("game", "menu", fade)
    end

    EntityManager.update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(bg)

    love.graphics.draw(logo,
        400,
        logo:getHeight() / 2,
        0,
        1,
        1,
        logo:getWidth() / 2,
        logo:getHeight() / 2)

    love.graphics.draw(nscc,
        770,
        570,
        0,
        nsccScale,
        nsccScale,
        nscc:getWidth() / 2,
        nscc:getHeight() / 2)

    EntityManager.draw()
end

function love.mousereleased(x, y, btn)
    local sw, sh = nscc:getWidth() * nsccScale, nscc:getHeight() * nsccScale

    if insideBox(x, y, 770 - sw / 2, 570 - sh / 2, sw, sh) then
        if osType() == "UNIX" then
            os.execute("open https://github.com/regaw-leinad/NSCC-Project")
        elseif osType() == "WINDOWS" then
            os.execute("start https://github.com/regaw-leinad/NSCC-Project")
        end
    end

    ButtonManager.press()
end
