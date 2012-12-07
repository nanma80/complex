class Puzzle
  attr_reader :platonic_solid, :number_pieces, :pieces, :stickers

  def initialize(shape, axes)
    @platonic_solid = Platonic.new(shape, axes)
    
    @number_pieces = 2**(@platonic_solid.axes.length)

    # populate pieces
    @pieces = Array.new(@number_pieces) do |id|
      piece = Piece.new(id, @platonic_solid)
    end

    # @pieces.select!{|piece| piece.order<=1}

    @stickers = []

    @pieces.each do |piece|
      @platonic_solid.axes.length.times do |in_piece_id|
        @stickers << Sticker.new(piece.id, in_piece_id, @platonic_solid)
      end
    end
  end

  def transform_sticker(axis)
    @stickers.map {|sticker| sticker.transform(axis, @pieces) }
  end

  def transform_sticker_plus_one(axis)
    transform_sticker(axis).map{|x| x+1}
  end

  def transform_piece(axis)
    # @pieces.map {|piece| "#{piece.id} --> #{piece.transform(axis)}" }
    # @pieces.map {|piece| "#{piece.id_string} --> #{@pieces[piece.transform(axis)].id_string}" }
    @pieces.map {|piece| piece.transform(axis) }
  end

  def transform_piece_plus_one(axis)
    @pieces.map {|piece| piece.transform(axis) + 1 }
  end

end