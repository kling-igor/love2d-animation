local Frame = {}
Frame.__index = Frame
setmetatable(Frame,Frame)
	
function Frame.__call(_,image, quad, width, height, crop_x, crop_y)
	local frame = {
		image = image,
		quad = quad,
		width = width,
		height = height,
		crop_x = crop_x or 0,
		crop_y = crop_y or 0,
	}
	return setmetatable(frame, {__index = Frame})
end	

function Frame.__index(_,key)
	return nil
end

function Frame:draw(x, y, angle, anchor_x, anchor_y, scale_x, scale_y)
	local _angle = angle or 0
	local _anchor_x = anchor_x or 0
	local _anchor_y = anchor_y or 0
	local _scale_x = scale_x or 1
	local _scale_y = scale_y or 1
	
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(math.rad(_angle))

	love.graphics.draw(self.image, self.quad,
						(self.crop_x - self.width * _anchor_x) * _scale_x,
						(self.crop_y - self.height * _anchor_y) * _scale_y,
						0, scale_x, scale_y) 
	love.graphics.pop()
end

return Frame