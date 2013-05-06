EntityManager = {}

local objects = {}
local register = {}
local path = "entities/"
local prefix = "ent_"
local id = 0

-- Loads the entities from all the states' entities folder
function EntityManager.startup()
    local files = love.filesystem.enumerate(path)

    print("Loading entities...")

    for _,file in pairs(files) do
        if string.starts(file, prefix) then
            local name = file:gsub(prefix, ""):gsub(".lua", "")
            register[name] = love.filesystem.load(path .. file)
            print("  " .. name)
        end
    end
end

function EntityManager.derive(name)
    if register[name] then
        return register[name]()
    else
        print("Entitiy \'" .. name .. "\' not registered")
        return false
    end
end

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
        return false
    end
end

function EntityManager.get(id)
    local state = StateManager.getCurrentState()

    if objects[state][id] then
        return objects[state][id]
    else
        print("No entity with id " .. id)
        return false
    end
end

function EntityManager.update(dt)
    local state = StateManager.getCurrentState()

    for _,ent in pairs(objects[state]) do
        if ent.update then
            ent:update(dt)
        end
    end
end

function EntityManager.draw()
    local state = StateManager.getCurrentState()

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

function EntityManager.destroy(id)
    local state = StateManager.getCurrentState()

    if objects[state][id] then
        print("Destroying entity id " .. id)

        if objects[state][id].die then
            objects[state][id]:die()
        end

        objects[state][id] = nil
    end
end

function EntityManager.destroyStateEntities(state)
    if not state then state = StateManager.getCurrentState() end

    if objects[state] then
        objects[state] = {}
    end
end
