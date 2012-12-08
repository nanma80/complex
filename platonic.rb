require_relative 'point_3d'

class Platonic
  attr_reader :axes, :table

  def initialize(shape, axes)
    @axes = []

    @f_order = 3
    @v_order = 3
    @e_order = 2 # always true
    @order = 2
    
    @phi = (1.0 + Math.sqrt(5.0))/2.0

    import_axes(shape, axes)

    # puts "Axes are in these directions:"
    # puts @axes

    generate_multiplication_table

    # table[rotated][rotating] = index of destination
    # puts "\nMultiplication table:"
    # print_table

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
        if (dist_vector.min > 0.0001)
          raise "Cannot construct multiplication table."
        end
        dist_vector.rindex(dist_vector.min)
      end
    end
  end

  def import_axes(shape, axes)

    if shape == 'cube' and axes == 'face'
      @f_order = 4
      @v_order = 3
      @axes = cube_face

    elsif shape == 'cube' and axes == 'vertex'
      @f_order = 4
      @v_order = 3
      @axes = cube_vertex

    elsif shape == 'cube' and axes == 'edge'
      @f_order = 4
      @v_order = 3
      @axes = cube_edge

    elsif shape == 'octahedron' and axes == 'face'
      @f_order = 3
      @v_order = 4
      @axes = cube_vertex

    elsif shape == 'octahedron' and axes == 'vertex'
      @f_order = 3
      @v_order = 4
      @axes = cube_face

    elsif shape == 'octahedron' and axes == 'edge'
      @f_order = 3
      @v_order = 4
      @axes = cube_edge

    elsif shape == 'icosahedron' and axes == 'face'
      @f_order = 3
      @v_order = 5
      @axes = dodecahedron_vertex

    elsif shape == 'icosahedron' and axes == 'vertex'
      @f_order = 3
      @v_order = 5
      @axes = icosahedron_vertex

    elsif shape == 'icosahedron' and axes == 'edge'
      @f_order = 3
      @v_order = 5
      @axes = dodecahedron_edge

    elsif shape == 'dodecahedron' and axes == 'face'
      @f_order = 5
      @v_order = 3
      @axes = icosahedron_vertex

    elsif shape == 'dodecahedron' and axes == 'vertex'
      @f_order = 5
      @v_order = 3
      @axes = dodecahedron_vertex

    elsif shape == 'dodecahedron' and axes == 'edge'
      @f_order = 5
      @v_order = 3
      @axes = dodecahedron_edge

    elsif shape=='tetrahedron' and (axes =='face' or axes == 'vertex')
      @f_order = 3
      @v_order = 3
      @axes = tetrahedron_face

    elsif shape=='tetrahedron' and (axes =='edge')
      @f_order = 3
      @v_order = 3
      @axes = cube_face
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

  def cube_vertex
    cube_vertex = []

    cube_vertex << Point3d.new([ 1, 1, 1])
    cube_vertex << Point3d.new([ 1, 1, -1])
    cube_vertex << Point3d.new([ 1, -1, 1])
    cube_vertex << Point3d.new([ 1, -1, -1])
    cube_vertex << Point3d.new([ -1, 1, 1])
    cube_vertex << Point3d.new([ -1, 1, -1])
    cube_vertex << Point3d.new([ -1, -1, 1])
    cube_vertex << Point3d.new([ -1, -1, -1])
    
    cube_vertex
  end

  def icosahedron_vertex
    icosahedron_vertex = []

    icosahedron_vertex << Point3d.new([ 0, 1.0, @phi])
    icosahedron_vertex << Point3d.new([ 0, 1.0, -@phi])
    icosahedron_vertex << Point3d.new([ 0, -1.0, @phi])
    icosahedron_vertex << Point3d.new([ 0, -1.0, -@phi])

    icosahedron_vertex << Point3d.new([ 1.0, @phi, 0])
    icosahedron_vertex << Point3d.new([ 1.0, -@phi, 0])
    icosahedron_vertex << Point3d.new([ -1.0, @phi, 0])
    icosahedron_vertex << Point3d.new([ -1.0, -@phi, 0])

    icosahedron_vertex << Point3d.new([ @phi, 0, 1.0])
    icosahedron_vertex << Point3d.new([ @phi, 0, -1.0])
    icosahedron_vertex << Point3d.new([ -@phi, 0, 1.0])
    icosahedron_vertex << Point3d.new([ -@phi, 0, -1.0])
    
    icosahedron_vertex
  end

  def dodecahedron_vertex
    dodecahedron_vertex = cube_vertex # including all the vertices of [1,1,1]...

    dodecahedron_vertex << Point3d.new([ 0, 1/@phi, @phi])
    dodecahedron_vertex << Point3d.new([ 0, 1/@phi, -@phi])
    dodecahedron_vertex << Point3d.new([ 0, -1/@phi, @phi])
    dodecahedron_vertex << Point3d.new([ 0, -1/@phi, -@phi])

    dodecahedron_vertex << Point3d.new([ 1/@phi, @phi,0])
    dodecahedron_vertex << Point3d.new([ 1/@phi, -@phi,0])
    dodecahedron_vertex << Point3d.new([ -1/@phi, @phi,0])
    dodecahedron_vertex << Point3d.new([ -1/@phi, -@phi,0])

    dodecahedron_vertex << Point3d.new([ @phi, 0, 1/@phi])
    dodecahedron_vertex << Point3d.new([ @phi, 0, -1/@phi])
    dodecahedron_vertex << Point3d.new([ -@phi, 0, 1/@phi])
    dodecahedron_vertex << Point3d.new([ -@phi, 0, -1/@phi])
    
    dodecahedron_vertex
  end

  def dodecahedron_edge
    dodecahedron_edge = cube_face # starts with [1,0,0]...

    dodecahedron_edge << Point3d.new([ 1, 1+1/@phi, 1+@phi])
    dodecahedron_edge << Point3d.new([ -1, 1+1/@phi, 1+@phi])
    dodecahedron_edge << Point3d.new([ 1, 1+1/@phi, -1-@phi])
    dodecahedron_edge << Point3d.new([ -1, 1+1/@phi, -1-@phi])
    dodecahedron_edge << Point3d.new([ 1, -1-1/@phi, 1+@phi])
    dodecahedron_edge << Point3d.new([ -1, -1-1/@phi, 1+@phi])
    dodecahedron_edge << Point3d.new([ 1, -1-1/@phi, -1-@phi])
    dodecahedron_edge << Point3d.new([ -1, -1-1/@phi, -1-@phi])

    dodecahedron_edge << Point3d.new([ 1+1/@phi, 1+@phi,1])
    dodecahedron_edge << Point3d.new([ 1+1/@phi, 1+@phi,-1])
    dodecahedron_edge << Point3d.new([ 1+1/@phi, -1-@phi,1])
    dodecahedron_edge << Point3d.new([ 1+1/@phi, -1-@phi,-1])
    dodecahedron_edge << Point3d.new([ -1-1/@phi, 1+@phi,1])
    dodecahedron_edge << Point3d.new([ -1-1/@phi, 1+@phi,-1])
    dodecahedron_edge << Point3d.new([ -1-1/@phi, -1-@phi,1])
    dodecahedron_edge << Point3d.new([ -1-1/@phi, -1-@phi,-1])

    dodecahedron_edge << Point3d.new([ 1+@phi, 1, 1+1/@phi])
    dodecahedron_edge << Point3d.new([ 1+@phi, -1, 1+1/@phi])
    dodecahedron_edge << Point3d.new([ 1+@phi, 1, -1-1/@phi])
    dodecahedron_edge << Point3d.new([ 1+@phi, -1, -1-1/@phi])
    dodecahedron_edge << Point3d.new([ -1-@phi, 1, 1+1/@phi])
    dodecahedron_edge << Point3d.new([ -1-@phi, -1, 1+1/@phi])
    dodecahedron_edge << Point3d.new([ -1-@phi, 1, -1-1/@phi])
    dodecahedron_edge << Point3d.new([ -1-@phi, -1, -1-1/@phi])

    dodecahedron_edge
  end

  def cube_edge
    cube_edge = []

    cube_edge << Point3d.new([1,1,0])
    cube_edge << Point3d.new([1,-1,0])
    cube_edge << Point3d.new([-1,1,0])
    cube_edge << Point3d.new([-1,-1,0])
    cube_edge << Point3d.new([1,0,1])
    cube_edge << Point3d.new([1,0,-1])
    cube_edge << Point3d.new([-1,0,1])
    cube_edge << Point3d.new([-1,0,-1])
    cube_edge << Point3d.new([0,1,1])
    cube_edge << Point3d.new([0,1,-1])
    cube_edge << Point3d.new([0,-1,1])
    cube_edge << Point3d.new([0,-1,-1])
    
    cube_edge
  end


  def tetrahedron_face
    tetrahedron_face = []
    tetrahedron_face << Point3d.new([ 1, 1, 1])
    tetrahedron_face << Point3d.new([ 1,-1,-1])
    tetrahedron_face << Point3d.new([-1,-1, 1])
    tetrahedron_face << Point3d.new([-1, 1,-1])
    tetrahedron_face
  end

end
