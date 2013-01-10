class Piece
  attr_reader :axes_length, :id, :turnability, :id_string, :order
  attr_accessor :visibility, :visible_id

  def initialize(id, visible_id, platonic_solid, visibility = true)
    @id = id # id of piece. An integer between 0 and 2^(number of axes) - 1
    @platonic_solid = platonic_solid
    @axes_length = @platonic_solid.axes.length # number of axes, or, the length of the axes array
    @visibility = visibility # binary variable to indicate whether a piece is actually visible or not at the end
    generate_turnability
    @visible_id = visible_id # Some pieces are visible and some not. visible_id is the count of only visible pieces, skipping all the invisible ones.
  end

  def generate_turnability
    # turnability is an array of boolean variables, indicating whether this piece is movable by which axes
    # Example: in a face turning cube, the FR edge's turnability array is:
    # [true, false, true, false, false, false]
    # the 0th axis is FRONT, and the 2nd axis is UP. The FR edge are turnable by these two axes.
    # method: convert the id (integer) into a string like "101000", then translate "1"-> true, "0"->false

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
    # determine whether a piece is visible based on its id. The arrays cube_f_types and cube_v_types are copied from the output of GAP.
    # set a white list and black list that may include some of the piece types, and determine @visibility
    # this part is partly manual
    # uses data from PieceTypes class

    # white list
    white_list = []

    # white_list |= PieceTypes.cube_f_types[0]
    # white_list |= PieceTypes.cube_f_types[2]
    # white_list |= PieceTypes.cube_f_types[3]

    # white_list |= PieceTypes.dodeca_f_types[0] # core
    # white_list |= PieceTypes.dodeca_f_types[1] # megaminx centers
    # white_list |= PieceTypes.dodeca_f_types[2] # megaminx edges
    # white_list |= PieceTypes.dodeca_f_types[7] # megaminx corners
    # white_list |= PieceTypes.dodeca_f_types[74] # pentultimate corners
    # white_list |= PieceTypes.dodeca_f_types[80] # pentultimate centers
    # white_list |= PieceTypes.dodeca_f_types[94] # anti megaminx centers
    # white_list |= PieceTypes.dodeca_f_types[95] # anti-core

    # PieceTypes.dodeca_f_types.each do |type|
    #   if type.length == 30
    #     white_list |= type
    #   end
    # end


    # black list
    black_list = []

    # black_list |= PieceTypes.cube_v_types[0]
    # black_list |= PieceTypes.cube_v_types[11]
    # black_list |= PieceTypes.cube_v_types[29]
    # black_list |= PieceTypes.cube_v_types[35]
    
    if !(white_list.empty?)
      @visibility = (white_list.include? (@id+1))
    else # white list is empty, look at black list
      @visibility = !(black_list.include? (@id+1))
    end

    
  end

  def transform(axis)
    # return id of destination piece, if the current piece (self) is twisted by the axis
    if !@turnability[axis]
      # if this piece is not turnable by axis, it doesn't move
      return @id
    end

    # when it will be moved by axis, find the destination
    reorient axis
  end

  def reorient(axis)
    # assuming this piece is moved by axis, find the id of destination piece
    # this method is called reorient, because when reorient the puzzle, all the pieces needs to call this method
    
    # duplicate id_string
    new_id_string = @id_string[0..-1]

    @axes_length.times do |from_index|
      # change the new_id_string based on the reorientation table of the platonic solid
      to_index = @platonic_solid.table[from_index][axis]
      new_id_string[to_index] = @id_string[from_index]
    end
    
    # convert new_id_string into integer-valued id
    return new_id_string.to_i(2)
  end

end