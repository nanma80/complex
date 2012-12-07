require_relative 'point_3d'

class Platonic
  attr_reader :axes, :table

  def initialize(shape, axes)
    @axes = []

    @f_order = 3
    @v_order = 3
    @e_order = 2 # always true
    @order = 2

    import_axes(shape, axes)

    generate_multiplication_table

    # table[rotated][rotating] = index of destination

  end

  def print_table
    @table.each do |row|
      row.each do |element|
        print element.to_s + ", "
      end  
      print "\n"
    end
  end

  def generate_multiplication_table
    @table = Array.new(@axes.length) do |rotated|
      Array.new(@axes.length) do |rotating|
        new_point = @axes[rotated].rotate(@axes[rotating], Math::PI * 2.0/@order)
        dist_vector = @axes.map {|x| x.dist_sq(new_point)}
        dist_vector.rindex(dist_vector.min)
      end
    end
  end

  def import_axes(shape, axes)

    if shape == 'cube' and axes == 'face'
      @f_order = 4
      @v_order = 3
      @axes = cube_face
    else
    

    end

    if axes =='face'
      @order = @f_order
    elsif axes =='vertex'
      @order = @v_order
    else
      @order = @e_order
    end

  end



  def cube_face
    cube_face = []

    cube_face << Point3d.new([1,0,0]) # front, 0
    cube_face << Point3d.new([0,1,0]) # right, 1
    cube_face << Point3d.new([0,0,1]) # up,    2

    cube_face << Point3d.new([-1,0,0]) # back, 3
    cube_face << Point3d.new([0,-1,0]) # left, 4
    cube_face << Point3d.new([0,0,-1]) # down, 5

    cube_face
  end

end
