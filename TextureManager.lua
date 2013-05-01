TextureManager = {}

local textures = {}
local path = "textures/"
local prefix = "tex_"

local function loadAll()
    if love.filesystem.exists(path) then
        local files = love.filesystem.enumerate(path)

        print("Loading textures...")

        for _,file in pairs(files) do

            if string.starts(file, prefix) then
                local name = file:gsub(prefix, ""):gsub(".png", "")
                textures[name] = love.graphics.newImage(path .. file)
                print("  " .. name)
            end
        end
    end
end

function TextureManager.startup()
    loadAll()
end

function TextureManager.get(name)
    if textures[name] then
        return textures[name]
    else
        print("\'" .. name .. "\' is not a valid texture")
        return false
    end
end