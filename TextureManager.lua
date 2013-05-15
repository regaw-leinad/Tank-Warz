--[[
    TextureManager.lua
    Manages textures used by the application

    Authors:
        Dan Wager
--]]

TextureManager = {}

-- The table of textures that are loaded
local textures = {}
-- The path to the textures directory
local path
-- The filename prefix all textures need to have to be registered
local prefix = "tex_"

-- Applies texture to a canvas' image data
-- @param target The canvas to texturize
-- @param texture The texture to apply to the canvas
-- @return A new Image from the texturized canvas (Image)
local function texturize(target, texture)

    -- This defines how all the pixels are transformed
    -- this method is passed to (imageData):mapPixel
    local function pixelFunction(x, y, r, g, b, a)
        if r + g + b == 0 then -- black, no texture
            -- Don't need the 0's anymore,
            -- defaults to 0 if not passed
            return --0, 0, 0, 0
        else -- non-black, we apply the texture here
            -- Get the cooresponding pixel from the texture
            return texture:getPixel(x % texture:getWidth(), y % texture:getHeight())
        end
    end

    -- Get the image data from the canvas
    local id = target:getImageData()

    -- Apply the transform
    id:mapPixel(pixelFunction)

    -- return the image from the imageData
    return love.graphics.newImage(id)
end

-- Loads and registers all valid textures from the texture directory
local function loadAll()
    if love.filesystem.exists(path) then
        local files = love.filesystem.enumerate(path)

        print("Loading textures...")

        for _,file in ipairs(files) do

            if string.starts(file, prefix) then
                local name = file:gsub(prefix, ""):gsub(".png", "")
                textures[name] = {}
                textures[name].imageData = love.image.newImageData(path .. file)
                textures[name].path = path .. file
                print("  " .. name)
            end
        end
    end
end

-- Starts up the TextureManager
-- @param texPath The texture directory (relative)
function TextureManager.startup(texPath)
    path = texPath or "textures/"
    loadAll()
end

-- Gets the Image from the specified texture
-- @param name The texture name
-- @return The Image of the specified texture (Image)
function TextureManager.getImage(name)
    if textures[name] then
        return love.graphics.newImage(textures[name].imageData)
    else
        print("\'" .. name .. "\' is not a valid texture")
        return nil
    end
end

-- Gets the ImageData from the specified texture
-- @param name The texture name
-- @return The ImageData of the specifed texture (ImageData)
function TextureManager.getImageData(name)
    if textures[name] then
        return textures[name].imageData
    else
        print("\'" .. name .. "\' is not a valid texture")
        return nil
    end
end

-- Gets the texture's path in the file system
-- @param name The texture name
-- @return The texture's path
function TextureManager.getImagePath(name)
    if textures[name] then
        return textures[name].path
    else
        print("\'" .. name .. "\' is not a valid texture")
        return false
    end
end


-- Gets the Image width and height of the specifed texture
-- @param name The texture name
-- @return The width and height of the specified texture (int, int)
function TextureManager.getImageDimensions(name)
    if textures[name] then
        return textures[name].imageData:getWidth(), textures[name].imageData:getHeight()
    else
        print("\'" .. name .. "\' is not a valid texture")
        return nil
    end
end

-- Creates a textured image from a polygon and texture
-- @param poly The polygon coordinates
-- @param cutPoly The split polygon (for concave poly support)
-- @param texture The ImageData of the texture
-- @return The texturized polygon (Image)
function TextureManager.makeTexturedPoly(poly, cutPoly, texture)
    local minX, maxX, minY, maxY

    -- Set up the min and max x & y values of the polygon
    for n = 1, #poly , 2 do
        if not minX or minX > poly[n] then
            minX = poly[n]
        end
        if not maxX or maxX < poly[n] then
            maxX = poly[n]
        end
        if not minY or minY > poly[n + 1] then
            minY = poly[n + 1]
        end
        if not maxY or maxY < poly[n + 1] then
            maxY = poly[n + 1]
        end
    end

    -- Create the new canvas for drawing with the w and h of the poly
    local backCanvas = love.graphics.newCanvas(maxX - minX + 1, maxY - minY + 1)

    -- Apply that canvas for drawing
    love.graphics.setCanvas(backCanvas)

    -- Set drawing color to white
    love.graphics.setColor(255, 255, 255, 255)

    -- Translates from global canvas coords to local canvas coords
    love.graphics.translate(-minX, -minY)

    -- Draw the polygon (white)
    for _,triangle in ipairs(cutPoly) do
        love.graphics.polygon('fill', triangle)
    end

    -- Reset the offset for global
    love.graphics.translate(minX, minY)

    -- Reset to the main canvas for drawing
    love.graphics.setCanvas()

    -- Perform the texturization
    return texturize(backCanvas, texture)
end
