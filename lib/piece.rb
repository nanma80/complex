class Piece
  attr_reader :axes_length, :id, :turnability, :id_string, :order
  attr_accessor :visibility, :visible_id

  def initialize(id, visible_id, platonic_solid, visibility = true)
    @id = id
    @platonic_solid = platonic_solid
    @axes_length = @platonic_solid.axes.length
    @visibility = visibility # binary variable to indicate whether a piece is actually visible or not at the end
    generate_turnability
    @visible_id = visible_id
  end

  def generate_turnability
    @id_string = (@id + 2**@axes_length).to_s(2)[1..-1]
    @turnability = Array.new(@axes_length) do |index|
      @id_string[index] == "1"
    end

    @order=0
    @id_string.length.times do |index|
      if @id_string[index]=="1"
        @order += 1
      end
    end
  end

  def determine_visibility

    cube_types = [ [ 1 ], # 0, core
    [ 2, 17, 5, 3, 33, 9 ], # 1, face
    [ 4, 18, 7, 34, 11, 35, 6, 25, 21, 49, 13, 41 ], # 2, edge
    [ 8, 22, 15, 36, 29, 50, 43, 57 ], # 3, corner
    [ 10, 19, 37 ], # 4, UD
    [ 12, 20, 39, 42, 27, 14, 26, 23, 38, 51, 45, 53 ], # 5 UDF
    [ 16, 24, 47, 44, 31, 40, 30, 52, 54, 59, 61, 58 ], # 6 inverted edge
    [ 28, 55, 46 ], # 7 FBLR
    [ 32, 63, 48, 56, 62, 60 ], # 8 inverted face
    [ 64 ] ] # 9, inverted core

    # white list
    white_list = []

    # white_list |= cube_types[1]
    # white_list |= cube_types[2]
    # white_list |= cube_types[3]

    # black list
    black_list = []

    # black_list |= cube_types[0]
    # black_list |= cube_types[4]
    # black_list |= cube_types[7]
    # black_list |= cube_types[9]


    if !(white_list.empty?)
      @visibility = (white_list.include? (@id+1))
    else # white list is empty, look at black list
      @visibility = !(black_list.include? (@id+1))
    end

    
  end

  def transform(axis)
    # return id of destination piece
    new_id_string = @id_string[0..-1]

    if !@turnability[axis]
      return @id
    end

    @axes_length.times do |from_index|
      to_index = @platonic_solid.table[from_index][axis]
      new_id_string[to_index] = @id_string[from_index]
    end
    
    return new_id_string.to_i(2)
  end

  def reorient(axis)
    # just like transform, but it's for global reorientation
    # return id of destination piece
    new_id_string = @id_string[0..-1]

    @axes_length.times do |from_index|
      to_index = @platonic_solid.table[from_index][axis]
      new_id_string[to_index] = @id_string[from_index]
    end
    
    return new_id_string.to_i(2)
  end

end