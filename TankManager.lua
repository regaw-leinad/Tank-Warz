TankManager = {}

TankManager.RED = 1
TankManager.GREY = 2

local tanks =
{
    [TankManager.RED] =
    {
        image = "tank_red",
        imageW, imageH = TextureManager.getImageDimensions("tank_red"),
        barrelImage = "tank_red_barrel",
        barrelImageW, barrelImageH = TextureManager.getImageDimensions("tank_red_barrel"),
        barrelOffsetX = 0,
        barrelOffsetY = -16,
        scale = .125,
        power = 10,
        barrelSpeed = 30,
        maxHp = 100,
        hp = 100
    },

    [TankManager.GREY] =
    {
        image = "tank_grey",
        imageW, imageH = TextureManager.getImageDimensions("tank_grey"),
        barrelImage = "tank_grey_barrel",
        barrelImageW, barrelImageH = TextureManager.getImageDimensions("tank_grey"),
        barrelOffsetX = 0,
        barrelOffsetY = 0,
        barrelPivotOffset = 9,
        barrelOnTop = true,
        scale = 1,
        power = 20,
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

function TankManager.create(tank, x, y, direction, barrelAngle)
    local tankData = get(tank)

    tankData["x"] = x
    tankData["y"] = y
    tankData["direction"] = direction
    tankData["barrelAngle"] = barrelAngle or 0

    if tankData then
        EntityManager.create("tank", false, tankData)
    end
end

function TankManager.getCount()
    return EntityManager.getCount("tank")
end

function TankManager.getPlayerTank(player)
    for _,tank in ipairs(EntityManager.getAll("tank")) do
        if tank.player == player then
            return tank
        end
    end

    print("No tank with player " .. player)
    return nil
end
