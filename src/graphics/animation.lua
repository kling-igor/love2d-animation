local Animation = {}
Animation.__index = Animation

setmetatable(Animation, Animation)	
	
function Animation.__call(_,frames)
	local animation = {
		x = 0,
		y = 0,
		anchor_x = 0,
		anchor_y = 0,
		scale_x = 1,
		scale_y = 1,
		angle = 0,
		current_frame = 1,
		frames = frames or {},
		frame_delay = 0.08,
		current_time = 0.0,
		is_playing = false
	}

	return setmetatable(animation, {__index = Animation})
end

function Animation.__index(_,key)
	return nil
end
	
function Animation:setFrames(frames)
	assert(not self.is_playing, "unable to set frames while playing")
	
	self.frames = frames
	self.current_frame = 1
end

function Animation:draw(x_offset, y_offset)
	local x_draw_offset = x_offset or 0
	local y_draw_offset = y_offset or 0
	
	local frame = self.frames[self.current_frame]
	
	frame:draw(self.x + x_draw_offset, self.y + y_draw_offset, self.angle, self.anchor_x, self.anchor_y, self.scale_x, self.scale_y)
end

function Animation:play(frame_delay, loops)
	if self.frames == nil or type(self.frames) == 'table' and #self.frames == 0 then error('frames empty') end 
	
	if loops and loops < 1 then error('invalid loops number, should be > 0') end
	
	self.frame_delay = frame_delay or 0.08
	self.current_time = 0
	self.is_playing = true
	self.loops = loops and math.floor(loops)
end

function Animation:stop()
	self.is_playing = false
end

function Animation:seek(idx)
	if idx > #self.frames or idx < 1 then error('invalid frame') end
	if self.is_playing then return end
	
	self.current_frame = idx
end

function Animation:update(dt)

	if not self.is_playing then return end
	
	self.current_time = self.current_time + dt
	
	while self.current_time >= self.frame_delay do
		self.current_time = self.current_time - self.frame_delay
		self.current_frame = self.current_frame + 1
		
		if self.current_frame > #self.frames then
			if self.loops  then
				self.loops = self.loops - 1
				
				if self.loops >= 1 then
					self.current_frame = 1
				else
					self.current_frame = #self.frames
					self:stop()
				end
			else
				self.current_frame = 1
			end
		end
	end
end
---------------------------------------------------------------------------------------------------

return Animation