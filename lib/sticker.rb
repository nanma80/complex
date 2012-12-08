require_relative 'platonic'

class Sticker
  attr_reader :id, :piece_id, :in_piece_id
  attr_accessor :visibility, :visible_id

  def initialize(piece_id, visible_piece_id, in_piece_id, platonic_solid, visibility=true)
    @piece_id = piece_id
    @visible_piece_id = visible_piece_id
    @in_piece_id = in_piece_id
    @platonic_solid = platonic_solid

    @id = @piece_id * @platonic_solid.axes.length + @in_piece_id
    
    @visibility = visibility
    @visible_id = @visible_piece_id * @platonic_solid.axes.length + @in_piece_id

  end

  def transform(axis, pieces)
    new_piece_id = pieces[@piece_id].transform(axis)
    if pieces[@piece_id].turnability[axis]
      new_in_piece_id = @platonic_solid.table[@in_piece_id][axis]
    else
      new_in_piece_id = in_piece_id
    end
    new_id = new_piece_id * @platonic_solid.axes.length + new_in_piece_id

    return new_id
  end

end