require_relative 'point_3d'

class Platonic
  attr_reader :axes, :table

  def initialize(shape, turning_axes)
    @axes = []

    @f_order = 3
    @v_order = 3
    @e_order = 2 # always true
    @order = 2
    
    @phi = (1.0 + Math.sqrt(5.0))/2.0 # golden ratio. used in the vertices of icosahedron and dodecahedron

    import_axes(shape, turning_axes)

    import_order(shape, turning_axes)

    generate_reorientation_table

  end

  def print_table
    # print the reorientation table
    @table.each do |row|
      row.each do |element|
        print element.to_s + ", "
      end  
      print "\n"
    end
  end

  def generate_reorientation_table
    # construct a table, to = @table[from][axis]. It describes where does a point "from" go when the platonic solid is rotated around axis CCW
    # Example, on face-turning cube, 0 means FRONT, 1 means RIGHT, 2 means UP. Since FRONT goes to RIGHT when the solid is rotated around UP, CCW by 90 deg, @table[0][2]==1 is true
    # method to construct it is to start with the "from" vector, do a 3D rotation, get a "to" vector. Ideally the "to" vector should be identical to one of the axes. Because of precision issue, I look for the closest axis.

    @table = Array.new(@axes.length) do |from|
      Array.new(@axes.length) do |rotating|
        to_point = @axes[from].rotate(@axes[rotating], Math::PI * 2.0/@order)
        dist_vector = @axes.map {|x| x.dist_sq(to_point)}
        if (dist_vector.min > 0.0001) # double precision should not exceed this threshold
          raise "Cannot construct reorientation table."
        end
        dist_vector.rindex(dist_vector.min) # put the index of the closest index to the reorientation table
      end
    end
  end

  def import_axes(shape, turning_axes)
    # Fill in @axes: an array containing the directions of all the turning_axes. 
    # For example, for "cube, face", @axes will be a length-6 array, containing the Point3d objects of [1,0,0], [0,1,0], [0,0,1], [-1,0,0], [0,-1,0], [0,0,-1]
    # Because of duality, cube_face is reused for octahedron_vertex

    if shape == 'cube' and turning_axes == 'face'
      @axes = cube_face

    elsif shape == 'cube' and turning_axes == 'vertex'
      @axes = cube_vertex

    elsif shape == 'cube' and turning_axes == 'edge'
      @axes = cube_edge

    elsif shape == 'octahedron' and turning_axes == 'face'
      @axes = cube_vertex

    elsif shape == 'octahedron' and turning_axes == 'vertex'
      @axes = cube_face

    elsif shape == 'octahedron' and turning_axes == 'edge'
      @axes = cube_edge

    elsif shape == 'icosahedron' and turning_axes == 'face'
      @axes = dodecahedron_vertex

    elsif shape == 'icosahedron' and turning_axes == 'vertex'
      @axes = icosahedron_vertex

    elsif shape == 'icosahedron' and turning_axes == 'edge'
      @axes = dodecahedron_edge

    elsif shape == 'dodecahedron' and turning_axes == 'face'
      @axes = icosahedron_vertex

    elsif shape == 'dodecahedron' and turning_axes == 'vertex'
      @axes = dodecahedron_vertex

    elsif shape == 'dodecahedron' and turning_axes == 'edge'
      @axes = dodecahedron_edge

    elsif shape=='tetrahedron' and (turning_axes =='face' or turning_axes == 'vertex')
      @axes = tetrahedron_face

    elsif shape=='tetrahedron' and (turning_axes =='edge')
      @axes = cube_face
    end

    
  end

  def import_order(shape, turning_axes)
    # the order of turning. For example, order = 4 for face-turning cube. It will be used in construction of reorientation table.

    if shape == 'cube'
      @f_order = 4
      @v_order = 3

    elsif shape == 'octahedron'
      @f_order = 3
      @v_order = 4

    elsif shape == 'icosahedron'
      @f_order = 3
      @v_order = 5

    elsif shape == 'dodecahedron'
      @f_order = 5
      @v_order = 3
      
    else # shape=='tetrahedron'
      @f_order = 3
      @v_order = 3
    end

    if turning_axes =='face'
      @order = @f_order
    elsif turning_axes =='vertex'
      @order = @v_order
    else # turning_axes == 'edge'
      @order = @e_order
    end
  end



  # Below: all different axes of platonic solids

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
