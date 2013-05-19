--[[
    AudioManager.lua
    Manages audio files used by the application

    Authors:
        Dan Wager
--]]

AudioManager = {}

-- The table of audio files that are loaded
local audio = {}
-- The path to the audio directory
local path
-- The filename prefix all audio files need to have to be registered
local prefix = "aud_"

-- Loads and registers all valid audio files from the texture directory
local function loadAll()
    if love.filesystem.exists(path) then
        local files = love.filesystem.enumerate(path)

        print("Loading audio...")

        for _,file in ipairs(files) do

            if string.starts(file, prefix) then
                local name = file:gsub(prefix, ""):gsub(".ogg", "")
                audio[name] = {}
                audio[name].data = love.sound.newSoundData(path .. file)
                audio[name].path = path .. file
                print("  " .. name)
            end
        end
    end
end

-- Starts up the AudioManager
-- @param audPath The audio files' directory (relative)
function AudioManager.startup(audPath)
    path = texPath or "audio/"
    loadAll()
end

-- Plays a sound
-- @param name The sound's name
function AudioManager.play(name)
    if audio[name] then
        love.audio.newSource(audio[name].data):play()
    else
        print("\'" .. name .. "\' is not a valid audio file")
    end
end

-- Pauses all audio
function AudioManager.pauseAll()
    love.audio.pause()
end

-- Resumes all paused audio
function AudioManager.resumeAll()
    love.audio.resume()
end

-- Stops all playing audio
function AudioManager.stopAll()
    love.audio.stop()
end
