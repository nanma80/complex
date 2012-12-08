require_relative 'lib\point_3d'
require_relative 'lib\platonic'
require_relative 'lib\sticker'
require_relative 'lib\puzzle'
require_relative 'lib\piece'

# parsing input

shape = ""
axes = ""
piece_only = false

until ARGV.empty? do
  arg = ARGV.shift
    if ['tetrahedron', 'tetrahedra', 'tetra'].include? arg
      shape = 'tetrahedron'
    elsif ['cube','cubes','hexahedron','hexahedra'].include? arg
      shape = 'cube'
    elsif ['octahedron', 'octahedra','octa','oct'].include? arg
      shape = 'octahedron'
    elsif ['dodecahedron', 'dodecahedra','dodeca','dodec'].include? arg
      shape = 'dodecahedron'
    elsif ['icosahedron', 'icosahedra','icosa','icos'].include? arg
      shape = 'icosahedron'
    elsif ['face','face-turning'].include? arg
      axes = 'face'
    elsif ['vertex','vertex-turning','corner','corner-turning','vertices','corners'].include? arg
      axes = 'vertex'
    elsif ['edge','edge-turning','edges'].include? arg
      axes = 'edge'
    elsif ['turning'].include? arg
      # ignore
    elsif ['piece-only','piece','only','pieces'].include? arg
      piece_only = true
    else
      raise "I don't understand the meaning of #{arg}"
    end
end

puts 'Analyzing the complex '+axes+'-turning '+shape

# create puzzle

puzzle = Puzzle.new(shape, axes)

if false
  axis = 0
  puts puzzle.transform_sticker(axis)
  exit
end

pieces_permlists = []

stickers_permlists = []


puzzle.platonic_solid.axes.length.times do |axis|

  pieces_permlists << "PermList(["+puzzle.transform_piece_plus_one(axis) * ","+"])"
  if !piece_only
    stickers_permlists << "PermList(["+puzzle.transform_sticker_plus_one(axis) * ","+"])"
  end

end

# composing commands for GAP

command = ""

command << 'Print("Complex '+axes+'-turning '+shape+':\n");'
command << "\n"

command << "pieces := Group([" + pieces_permlists * "," +"]);\nsize_pieces:=Size(pieces);\n"
command << 'Print("Number of permutations of pieces (ignoring orientation): \n",size_pieces,"\n");'
command << "\n"
command << 'Print("Orbits of pieces: \n",Orbits(pieces,[1..'+ puzzle.number_visible_pieces.to_s + ']),"\n");'
command << "\n"

if !piece_only
  command << "stickers := Group([" + stickers_permlists * "," +"]);\nsize_stickers:=Size(stickers);\n"

  command << 'Print("Number of permutations of stickers (considering orientation): \n",size_stickers,"\n");'
  command << "\n"
  command << 'Print("Orbits of stickers: \n",Orbits(stickers,[1..'+ puzzle.number_visible_stickers.to_s + ']),"\n");'
  command << "\n"
end

# write to file

filename = "complex.g"

f = File.new(filename, "w")
f.write(command)
f.close()

puts "Please run #{filename} in GAP"