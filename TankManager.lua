TankManager = {}

local tanks =
{
    ["red"] =
    {
        image = "tank_red",
        barrelImage = "tank_red_barrel",
        barrelOffsetX = 0,
        barrelOffsetY = -16,
        scale = .125,
        power = 10,
        barrelAngle = 0,
        barrelSpeed = 30,
        maxHp = 100,
        hp = 100
    },

    ["grey"] =
    {
        image = "tank_grey",
        barrelImage = "tank_grey_barrel",
        barrelOffsetX = 0,
        barrelOffsetY = 0,
        barrelPivotOffset = 9,
        barrelOnTop = true,
        scale = 1,
        power = 20,
        barrelAngle = 0,
        barrelSpeed = 50,
        maxHp = 200,
        hp = 200
    }
}

local function get(tank)
    if tanks[tank] then
        return shallowCopy(tanks[tank])
    else
        print("No tank \'" .. tank .. "\'")
        return nil
    end
end

function TankManager.getData(tank)
    return get(tank)
end

function TankManager.create(tank, x, y, direction)
    local tankData = get(tank)

    tankData["x"] = x
    tankData["y"] = y
    tankData["direction"] = direction

    if tankData then
        EntityManager.create("tank", false, tankData)
    end
end

function TankManager.getCount()
    return EntityManager.getCount("tank")
end
