function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
end

function string.ends(String, End)
   return End == '' or string.sub(String, -string.len(End)) == End
end

function round(val, decimal)
    if (decimal) then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    end
    -- if no place specified, round to nearest whole number
    return math.floor(val + 0.5)
end

-- Checks if point px,py is inside of a defined box
function insideBox(px, py, bx, by, bw, bh)
    if px > bx and px < bx + bw then
        if py > by and py < by + bh then
            return true
        end
    end

    return false
end

function polygonCut(midX, midY, poly)
    local t = {}

    local count = 1
    local tCount = 1

    t[tCount] = { poly[count], poly[count + 1], midX, midY, poly[#poly - 1], poly[#poly] }

    tCount = tCount + 1

    while count < #poly - 4 do
        t[tCount] = { poly[count], poly[count + 1], midX, midY, poly[count + 2], poly[count + 3] }

        tCount = tCount + 1
        count = count + 2
    end

    return t
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
