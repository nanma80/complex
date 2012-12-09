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

    cube_f_types = [ \
      [ 1 ], # 0, core
      [ 2, 17, 5, 3, 33, 9 ], # 1, face
      [ 4, 18, 7, 34, 11, 35, 6, 25, 21, 49, 13, 41 ], # 2, edge
      [ 8, 22, 15, 36, 29, 50, 43, 57 ], # 3, corner
      [ 10, 19, 37 ], # 4, UD
      [ 12, 20, 39, 42, 27, 14, 26, 23, 38, 51, 45, 53 ], # 5 UDF
      [ 16, 24, 47, 44, 31, 40, 30, 52, 54, 59, 61, 58 ], # 6 inverted edge
      [ 28, 55, 46 ], # 7 FBLR
      [ 32, 63, 48, 56, 62, 60 ], # 8 inverted face
      [ 64 ] \
    ] # 9, inverted core

    cube_v_types = [\
      [ 1 ], # 0, [] core
      [ 2, 9, 65, 33 ], # 1, [UFR], never move orbit 1/2
      [ 3, 17, 5, 129 ], # 2, [UFR], never move orbit 2/2
      [ 4, 18, 11, 81, 69, 161, 137, 35, 6, 13, 193, 49 ], # 3, [UFR,UFL] edges in Dino cube or FTO
      [ 7, 19, 131, 21, 133, 145 ], # 4, [UFR, ULB], "weird FTO corner", orbit 1/2
      [ 8, 20, 139, 85, 197, 163, 141, 51, 22, 15, 209, 177 ], # 5, [UFR,UFL,DFR], FTO triangles, orbit 1/2
      [ 10, 34, 41, 66, 73, 97 ], # 6, [UFR, ULB], "weird FTO corner", orbit 1/2
      [ 12, 50, 43, 82, 77, 169, 201, 36, 70, 14, 225, 113 ], # 7, [UFR,UFL,DFR], FTO triangles, orbit 2/2
      [ 16, 52, 171, 86, 205, 241 ], # 8, [UFR, UFL, UBR, UBL] FTO corners
      [ 23, 135, 149, 147 ], # 9, [UFL, UBR, DFR], circle Skewb corner around [UFR] but not moved by [UFR] itself, orbit 1/2
      [ 24, 143, 213, 179 ], # 10, [UFR, UFL, UBR, DFR], Skewb corner, orbit 1/2
      [ 25, 37, 130, 67 ], # 11, [UFR, DLB], opposite corners just like [UD] of complex 3x3x3,   ----- redundant
      [ 26, 38, 45, 194, 89, 57, 75, 162, 68, 138, 101, 99 ], # 12, [UFR, UFL, DBR], orbit 1/2
      [ 27, 53, 39, 146, 29, 153, 195, 132, 71, 134, 165, 83 ], # 13, [UFR, UFL, DBR], orbit 2/2
      [ 28, 54, 47, 210, 93, 185, 203, 164, 72, 142, 229, 115 ], # 14, [UBR, UFR, UFL, DFL], zigzag, orbit 1/2
      [ 30, 40, 173, 198, 217, 59, 79, 178, 84, 140, 117, 227 ], # 15, [UBR, UFR, UFL, DFL], zigzag, orbit 2/2
      [ 31, 55, 167, 150, 157, 155, 199, 148, 87, 136, 181, 211 ], #16, 
      [ 32, 56, 175, 214, 221, 187, 207, 180, 88, 144, 245, 243 ], 
      [ 42, 98, 74, 105 ], 
      [ 44, 114, 78, 233 ],
      [ 46, 100, 170, 102, 202, 107, 109, 58, 90, 76, 121, 226 ],
      [ 48, 116, 172, 118, 206, 235, 237, 60, 94, 80, 249, 242 ], 
      [ 61, 103, 166, 154, 91, 196 ],
      [ 62, 104, 174, 230, 218, 123, 111, 186, 92, 204, 125, 228 ],
      [ 63, 119, 168, 182, 158, 219, 231, 156, 95, 200, 189, 212 ],
      [ 64, 120, 176, 246, 222, 251, 239, 188, 96, 208, 253, 244 ], 
      [ 106 ], 
      [ 108, 122, 110, 234 ],
      [ 112, 124, 236, 126, 238, 250 ], 
      [ 127, 232, 190, 220 ], 
      [ 128, 240, 254, 252 ], 
      [ 151 ], 
      [ 152, 159, 215, 183 ],
      [ 160, 184, 191, 216, 223, 247 ], 
      [ 192, 248, 224, 255 ], 
      [ 256 ] \
    ]


    # white list
    white_list = []


    # black list
    black_list = []

    black_list |= cube_v_types[11]

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