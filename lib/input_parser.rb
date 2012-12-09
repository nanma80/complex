class InputParser
  
  attr_reader :shape, :turning_axes, :piece_only

  def initialize
    @shape = ""
    @turning_axes = ""
    @piece_only = false
  end

  def parse argv
    # try to find words like cube, or tetrahedron, or face etc, to determine the parameters. 
    # For each keyword there are many expressions, for example, vertex, v, corner, c, vertex-turning, corner-turning, are all equivalent. 
    # Since "turning" is ignored, "vertex turning" is equivalent to "vertex", which is also accepted.
    until argv.empty? do
      arg = argv.shift
        if ['tetrahedron', 'tetrahedra', 'tetra'].include? arg
          @shape = 'tetrahedron'
        elsif ['cube','cubes','hexahedron','hexahedra'].include? arg
          @shape = 'cube'
        elsif ['octahedron', 'octahedra','octa','oct'].include? arg
          @shape = 'octahedron'
        elsif ['dodecahedron', 'dodecahedra','dodeca','dodec'].include? arg
          @shape = 'dodecahedron'
        elsif ['icosahedron', 'icosahedra','icosa','icos'].include? arg
          @shape = 'icosahedron'
        elsif ['face','face-turning','f'].include? arg
          @turning_axes = 'face'
        elsif ['vertex','vertex-turning','corner','corner-turning','vertices','corners','v','c'].include? arg
          @turning_axes = 'vertex'
        elsif ['edge','edge-turning','edges','e'].include? arg
          @turning_axes = 'edge'
        elsif ['turning'].include? arg
          # ignore
        elsif ['piece-only','piece','only','pieces'].include? arg
          @piece_only = true
        else
          raise "I don't understand the meaning of #{arg}"
        end
    end

    check_input

    puts 'Analyzing the complex '+ @turning_axes + '-turning ' + @shape

    return @shape, @turning_axes, @piece_only

  end

  def check_input
    # check if the necessary parameters are filled
    if @shape == "" or @turning_axes == ""
      puts "Invalid input."
      puts "Usage: ruby generate.rb shape turning-axes [piece-only]"
      puts " - shape may be tetrahedron, cube, octahedron, dodecahedron or icosahedron"
      puts " - turning_axes may be face, vertex, or edge"
      puts " - [piece-only] is an optional switch. If not given, the code will generate the permutation for both pieces and stickers. If given, it will only generate that for pieces."
      exit
    end
  end
  
end