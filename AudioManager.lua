--[[
    AudioManager.lua
    Manages audio files used by the application

    Authors:
        Dan Wager
--]]

AudioManager = {}

-- The currently playing audio
local playing = {}

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
                local name = file:gsub(prefix, ""):gsub(".ogg", ""):gsub(".mp3", "")
                audio[name] = {}
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
function AudioManager.play(name, vol, loop)
    if audio[name] then
        if not playing[name] then
            playing[name] = love.audio.newSource(audio[name].path)
        end

        playing[name]:setVolume(vol or 1)
        playing[name]:setLooping(loop or false)
        playing[name]:play()
    else
        print("\'" .. name .. "\' is not a valid audio file")
    end
end

function AudioManager.stop(name)
    if playing[name] then
        love.audio.stop(playing[name])
    else
        print("\'" .. name .. "\' is not a valid audio name")
    end
end

function AudioManager.setVolume(name, vol)
    if playing[name] then
        playing[name]:setVolume(vol or 1)
    else
        print("\'" .. name .. "\' is not a valid audio name")
    end
end

function AudioManager.setLooping(name, loop)
    if playing[name] then
        playing[name]:setLooping(loop or false)
    else
        print("\'" .. name .. "\' is not a valid audio name")
    end
end
