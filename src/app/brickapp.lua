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
    if not pcall(function ()
      local req = string.sub(filename, 1, -7) -- without '.brick'
      print('loading precompiled', req)
      return require (req)
    end) then
      print('compiling', filename)
      -- require parser only if previous fails
      local parser  = require 'brick-script.brickscript.parser'
      return parser:match(read(filename))
    end
  end

return {
 load = function(gameNumber)
  local app = load('brick-app/'..gameNumber..'.brick')
  local runtime = Runtime()
  runtime.assign('print', print)

  local appMainLoop = runtime.run(app)
  return appMainLoop
 end
}
