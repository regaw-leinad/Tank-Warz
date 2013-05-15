-- Main game state
-- args - level name
local players = {}

function load(args)
    LevelManager.load(args.lvl)

    BUBBLE_FONT = love.graphics.newImageFont(TextureManager.getImagePath("font_bubble"),
    " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(BUBBLE_FONT)

    players[PLAYER1] =
    {
        projectile = ProjectileManager.BLACK
    }

    players[PLAYER2] =
    {
        projectile = ProjectileManager.PINK
    }

    CURRENT_PLAYER = PLAYER1

    local y1, a1 = getTankDrop(150)
    local y2, a2 = getTankDrop(600)

    TankManager.create(TankManager.GREY, 150, y1, "right", a1, 0)
    TankManager.create(TankManager.GREY, 600, y2, "left", a2, 0)
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
    drawHUD()
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

function drawHUD()
    local trans = 200

    love.graphics.setColor(0, 0, 0, trans)
    love.graphics.rectangle("fill", 550, 0, 250, 150)

    love.graphics.setColor(255, 255, 255, trans)
    love.graphics.print("Name", 555, 0)
    love.graphics.print("HP", 555, 16)

    love.graphics.print("PW", 555, 32)

    local t2M = TankManager.getPlayerTank(CURRENT_PLAYER):getMaxHp()
    local t2hp = TankManager.getPlayerTank(CURRENT_PLAYER):getHp()
    local ratio = t2hp / t2M

    love.graphics.setColor(0, 240, 0, trans)
    love.graphics.rectangle("fill", 580, 18, ratio * 100, 12)

    love.graphics.setColor(240, 0, 0, trans)
    love.graphics.rectangle("fill", 580 + 100 * ratio, 18, 100 - (ratio * 100), 12)

    love.graphics.setColor(255, 255, 255, trans)
    love.graphics.print(t2hp, 685, 16)

    local max = 40
    local power = TankManager.getPlayerTank(CURRENT_PLAYER):getPower()
    local ratio2 = power / max

    love.graphics.setColor(0, 240, 0, trans)
    love.graphics.rectangle("fill", 580, 34, ratio2 * 100, 12)

    love.graphics.setColor(240, 0, 0, trans)
    love.graphics.rectangle("fill", 580 + 100 * ratio2, 34, 100 - (ratio2 * 100), 12)

    love.graphics.setColor(255, 255, 255, trans)
    love.graphics.circle("line", 755, 40, 30)
    love.graphics.line(755, 6, 755, 74)
    love.graphics.line(723, 40, 788, 40)

    local b = math.rad(TankManager.getPlayerTank(CURRENT_PLAYER):getBarrelAngle())
    love.graphics.setColor(255, 0, 0, trans)
    love.graphics.line(755, 40, 755 + 34 * math.cos(b), 40 + 34 * math.sin(b))

end
