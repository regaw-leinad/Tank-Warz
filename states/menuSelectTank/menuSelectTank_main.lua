-- Tank selection state

local player1 = {}
local player2 = {}
local currentTank1 = TankManager.GREY
local currentTank2 = TankManager.GREY
local p2AI = false

local function onPlay()
    local args =
    {
        ["lvl"] = LevelManager.PEACEFUL,
        ["p1"] = player1,
        ["p2"] = player2
    }

    StateManager.load("game", args)
end

local function onBack()
    StateManager.resume("mainMenu")
end

local function onLeft1()
    -- since we only have 1 tank, ignore for now
    player1.tank = currentTank1
end

local function onLeft2()
    -- since we only have 1 tank, ignore for now
    player1.tank = currentTank1
end

local function onRight1()
    -- since we only have 1 tank, ignore for now
    player2.tank = currentTank2
end

local function onRight2()
    -- since we only have 1 tank, ignore for now
    player2.tank = currentTank2
end

function load(args)
    bg = TextureManager.getImage("menu_background")
    selectTank = TextureManager.getImage("tank_select")
    tank1 = TextureManager.getImage("tank_grey_large")
    startY = 180

    -- Assign init values for players
    player1.tank = currentTank1
    player2.tank = currentTank2
    player2.ai = AI.EASY

    titleFont = love.graphics.newFont(60)
    playerFont = love.graphics.newFont(28)

    ButtonManager.create(ButtonManager.ARROW_L, 50, startY + 150, .75, onLeft1)
    ButtonManager.create(ButtonManager.ARROW_R, 335, startY + 150, .75, onRight1)

    ButtonManager.create(ButtonManager.ARROW_L, 465, startY + 150, .75, onLeft2)
    ButtonManager.create(ButtonManager.ARROW_R, 750, startY + 150, .75, onRight2)

    ButtonManager.create(ButtonManager.PLAY, 690, 560, .75, onPlay)
    ButtonManager.create(ButtonManager.BACK, 110, 560, .75, onBack)
end

function love.update(dt)
    EntityManager.update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(bg)

    love.graphics.draw(selectTank,
        400,
        65,
        0,
        1.45,
        1.45,
        selectTank:getWidth() / 2,
        selectTank:getHeight() / 2)

    love.graphics.draw(tank1,
        205,
        startY + 150,
        0,
        .5,
        .5,
        tank1:getWidth() / 2,
        tank1:getHeight() / 2)

    love.graphics.draw(tank1,
        620,
        startY + 150,
        0,
        .5,
        .5,
        tank1:getWidth() / 2,
        tank1:getHeight() / 2)



    love.graphics.setColor(0, 0, 0, 255)

    love.graphics.setFont(playerFont)
    love.graphics.print("Player 1", 135, startY)
    love.graphics.print("Player 2", 555, startY)

    love.graphics.line(399, startY, 399, startY + 280)
    love.graphics.line(400, startY, 400, startY + 280)
    love.graphics.line(401, startY, 401, startY + 280)

    EntityManager.draw()
end

function love.mousereleased(x, y, btn)
    ButtonManager.press()
end

