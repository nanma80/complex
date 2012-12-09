class Puzzle
  attr_reader :platonic_solid, :number_pieces, :pieces, :stickers, :number_visible_stickers, :number_visible_pieces

  def initialize(shape, turning_axes)
    @platonic_solid = Platonic.new(shape, turning_axes)

    if @platonic_solid.axes.empty?
      raise "Cannot construct model."
      exit
    end

    populate_pieces

    populate_stickers

  end


  def populate_pieces
    @number_pieces = 2**(@platonic_solid.axes.length) # total number of pieces in the full complex puzzle

    # populate pieces
    visible_pieces_so_far = 0 # count the visible pieces so far
    @pieces = Array.new(@number_pieces) do |id|
      piece = Piece.new(id, visible_pieces_so_far, @platonic_solid)
      piece.determine_visibility # determine the visibility based on its id
      visible_pieces_so_far += 1  if piece.visibility # count the visible pieces
      piece
    end

    @number_visible_pieces = visible_pieces_so_far

  end

  def populate_stickers
    @stickers = []

    @pieces.each do |piece|
      @platonic_solid.axes.length.times do |in_piece_id|
        # in_piece_id is the internal id of a sticker within this piece, between 0 and the number of axis minus one
        @stickers << Sticker.new(piece.id, piece.visible_id, in_piece_id, @platonic_solid, piece.visibility)
      end
    end

    @number_visible_stickers = @number_visible_pieces * @platonic_solid.axes.length

  end



  def transform_sticker(axis)
    # generate an array for where the stickers are going. Cannot be used by GAP. GAP requires the entries of PermList to start from 1 but not 0
    @stickers.map {|sticker| sticker.transform(axis, @pieces) }
  end

  def transform_sticker_plus_one(axis)
    # this is used by GAP. 
    # First, the id's used by GAP starts from 1, so I added one to all the id's to construct the new id accepted by GAP
    # Second, only consider the visible pieces
    output = []
    @stickers.each do |sticker|
      if @stickers[sticker.transform(axis, @pieces)].visibility # only append into output array if this sticker is visible
        output << (@stickers[sticker.transform(axis, @pieces)].visible_id + 1 )
      end
    end
    return output
  end

  def transform_piece(axis)
    # generate an array for where the pieces are going. Cannot be used by GAP. GAP requires the entries of PermList to start from 1 but not 0
    @pieces.map {|piece| piece.transform(axis) }
  end

  def transform_piece_plus_one(axis)
    # this is used by GAP. 
    # First, the id's used by GAP starts from 1, so I added one to all the id's to construct the new id accepted by GAP
    # Second, only consider the visible pieces
    output = []
    @pieces.each do |piece|
      if @pieces[piece.transform(axis)].visibility
        output << @pieces[piece.transform(axis)].visible_id + 1 
      end
    end
    return output
  end

  def reorient_piece_plus_one(axis)
    # this is used by GAP. 
    # this method is similar to piece, but instead of a "twist", apply whole-puzzle reorientation. 
    # The size of the group is only the symmetry of the platonic solid (e.g., 24 for cube)
    # But the orbit of the pieces gives the piece types
    output = []
    @pieces.each do |piece|
      if @pieces[piece.reorient(axis)].visibility
        output << @pieces[piece.reorient(axis)].visible_id + 1 
      end
    end
    return output
  end

end