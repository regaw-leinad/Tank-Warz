-- Main game state
local players = {}

function load(args)
    -- Load level
    LevelManager.load(args.lvl)
    -- Set font
    love.graphics.setFont(
        love.graphics.newImageFont(
            TextureManager.getImagePath("font_bubble"),
                " abcdefghijklmnopqrstuvwxyz" ..
                "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
                "0123456789.,!?-+/():;%&`'*#=[]\""
        )
    )

    -- Create tanks
    TankManager.create(TankManager.GREY, 40, SCREEN_WIDTH / 2 - 40, "right")
    TankManager.create(TankManager.GREY, SCREEN_WIDTH / 2 + 40, SCREEN_WIDTH - 40, "left")

    -- Init player data
    players[PLAYER1] =
    {
        projectile = ProjectileManager.BLACK,
        tank = TankManager.getPlayerTank(PLAYER1)
    }
    players[PLAYER2] =
    {
        projectile = ProjectileManager.PINK,
        tank = TankManager.getPlayerTank(PLAYER2)
    }

    -- Set current player
    CURRENT_PLAYER = PLAYER1
end

function love.update(dt)
    if love.keyboard.isDown("q") then
        players[CURRENT_PLAYER].tank:rotateBarrel("CCW", dt)
    elseif love.keyboard.isDown("e") then
        players[CURRENT_PLAYER].tank:rotateBarrel("CW", dt)
    end

    EntityManager.update(dt)
end

function love.draw()
    EntityManager.draw()
    drawHUD()

    if DEBUG then
        -- Draw FPS
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(love.timer.getFPS(), 760, 580)
    end
end

function love.keypressed(k)
    if k == " " then
        players[CURRENT_PLAYER].tank:shoot(players[CURRENT_PLAYER].projectile)
        switchPlayer()
    elseif k == "a" then
        players[CURRENT_PLAYER].tank:adjustPower(1)
    elseif k == "z" then
        players[CURRENT_PLAYER].tank:adjustPower(-1)
    elseif k == "left" or k == "right" then
        players[CURRENT_PLAYER].projectile = (players[CURRENT_PLAYER].projectile)
            % ProjectileManager.getNumOfProjectiles() + 1
    elseif k == "d" then
        DEBUG = not DEBUG
    elseif k == "escape" then
      love.event.quit()
    end
end

-- Switches the player from 1 -> 2 or 2 -> 1
function switchPlayer()
    CURRENT_PLAYER = CURRENT_PLAYER % 2 + 1
end

-- Draws the heads up display
function drawHUD()
    -- Transparency
    local trans = 200
    -- Start X
    local startX = 0
    -- Width of the box
    local boxW = 220
    -- Height of the box
    local boxH = 75
    -- The total width of the hp and power bars
    local barW = 100
    -- The radius of the circle
    local cR = 20
    -- The padding of the lines outside of the circle
    local cP = 2

    for i = 1, 2, 1 do
        local tank = players[i].tank

        local hp = tank:getHp()
        local hpRatio = hp / tank:getMaxHp()

        local power = tank:getPower()
        local powerRatio = power / tank:getMaxPower()

        local cX, cY = startX + 190, 27

        local b = tank:getAbsoluteBarrelAngle()

        local proj = ProjectileManager.getData(players[i].projectile)
        local projImg = TextureManager.getImage(proj.image)

        -- The box
        love.graphics.setColor(50, 50, 50, trans)
        love.graphics.rectangle("fill", startX, 0, boxW, boxH)

        -- Player Name
        love.graphics.setColor(255, 255, 255, trans)
        love.graphics.print("Player " .. tank.player, startX + 7, 2)

        -- Hp text
        love.graphics.setColor(255, 255, 255, trans)
        love.graphics.print("H", startX + 7, 18)
        love.graphics.print(hp, startX + barW + 25, 18)

        -- Hp bar
        love.graphics.setColor(0, 240, 0, trans)
        love.graphics.rectangle("fill", startX + 20, 20, hpRatio * barW, 12)
        love.graphics.setColor(240, 0, 0, trans)
        love.graphics.rectangle("fill", startX + 20 + barW * hpRatio, 20,
            barW - (hpRatio * barW), 12)

        -- Power text
        love.graphics.setColor(255, 255, 255, trans)
        love.graphics.print("P", startX + 7, 34)
        love.graphics.print(round(powerRatio * 100), startX + barW + 25, 34)

        -- Power bar
        love.graphics.setColor(0, 240, 0, trans)
        love.graphics.rectangle("fill", startX + 20, 36, powerRatio * barW, 12)
        love.graphics.setColor(240, 0, 0, trans)
        love.graphics.rectangle("fill", startX + 20 + barW * powerRatio, 36,
            barW - (powerRatio * barW), 12)

        -- Barrel angle graphic
        love.graphics.setColor(255, 255, 255, trans)
        love.graphics.circle("line", cX, cY, cR)
        love.graphics.line(cX, cY - cR - cP, cX, cY + cR + cP)
        love.graphics.line(cX - cR - cP, cY, cX + cR + cP, cY)
        love.graphics.setColor(255, 0, 0, trans)
        love.graphics.line(cX, cY, cX + (cR + cP) * math.cos(math.rad(b)),
            cY + (cR + cP) * math.sin(math.rad(b)))

        -- Converts the absolute angle into relative angle
        if i % 2 == 0 then
            b = -(180 - b)
        else
            b = -b
        end

        -- Angle text
        love.graphics.setColor(255, 255, 255, trans)
        love.graphics.print("A:" .. round(b), cX - cR - 10, cY + cR + 5)

        -- Projectile stuff
        love.graphics.setColor(255, 255, 255, trans)
        love.graphics.polygon("fill", {
            startX + 7, 60, startX + 14, 65, startX + 14, 55
        })

        love.graphics.draw(projImg, startX + 24 - projImg:getWidth() / 2,
            60 - projImg:getHeight() / 2)

        love.graphics.polygon("fill", {
            startX + 40, 60, startX + 33, 65, startX + 33, 55
        })

        love.graphics.print("D:" .. proj.damage, startX + 50, 52)
        startX = startX + 580
    end
end
