return {
drawBitmap = function (display, map, pos)
  for cy, line in ipairs(map) do
    for cx, val in ipairs(line) do
      if val>0 then display.on(cx-1+pos[1], cy-1+pos[2]) end
    end
  end
end

}
