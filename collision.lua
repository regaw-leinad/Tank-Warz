-- Checks if point px,py is inside of a defined box
function insideBox(px, py, bx, by, bw, bh)
    if px > bx and px < bx + bw then
        if py > by and py < by + bh then
            return true
        end
    end

    return false
end

function terrainCollide(x, y)
    local terrain = EntityManager.getAll("terrain")[1]
    local v = terrain:getCoords()
    local points = terrain:getPointCount()

    for i = 1, points, 2 do
        local leftX = v[i]
        local leftY = v[i+1]
        local rightX = v[i+2]
        local rightY = v[i+3]

        if leftX <= x and x <= rightX then

            local magic = (leftX * rightY) - (leftX * y) -
                            (leftY * rightX) + (leftY * x) +
                            (rightX * y) - (x * rightY)

            -- No collision
            if magic < 0 then
                return false
            else
                return true
            end
        end
    end
end

function tankCollide(x, y, power)
    for _,tank in pairs(EntityManager.getAll("tank")) do

        local sx, sy = tank:getPos()
        local sw, sh = tank:getScaledSize()

        if insideBox(x, y, sx - sw / 2, sy + 10 - sh / 2, sw, sh) then
            -- Collision with tank
            print("collision with tank")
            tank:damage(power)

            return true
        end
    end

    return false
end
