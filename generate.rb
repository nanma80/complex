require_relative 'point_3d'
require_relative 'platonic'
require_relative 'sticker'
require_relative 'puzzle'
require_relative 'piece'

puzzle = Puzzle.new('cube', 'face')

if false
  axis = 0
  puts puzzle.transform_sticker(axis)
  exit
end

permlists = []

puzzle.platonic_solid.axes.length.times do |axis|

  # permlists << "PermList(["+puzzle.transform_piece_plus_one(axis) * ","+"])"
  permlists << "PermList(["+puzzle.transform_sticker_plus_one(axis) * ","+"])"


end

command = "complex := Group([" + permlists * "," +"]);\ns:=Size(complex);\nPrint(s);"

f = File.new("complex.g", "w")
f.write(command)
f.close()

