local Runtime = require 'brick-script.brickscript.runtime'

local function read(file) -- TODO should this be here or in client code? At lease allow to pass an ink content in a string
  print("loading", file)
  if love and love.filesystem and love.filesystem.read then
    local content, size = love.filesystem.read(file)
    return content
  else
    local f = io.open(file, "rb")
    if not f then error('failed to open "'..file..'"') end
    local content = f:read("*all")
    f:close()
    return content
  end
end

local load = function (filename)
    local parsed
    if not pcall(function ()
      local req = string.sub(filename, 1, -7) -- without '.brick'
      print('loading precompiled', req)
      parsed = require(req)
    end) then
      print('compiling', filename)
      -- require parser only if previous fails
      local parser  = require 'brick-script.brickscript.parser'
      parsed = parser:match(read(filename))
    end
    return parsed
  end

return {
 load = function(filename, bindings) -- without '.brick'
  local app = load('brick-app/'..filename..'.brick')
  local runtime = Runtime()
  if bindings then for name, value in pairs(bindings) do runtime.assign(name, value) end end
  local appMainLoop = runtime.run(app)
  return appMainLoop
 end
}
