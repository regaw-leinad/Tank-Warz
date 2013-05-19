--[[
    StateManager.lua
    Manages the different states in the application

    Authors:
        Dan Wager
--]]

StateManager = {}

-- The table of states that are registered
local states = {}
-- The path to the states directory
local path
-- The current state of the application
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
-- @param statePath The states directory (relative)
function StateManager.startup(statePath)
    path = statePath or "states/"
    local folders = love.filesystem.enumerate(path)

    print("Loading states...")

    for _,state in ipairs(folders) do
        if love.filesystem.isDirectory(path .. state) and love.filesystem.exists(path .. state .. "/main.lua") then
            states[state] = {}
            states[state].loaded = false
            states[state].path = path .. state
            states[state].name = state
            states[state].data = love.filesystem.load(path .. state .. "/main.lua")
            print("  " .. state)
        end
    end
end

-- Loads a state from the file system
-- @param state The state name
-- @param args A table of arguments to pass to the state
function StateManager.load(state, args)
    if states[state] then
        clearLove()
        currentState = state
        states[state].loaded = true
        states[state].data()
        load(args)
    else
        print("Error loading state \'".. state .. "\'")
    end
end

-- Resumes a previously running state
-- @param The state name
function StateManager.resume(state)
    if states[state] then
        clearLove()
        currentState = state
        states[state].data()
    else
        print("Error loading state \'".. state .. "\'")
    end
end

-- Destroys (resets) a state
-- @param state The state name
function StateManager.destroy(state)
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
    end
end

-- Gets a value indicating if the specified state has been loaded, and not yet destroyed
-- @param state The state name
-- @return If the specified state is loaded (boolean)
function StateManager.isLoaded(state)
    if states[state] then
        return states[state].loaded
    else
        print("No state \'" .. state .. "\'")
        return false
    end
end

-- Gets a table of the registered states
-- @return The registered states (table)
function StateManager.getStates()
    return states
end

-- Gets a value indicating the current state
-- @return The current state (string)
function StateManager.getCurrentState()
    return currentState
end
