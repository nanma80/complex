class Puzzle
  attr_reader :platonic_solid, :number_pieces, :pieces, :stickers, :number_visible_stickers, :number_visible_pieces

  def initialize(shape, axes)
    @platonic_solid = Platonic.new(shape, axes)

    if @platonic_solid.axes.empty?
      raise "Cannot construct model."
      exit
    end

    @number_pieces = 2**(@platonic_solid.axes.length)

    # populate pieces
    visible_pieces_so_far = 0
    @pieces = Array.new(@number_pieces) do |id|
      piece = Piece.new(id, visible_pieces_so_far, @platonic_solid)
      piece.determine_visibility
      if piece.visibility
        visible_pieces_so_far += 1
      end
      piece
    end

    @number_visible_pieces = visible_pieces_so_far

    @stickers = []

    @pieces.each do |piece|
      @platonic_solid.axes.length.times do |in_piece_id|
        @stickers << Sticker.new(piece.id, piece.visible_id, in_piece_id, @platonic_solid, piece.visibility)
      end
    end

    @number_visible_stickers = @number_visible_pieces * @platonic_solid.axes.length

  end

  def transform_sticker(axis)
    @stickers.map {|sticker| sticker.transform(axis, @pieces) }
  end

  def transform_sticker_plus_one(axis)
    output = []
    @stickers.each do |sticker|
      if @stickers[sticker.transform(axis, @pieces)].visibility
        output << (@stickers[sticker.transform(axis, @pieces)].visible_id + 1 )
      end
    end
    return output
  end

  def transform_piece(axis)
    @pieces.map {|piece| piece.transform(axis) }
  end

  def transform_piece_plus_one(axis)
    output = []
    @pieces.each do |piece|
      if @pieces[piece.transform(axis)].visibility
        output << @pieces[piece.transform(axis)].visible_id + 1 
      end
    end
    return output
  end

  def reorient_piece_plus_one(axis)
    output = []
    @pieces.each do |piece|
      if @pieces[piece.reorient(axis)].visibility
        output << @pieces[piece.reorient(axis)].visible_id + 1 
      end
    end
    return output
  end

end