ProjectileManager = {}

ProjectileManager.PINK = 1
ProjectileManager.BLACK = 2

local projectiles =
{
    [ProjectileManager.PINK] =
    {
        image = "projectile_pink",
        scale = 1,
        speedScale = 1.1,
        damage = 10
    },

    [ProjectileManager.BLACK] =
    {
        image = "projectile_black",
        scale = 1,
        speedScale = 1.1,
        damage = 20
    }
}

local function get(projectile)
    if projectiles[projectile] then
        return shallowCopy(projectiles[projectile])
    else
        print("No projectile \'" .. projectile .. "\'")
        return nil
    end
end

function ProjectileManager.getData(projectile)
    return get(projectile)
end

function ProjectileManager.create(projectile, x, y, angle, power)
    local projData = get(projectile)

    projData["x"] = x
    projData["y"] = y
    projData["angle"] = angle
    projData["power"] = power

    if projData then
        EntityManager.create("projectile", false, projData)
    end
end

function ProjectileManager.getCount()
    return EntityManager.getCount("projectile")
end
