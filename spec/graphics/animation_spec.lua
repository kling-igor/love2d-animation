--local inspect = require 'inspect'

require 'spec.love-mocks'

Graphics = require 'graphics'


local TextureCache = Graphics.TextureCache
local FrameCache = Graphics.FrameCache
local Animation = Graphics.Animation
local Sprite = Graphics.Sprite
local Frame = Graphics.Frame

describe("Animation", function()
	describe("new", function()
		it("sets the initial defaults", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			
			assert.equal(0, a.x)
			assert.equal(0, a.y)
			assert.equal(0, a.anchor_x)
			assert.equal(0, a.anchor_y)
			assert.equal(1, a.scale_x)
			assert.equal(1, a.scale_y)
			assert.equal(0, a.angle)

			assert.equal(1, a.current_frame)

			assert.equal(0.08, a.frame_delay)
			assert.equal(0.0, a.current_time)
			
			assert.False(a.is_playing)
		
			--assert.equal(0, #a.frames)
			
			assert.same({{'frame_1'}, {'frame_2'}}, a.frames)
		end)
	end)

	describe("setFrames:", function()
		it("substitutes existing frames", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			
			a:setFrames({{'frame_3'}, {'frame_4'}})
			
			assert.same({{'frame_3'}, {'frame_4'}}, a.frames)
		end)

		it("throws error on playing animation if no frames set", function()
			local a = Animation()
			
			assert.error(function() a:play() end)
		end)
	end)

	describe("update:", function()
		it("moves to next frame", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			assert.equal(1, a.current_frame)
			
			a:play(0.1)
			a:update(0.1)
			
			assert.equal(2, a.current_frame)
		end)

		it("skips frames if needed", function()
			local a = Animation({{'frame_1'}, {'frame_2'},  {'frame_3'}})
			
			a:play(0.1)
			a:update(0.2)
			
			assert.equal(3, a.current_frame)
		end)
	
		it("rewinds animation to the begining", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			a:play(0.1)
			
			a:update(0.2)
			
			assert.equal(1, a.current_frame)
		end)

	end)

	describe("draw:", function()
			
		it("invokes love.graphics.translate with specified parameters", function()
			spy.on(love.graphics, 'translate')
			
			local a = Animation({Frame({}, {}, 100, 200)})
			a.x = 30
			a.y = 40
			
			a:draw()
			
			assert.spy(love.graphics.translate).was.called_with(30, 40)
		end)
	
		it("invokes love.graphics.rotate with specified parameter", function()
			spy.on(love.graphics, 'rotate')
			
			local angle = 45
			local a = Animation({Frame({}, {}, 100, 200)})
			a.angle = angle
			
			a:draw()
			
			assert.spy(love.graphics.rotate).was.called_with(math.rad(angle))
		end)
			
		it("invokes love.graphics.draw with specified parameters", function()
			spy.on(love.graphics, 'draw')
			
			local img = {}
			local quad = {}
			local frame = Frame(img, quad, 100, 50)
			local a = Animation({frame})
			
			a:draw()
			
			assert.spy(love.graphics.draw).was.called_with(img, quad, 0, 0, 0, 1, 1)
		end)
	end)

	describe("play:", function()
		it("makes the animation to play", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			
			a:play()
			
			assert.True(a.is_playing)
		end)

		it("doesn't matter for current frame counter if animation already is playing", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			a:play(0.1)
			a:update(0.1)
			
			a:play()
			
			assert.equal(2, a.current_frame)
		end)
	
		it("plays exactly specified loops", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			
			a:play(0.1, 2)
			a:update(0.2) -- 1-st loop
			
			assert.True(a.is_playing)
						
			a:update(0.2) -- 2-nd loop
			
			assert.False(a.is_playing)
		end)

	end)

	describe("stop:", function()
		it("makes the playing animation to stop", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			a:play(0.1)
			
			a:stop()
			
			assert.False(a.is_playing)
		end)

		it("doesn't matter if animation already stopped", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			a:play(0.1)
			a:stop()
			
			a:stop()
			
			assert.False(a.is_playing)
		end)
	end)

	describe("seek:", function()
		it("can seek only when not playing", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			
			assert.has_no.errors(function() a:seek(2) end)
		end)

		it("rewinds to specified frame", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			
			a:seek(2)
			
			assert.equal(2, a.current_frame)
		end)

		it("doesn't matter for current frame if animation is playing", function()
			local a = Animation({{'frame_1'}, {'frame_2'}, {'frame_2'}})
			a:play(0.1)
			a:update(0.1)
			
			a:seek(3)
			
			assert.equal(2, a.current_frame)
		end)

		it("throws error then erroneous frame specified", function()
			local a = Animation({{'frame_1'}, {'frame_2'}})
			
			assert.errors(function() a:seek(3) end)
			
			assert.errors(function() a:seek(0) end)
			
			assert.errors(function() a:seek(-1) end)
		end)

		it("rewinds current frame if new frames numbers differs from the previous one", function()
			local a = Animation({{'frame_1'}, {'frame_2'}, {'frame_3'}, {'frame_4'}})
			a:seek(4)
			
			a:setFrames({{'frame_5'}, {'frame_6'}})
			
			assert.equal(1, a.current_frame)
		end)
	end)
end)