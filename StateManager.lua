StateManager = {}

local states = {}
local path = "states/"
local currentState = nil

-- Sets all love callbacks to nil
local function clearLove()
    -- Not sure if we should nil this one out... lol
    --love.load = nil
    love.draw = nil
    love.update = nil
    love.focus = nil
    love.run = nil
    love.quit = nil
    love.mousepressed = nil
    love.mousereleased = nil
    love.joystickpressed = nil
    love.joystickreleased = nil
    love.keypressed = nil
    love.keyreleased = nil
end

-- Loads the states from the file system
function StateManager.startup()
    local folders = love.filesystem.enumerate(path)

    for _,state in pairs(folders) do
        if love.filesystem.isDirectory(path .. state) and love.filesystem.exists(path .. state .. "/main.lua") then
            states[state] = {}
            states[state].loaded = false
            states[state].path = path .. state
            states[state].name = state
            states[state].data = love.filesystem.load(path .. state .. "/main.lua")
            print("Registered state \'" .. state .. "\'")
        end
    end
end

-- Loads a state from the file system
-- Possibly destroy state before? Or let client do this first?
function StateManager.loadState(state)
    if states[state] then
        clearLove()
        currentState = state
        states[state].loaded = true
        states[state].data()
        load()
    else
        print("Error loading state \'".. state .. "\'")
    end
end

-- Loads a state from the file system
function StateManager.resumeState(state)
    if states[state] then
        clearLove()
        currentState = state
        states[state].data()
    else
        print("Error loading state \'".. state .. "\'")
        return false
    end
end

-- Loads a state from the file system
function StateManager.destroyState(state)
    if states[state] and states[state].loaded then
        if state == currentState then
            clearLove()
            currentState = nil
            love.graphics.setBackgroundColor(0, 0, 0)
        end

        states[state].loaded = false
        EntityManager.destroyStateEntities(state)
    else
        print("Error destroying state \'".. state .. "\'")
        return false
    end
end

function StateManager.isLoaded(state)
    if states[state] then
        return states[state].loaded
    else
        print("No state \'" .. state .. "\'")
        return false
    end
end

function StateManager.getStates()
    return states
end

function StateManager.getCurrentState()
    return currentState
end
