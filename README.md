# Graphics

Graphics library for [LÖVE](http://love2d.org) - supplementary modules to represent
animations and sprites. It also provides texture and frame caching. Animations is based
on custom exporter format for [TexturePacker](https://www.codeandweb.com/texturepacker)

Copy `loveanimation_exporter` to somewhere end specify custom exporter directory in TexturePacker as described here:
[Specifying exporter directory](https://www.codeandweb.com/texturepacker/documentation#custom-exporter-preparations)

## Example

```lua
local Graphics = require 'graphics'

-- For shorten form if no one conflicts with with existing names:
local TextureCache = Graphics.TextureCache
local FrameCache = Graphics.FrameCache
local Animation = Graphics.Animation
local Sprite = Graphics.Sprite


local sprite, animation

function love.load()

	-- loading atlas
	local _ = TextureCache['sprites.png']

	-- populating frames cache (in assumption of sprites.lua exists)
	FrameCache.addAtlas 'sprites'	

	local frames = {FrameCache['frame_1'], {FrameCache['frame_2'], {FrameCache['frame_13],}
	animation = Animation.new(frames)
	animation.x, animation.y = 200, 200
	animation:play()

	sprite = Graphics.Sprite.fromImage(Graphics.TextureCache['picture.png'])
	sprite.x, sprite.y = 100, 100
	sprite.angle = 45 
end

function love.update(dt)
	animation:update(dt)
end

function love.draw()
	sprite:draw()
end

function love.keypressed(key, _)
 	if key == 's' then
 		animation:stop()
 	elseif key == 'p' then
 		animation:play()
 	elseif key == 'b' then
 		animation:stop()
 		animation:seek(1)
 		animation:play()
 	end
 end
```

## Installation

Just copy the `graphics` directory from `src` wherever you want it. Then require it wherever you need it:

    local Graphics = require 'graphics'

## Specs

This project uses [busted](http://olivinelabs.com/busted/) for its specs. If you want to run the specs, you will have to install it first. Then just execute the following from the root folder:

    busted
he root folder:

    busted