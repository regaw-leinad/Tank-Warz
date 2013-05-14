-- Main game state
-- args - level name
local players = {}

function load(args)
    LevelManager.load(args.lvl)

    players[PLAYER1] =
    {
        projectile = ProjectileManager.BLACK
    }

    players[PLAYER2] =
    {
        projectile = ProjectileManager.PINK
    }

    CURRENT_PLAYER = PLAYER1


    -- Here is where we do the placing algorithm for the tanks

    TankManager.create(TankManager.GREY, 150, 400, "right", 0)
    TankManager.create(TankManager.GREY, 600, 400, "left", 0)
end

function love.update(dt)
    if love.keyboard.isDown("q") then
        TankManager.getPlayerTank(CURRENT_PLAYER):rotateBarrel("CCW", dt)
    elseif love.keyboard.isDown("e") then
        TankManager.getPlayerTank(CURRENT_PLAYER):rotateBarrel("CW", dt)
    end

    EntityManager.update(dt)
end

function love.draw()
    EntityManager.draw()
    love.graphics.print(tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("Current player: Player " .. CURRENT_PLAYER, 10, 26)
end

function love.keypressed(k)
    if k == " " then
        TankManager.getPlayerTank(CURRENT_PLAYER):shoot(players[CURRENT_PLAYER].projectile)
        switchPlayer()
    elseif k == "a" then
        TankManager.getPlayerTank(CURRENT_PLAYER):adjustPower(1)
    elseif k == "z" then
        TankManager.getPlayerTank(CURRENT_PLAYER):adjustPower(-1)
    elseif k == 'escape' then
      love.event.quit()
    end
end

-- Switches the player from 1 -> 2 or 2 -> 1
function switchPlayer()
    CURRENT_PLAYER = CURRENT_PLAYER % 2 + 1
end