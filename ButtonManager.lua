--[[
    ButtonManager.lua
    Manages the different buttons in the application

    Authors:
        Dan Wager
--]]

ButtonManager = {}

ButtonManager.PLAY = 1
ButtonManager.QUIT = 2
ButtonManager.CONTROLS = 3
ButtonManager.BACK = 4
ButtonManager.NEXT = 5
ButtonManager.ARROW_R = 6
ButtonManager.ARROW_L = 7

-- Table of buttons with values
local buttons =
{
    [ButtonManager.PLAY] =
    {
        imageNormal = "btn_play_n",
        imageHover = "btn_play_h",
        imagePressed = "btn_play_p"
    },

    [ButtonManager.QUIT] =
    {
        imageNormal = "btn_quit_n",
        imageHover = "btn_quit_h",
        imagePressed = "btn_quit_p"
    }
}

-- Gets a copy of the button's value table
-- @param btn The button
-- @return The table of values for the specified button (table)
local function get(btn)
    if buttons[btn] then
        return shallowCopy(buttons[btn])
    else
        print("No button \'" .. btn .. "\'")
        return nil
    end
end

-- Gets a table containing the initialization data for the specified button
-- @param btn The button
-- @return The table of init data for the specified button (table)
function ButtonManager.getData(btn)
    return get(btn)
end

-- Creates a new button entity
-- @param btn The button
-- @param x The x coord
-- @param y The y coord
-- @param scale The scale of the button
-- @param onPressed The pressed callback
-- @return The button entity
function ButtonManager.create(btn, x, y, scale, onPressed)
    if buttons[btn] then
        local btnData = get(btn)

        btnData.x = x
        btnData.y = y
        btnData.scale = scale
        btnData.onPressed = onPressed

        return EntityManager.create("button", false, btnData)
    else
        print("No button \'" .. btn .. "\'")
        return nil
    end
end

-- "Presses" the button that is 'hovered' in the current state
function ButtonManager.press()
    for _,btn in ipairs(EntityManager.getAll("button")) do
        if btn.hover then
            btn:onPressed()
            return
        end
    end
end
