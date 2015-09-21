local TextureCache = {}

local textures = {}
--setmetatable(textures, {__mode = "v"})

TextureCache.__index = function(t, name)
	local texture = textures[name]
	
	if texture == nil then 
		texture = love.graphics.newImage(name)
		textures[name] = texture
	end
	
	return texture
end

TextureCache.__newindex = function(t, name, value)
	local texture = textures[name]
	
	if texture == nil then 
		textures[name] = value
	end
end

setmetatable(TextureCache, TextureCache)

return TextureCache
