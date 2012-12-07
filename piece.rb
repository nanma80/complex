class Piece
  attr_reader :axes_length, :id, :turnability, :id_string, :order

  def initialize(id, platonic_solid)
    @id = id
    @platonic_solid = platonic_solid
    @axes_length = @platonic_solid.axes.length

    generate_turnability
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

end