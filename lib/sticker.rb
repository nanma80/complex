require_relative 'platonic'

class Sticker
  attr_reader :id, :piece_id, :in_piece_id
  attr_accessor :visibility, :visible_id

  def initialize(piece_id, visible_piece_id, in_piece_id, platonic_solid, visibility=true)
    @piece_id = piece_id
    @visible_piece_id = visible_piece_id
    @in_piece_id = in_piece_id # in_piece_id is the internal id of a sticker within this piece, between 0 and the number of axis minus one
    @platonic_solid = platonic_solid

    @id = @piece_id * @platonic_solid.axes.length + @in_piece_id # id is the global id for all stickers across pieces
    
    @visibility = visibility # get the visibility from the piece it belongs to
    @visible_id = @visible_piece_id * @platonic_solid.axes.length + @in_piece_id

  end

  def transform(axis, pieces)
    # find the destination_sticker of this sticker (self) if twisted around axis

    # first, find the destination_piece
    new_piece_id = pieces[@piece_id].transform(axis)

    # if this piece is moved, it is also rotated. So the in_piece_id is also changed
    if pieces[@piece_id].turnability[axis]
      new_in_piece_id = @platonic_solid.table[@in_piece_id][axis]
    else
      new_in_piece_id = in_piece_id
    end
    
    # compute the new sticker_id based on the piece it's on and the id within that piece
    new_id = new_piece_id * @platonic_solid.axes.length + new_in_piece_id

  end

end