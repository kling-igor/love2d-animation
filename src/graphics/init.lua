GRAPHICS_PATH = GRAPHICS_PATH or ({...})[1]:gsub("[%.\\/]init$", "") .. '.'
-- Return the classes in a table
return {
	TextureCache = require(GRAPHICS_PATH  .. "texturecache"),
	Frame = require(GRAPHICS_PATH  .. "frame"),
	FrameCache = require(GRAPHICS_PATH  .. "framecache"),
	Animation = require(GRAPHICS_PATH  .. "animation"),
	Sprite = require(GRAPHICS_PATH  .. "sprite")
}

