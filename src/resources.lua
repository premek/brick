local res = {
  palette = {
    on = {0,0,0},
    off = {171,184,171},
    bg = {181,194,181}
  },

  font = {
    sans = love.graphics.setNewFont('font/digital-graphics-labs_protestant/protest.ttf', 15),
    lcd = love.graphics.setNewFont( 'font/cedders_segment7/Segment7Standard.otf', 32)
  },

  music = {
    --love.audio.newSource('assets/music/03 - Solxis - Rainforest.mp3', 'stream' )
  },
  sfx = {
    --walk = {"106115__j1987__forestwalk.wav", loop=1},
    --land_ch = {"235521__ceberation__landing-on-ground.wav"},
    --land_b = {"136887__animationisaac__box-of-stuff-falls.wav", vol=.2},
  }
}

--res.music[1]:setLooping( true )
--res.music[1]:setVolume(.7)
--res.music[1]:play()

for k, v in pairs(res.sfx) do
  print("Loading sfx", k, v[1])
  v.src = love.audio.newSource( 'assets/sfx/'..v[1], 'static' )
  if v.vol then v.src:setVolume(v.vol) end
  if v.loop then v.src:setLooping(true) end
end

return res
