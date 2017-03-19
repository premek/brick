math.randomseed(os.time())

local love = love
local draw = require 'draw'
local input = require 'input'
local machine = require 'machine.machine'
local timer = require 'timer'
local os = require 'app.sys.os'

function love.load()
end

function love.draw()
  draw(machine)
end

local int = timer.interval(1/25, function ()
    if os.paused or machine.gameover then return end
    input.update(machine)
    os.app(machine)
  end)

function love.update(dt)
  int(dt)
end

function love.keypressed(key)
  input.keypressed(key, os)
end
