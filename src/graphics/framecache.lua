GRAPHICS_PATH = GRAPHICS_PATH or ({...})[1]:gsub("[%.\\/][Ff]rame[Cc]ache", "") .. '.'

local TextureCache = require(GRAPHICS_PATH .. 'texturecache')

local Frame = require(GRAPHICS_PATH ..'frame')

local FrameCache = {}

-- frame cahce
local frames = {}

-- atlas cache
local atlases = {}

FrameCache.addAtlas = function(filename)
	local path, file, ext = string.match(filename, "(.-)([^\\/]-%.?([^%.\\/]*))$")
	
	local f = loadfile(filename..'.lua')
    assert(f, "unable to load file:"..filename)

    local atlasInfo = f()

	atlasInfo.atlas.filename = path .. atlasInfo.atlas.filename
	
	local _ = TextureCache[atlasInfo.atlas.filename]

	atlases[atlasInfo.atlas.filename] = atlasInfo
end

FrameCache.dumpFrames = function()
	for i,atlas in pairs(atlases) do
		for k,frame in pairs(atlas.frames) do
			print(k)
		end
	end
end

FrameCache.__index = function(t, name)
	
	local frame = frames[name]
	
	if frame then return frame	end
	
	for i,atlas in pairs(atlases) do
		for k,v in pairs(atlas.frames) do
			if k == name then
				local textureFilename = atlas.atlas.filename
				local image = TextureCache[textureFilename]
				local x, y, w, h = unpack(v.rect)
				local quad = love.graphics.newQuad(x, y, w, h, image:getWidth(), image:getHeight())
				
				if v.trimmed then
					local original_width, original_height = unpack(v.untrimmedSize) 
					local crop_x, crop_y = unpack(v.cornerOffset)
					
					frame = Frame(image, quad, original_width, original_height, crop_x, crop_y)
				else
					frame = Frame(image, quad, w, h)
				end
				
				frames[name] = frame
				
				return frame
			end
		end
	end

	assert(false, "frame '"..name.."' not found")
end

setmetatable(FrameCache, FrameCache)

return FrameCache