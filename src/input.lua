local love = love

return {

update = function (machine)
    -- buttons: left/level, down/mode, right/speed, rotate/direction, start/pause, on/off, mute
    machine.input.left = love.keyboard.isDown('left')
    machine.input.right = love.keyboard.isDown('right')
    machine.input.down = love.keyboard.isDown('down')
    machine.input.rotate = love.keyboard.isDown('space') or love.keyboard.isDown('up')
end,

keypressed = function(key, os)
  print(key)
  if key == 'escape' then os.reset()
  elseif key == 'p' then os.paused = not os.paused
  elseif key == 'm' then os.muted = not os.muted
  end
end

}
