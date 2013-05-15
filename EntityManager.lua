--[[
    EntityManager.lua
    Manages the different entities in the application

    Authors:
        Dan Wager
--]]

EntityManager = {}

-- Holds the actual entites currently in each state
local objects = {}
-- A table of all the valid entities
local register = {}
-- the path to the entities' directory
local path
-- The filename prefix all entities need to have to be registered
local prefix = "ent_"
-- The index ID for the entities
local id = 0

-- Starts up the EntityManager
-- @param entPath The entities directory (relative)
function EntityManager.startup(entPath)
    path = entPath or "entities/"

    local files = love.filesystem.enumerate(path)

    for _,file in pairs(files) do
        if string.starts(file, prefix) then
            local name = file:gsub(prefix, ""):gsub(".lua", "")
            register[name] = love.filesystem.load(path .. file)
        end
    end
end

-- Allows other entities to derive from the specified entitiy
-- @param name The entity to derive from
-- @return The entity to derive from (entity/table)
function EntityManager.derive(name)
    if register[name] then
        return register[name]()
    else
        print("Entitiy \'" .. name .. "\' not registered")
        return nil
    end
end

-- Creates a new entity
-- @param name The entity
-- @param background If the entity should be drawn in the background (first)
-- @param data A table of init data for the entity
-- @return The new entity (entity/table)
function EntityManager.create(name, background, data)
    local state = StateManager.getCurrentState()

    if not objects[state] then objects[state] = {} end

    if register[name] then
        local ent = register[name]()
        id = id + 1
        ent:load(data)
        ent.id = id
        ent.type = name
        ent.background = background
        objects[state][id] = ent
        return objects[state][id]
    else
        print("Entitiy \'" .. name .. "\' not registered")
        return nil
    end
end

-- Gets all of the specified entity in the current state
-- @param enyType The entity type to get
-- @return A table of entities (table)
function EntityManager.getAll(entType)
    local state = StateManager.getCurrentState()
    local t = {}

    if objects[state] then
        for _,ent in pairs(objects[state]) do
            if ent.type == entType then
                table.insert(t, ent)
            end
        end

        if #t > 0 then
            return t
        else
            print("No entities of type \'" .. entType .. "\'")
            return {}
        end
    else
        print("No entites in state...")
        return nil
    end
end

-- Gets the count of the specified entity in the current state
-- @param entType The entity type
-- @return The count of entities (int)
function EntityManager.getCount(entType)
    local state = StateManager.getCurrentState()
    local count = 0

    if objects[state] then
        for _,ent in pairs(objects[state]) do
            if ent.type == entType then
                count = count + 1
            end
        end
    end

    return count
end

-- Updates all entities in the current state
-- @param dt Delta time
function EntityManager.update(dt)
    local state = StateManager.getCurrentState()

    if objects[state] then
        for _,ent in pairs(objects[state]) do
            if ent.update then
                ent:update(dt)
            end
        end
    end
end

-- Draws all entities in the current state to the screen
-- Draws background entities first
function EntityManager.draw()
    local state = StateManager.getCurrentState()

    if objects[state] then
        for _,ent in pairs(objects[state]) do
            if ent.background and ent.draw then
                ent:draw()
            end
        end

        for _,ent in pairs(objects[state]) do
            if not ent.background and ent.draw then
                ent:draw()
            end
        end
    end
end

-- Removes an entity from the current state and memory
-- @param id the entity's id
function EntityManager.destroy(id)
    local state = StateManager.getCurrentState()

    if objects[state] and objects[state][id] then
        if objects[state][id].die then
            objects[state][id]:die()
        end

        objects[state][id] = nil
    end
end

-- Removes all entities from the current state and memory
-- @param state The state to remove all entities from
function EntityManager.destroyStateEntities(state)
    if not state then state = StateManager.getCurrentState() end

    if objects[state] then
        objects[state] = {}
    end
end
