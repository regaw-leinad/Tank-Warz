--[[
    ProjectileManager.lua
    Manages the different projectiles in the application

    Authors:
        Dan Wager
--]]

ProjectileManager = {}

-- The multiplier of dt in physics
local SPEED_SCALE = 1.3

-- The pink projectile
ProjectileManager.PINK = 1
-- The black projectile
ProjectileManager.BLACK = 2

-- Table of projectiles with values
local projectiles =
{
    [ProjectileManager.PINK] =
    {
        image = "projectile_pink",
        scale = 1,
        speedScale = SPEED_SCALE,
        damage = 10
    },

    [ProjectileManager.BLACK] =
    {
        image = "projectile_black",
        scale = 1,
        speedScale = SPEED_SCALE,
        damage = 20
    }
}

-- Gets a copy of the projectile's value table
-- @param projectile The projectile
-- @return The table of values for the specified projectile (table)
local function get(projectile)
    if projectiles[projectile] then
        return shallowCopy(projectiles[projectile])
    else
        print("No projectile \'" .. projectile .. "\'")
        return nil
    end
end

-- Gets a table containing the initialization data for the specified projectile
-- @param projectile The projectile
-- @return The table of init data for the specified projectile (table)
function ProjectileManager.getData(projectile)
    return get(projectile)
end

-- Creates a new projectile entity
-- @param projectile The projectile
-- @param x The X coordinate of the projectile
-- @param y The Y coordinate of the projectile
-- @param angle The initial angle of travel
-- @param power The magnitude of the force
-- @param parent The entity that spawned the projectile
function ProjectileManager.create(projectile, x, y, angle, power, parent)
    local projData = get(projectile)

    projData.x = x
    projData.y = y
    projData.angle = angle
    projData.power = power
    projData.parent = parent

    if projData then
        EntityManager.create("projectile", false, projData)
    end
end

-- Gets a value indicating the count of all projectile entities in the current state
-- @return The number of projectile entities in the current state (int)
function ProjectileManager.getCount()
    return EntityManager.getCount("projectile")
end

-- Gets the number of registered projectiles
-- @return The number of registered projectiles
function ProjectileManager.getNumOfProjectiles()
    return #projectiles
end
