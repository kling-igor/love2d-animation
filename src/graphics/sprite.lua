GRAPHICS_PATH = GRAPHICS_PATH or ({...})[1]:gsub("[%.\\/][Ff]rame[Cc]ache", "") .. '.'

local TextureCache = require(GRAPHICS_PATH .. 'texturecache')

local Sprite = {}
Sprite.__index = Sprite

function Sprite.fromFrame(frame)
	local sprite = {
		frame = frame,
		width = frame.width,
		height = frame.height,
		anchor_x = 0,
		anchor_y = 0,
		scale_x = 1,
		scale_y = 1,
		angle = 0,
		x = 0,
		y = 0,
		draw = function(self, x_offset, y_offset)
			local x_draw_offset = x_offset or 0
			local y_draw_offset = y_offset or 0
			
			love.graphics.push()
			love.graphics.translate(self.x + x_draw_offset, self.y + y_draw_offset)
		
			love.graphics.rotate(math.rad(self.angle))
			
			local frame = self.frame

			love.graphics.draw(frame.image, frame.quad,
						(frame.crop_x - frame.width * self.anchor_x) * self.scale_x,
						(frame.crop_y - frame.height * self.anchor_y) * self.scale_y,
						0, self.scale_x, self.scale_y) 		
					
			love.graphics.pop()		
		end
					
	}
	return setmetatable(sprite, Sprite)
end

function Sprite.fromQuad(image, quad, width, height, crop_x, crop_y)
	local _image
	if type(image) == 'string' then
		_image = TextureCache[image]
	elseif type(image) == 'userdata' then
		_image = image	
	end 

	local sprite = {
		image = _image,
		quad = quad,
		width = width,
		height = height,
		crop_x = crop_x or 0,
		crop_y = crop_y or 0,
		anchor_x = 0,
		anchor_y = 0,
		scale_x = 1,
		scale_y = 1,
		angle = 0,
		x = 0,
		y = 0,
		_draw = function(self)
						love.graphics.draw(self.image, self.quad,
						(self.crop_x - self.width * self.anchor_x) * self.scale_x,
						(self.crop_y - self.height * self.anchor_y) * self.scale_y,
						0, self.scale_x, self.scale_y) 
					end 
	}
	return setmetatable(sprite, Sprite)
end
	
function Sprite.fromImage(image, width, height, crop_x, crop_y)
	local _image
	if type(image) == 'string' then
		_image = TextureCache[image]
	elseif type(image) == 'userdata' then
		_image = image	
	end 

	local sprite = {
		image = _image,
		width = width or image:getWidth(),
		height = height or image:getHeight(),
		crop_x = crop_x or 0,
		crop_y = crop_y or 0,
		anchor_x = 0,
		anchor_y = 0,
		scale_x = 1,
		scale_y = 1,
		angle = 0,
		x = 0,
		y = 0,
		_draw = function(self)
				love.graphics.draw(self.image,
				(self.crop_x - self.width * self.anchor_x) * self.scale_x,
				(self.crop_y - self.height * self.anchor_y) * self.scale_y,
				0, self.scale_x, self.scale_y) 
			end 
	}
	return setmetatable(sprite, Sprite)
end

function Sprite:draw(x_offset, y_offset)
	local x_draw_offset = x_offset or 0
	local y_draw_offset = y_offset or 0
	
	love.graphics.push()
	love.graphics.translate(self.x + x_draw_offset, self.y + y_draw_offset)
	
	love.graphics.rotate(math.rad(self.angle))

	self:_draw()

	love.graphics.pop()
end

return Sprite
