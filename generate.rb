require_relative 'lib/point_3d'
require_relative 'lib/platonic'
require_relative 'lib/sticker'
require_relative 'lib/puzzle'
require_relative 'lib/piece'
require_relative 'lib/input_parser'



# parsing input

input = InputParser.new

(shape, turning_axes, piece_only) = input.parse ARGV

# create puzzle, generate PermList: an array describing which piece/sticker goes where. It is required in GAP to construct a group

puzzle = Puzzle.new(shape, turning_axes)

reorient_permlists = []
pieces_permlists = []
stickers_permlists = []


puzzle.platonic_solid.axes.length.times do |axis|

  reorient_permlists << "PermList(["+puzzle.reorient_piece_plus_one(axis) * ","+"])"

  pieces_permlists << "PermList(["+puzzle.transform_piece_plus_one(axis) * ","+"])"

  if !piece_only
    stickers_permlists << "PermList(["+puzzle.transform_sticker_plus_one(axis) * ","+"])"
  end

end

# composing commands for GAP

command = ""

command << 'Print("Complex '+turning_axes+'-turning '+shape+':\n");'
command << "\n"

command << "reorient := Group([" + reorient_permlists * "," +"]);\ntypes:=Orbits(reorient,[1.."+ puzzle.number_visible_pieces.to_s + "]);\n"
command << 'Print("There are ",Length(types), " types of pieces: \n",types,"\n");'
command << "\n"


command << "pieces := Group([" + pieces_permlists * "," +"]);\n"
command << 'Print("Group of permutation of pieces constructed.\nCalculating the size of this group.\n");'
command << "\n"
command << "size_pieces:=Size(pieces);\n"
command << 'Print("Number of permutations of pieces (ignoring orientation): \n",size_pieces,"\n");'
command << "\n"
# print orbits of pieces
command << 'Print("Orbits of pieces: \n",Orbits(pieces,[1..'+ puzzle.number_visible_pieces.to_s + ']),"\n");'
command << "\n"

if !piece_only
  command << "stickers := Group([" + stickers_permlists * "," +"]);\n"
  command << 'Print("Group of permutation of stickers constructed.\nCalculating the size of this group.\n");'
  command << "\n"
  command << "size_stickers:=Size(stickers);\n"
  command << 'Print("Number of permutations of stickers (considering orientation): \n",size_stickers,"\n");'
  command << "\n"
  # print orbits of stickers
  command << 'Print("Orbits of stickers: \n",Orbits(stickers,[1..'+ puzzle.number_visible_stickers.to_s + ']),"\n");'
  command << "\n"
end

# write to file

filename = "complex.g"

f = File.new(filename, "w")
f.write(command)
f.close()

puts "Please run #{filename} in GAP"