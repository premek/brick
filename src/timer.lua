return {
interval = function (machineTick, callback)
  local time=0
  return function (dt)
    time=time+dt
    if time >= machineTick then
      callback()
      time = time - machineTick
      if time > machineTick*10 then
        print('Frame drop', time)
        time = 0
      end
    end
  end
end
}
