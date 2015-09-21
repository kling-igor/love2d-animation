-- mocks for LÖVE functions
local Quad_mt = {
  __eq = function(a,b)
    if #a ~= #b then return false end
    for i,v in ipairs(a) do
      if b[i] ~= v then return false end
    end
    return true
  end,
  __tostring = function(self)
    local buffer = {}
    for i,v in ipairs(self) do
      buffer[i] = tostring(v)
    end
    return "quad: {" .. table.concat(buffer, ",") .. "}"
  end,
  getViewport = function(self)
    return unpack(self)
  end
}

Quad_mt.__index = Quad_mt

local Image_mt = {
  __eq = function(a,b)
    if #a ~= #b then return false end
    for i,v in ipairs(a) do
      if b[i] ~= v then return false end
    end
    return true
  end,
  __tostring = function(self)
    local buffer = {}
    for i,v in ipairs(self) do
      buffer[i] = tostring(v)
    end
    return "image: {" .. table.concat(buffer, ",") .. "}"
  end
}

Image_mt.__index = Image_mt

_G.love = {
  graphics = {
    newQuad = function(...)
      return setmetatable({...}, Quad_mt)
    end,
    draw = function()
    end,
    getLastDrawq = function()
	end,
	push = function()
	end,
	pop = function()
	end,
	translate = function()
	end,
	rotate = function()
	end,
	newImage = function(...)
      return setmetatable({...}, Image_mt)
    end
  }
}
