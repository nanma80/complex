class Point3d
  attr_accessor :coord, :norm

  def initialize(vector)
    norm_sq = 0
    
    vector.each do |component|
      norm_sq += component * component
    end
    
    if norm_sq > 0
      @norm = Math.sqrt(norm_sq)

      @coord = vector.map{|x| x/norm}
    else
      @norm = 0
      @coord = [0,0,0]
    end

  end

  def to_s
    "[#{coord[0]}, #{coord[1]}, #{coord[2]}]"
  end

  def rotate(axis, t) 
    # rotating self around axis by t radian

    raise "Norm of axis cannot be zero" if axis.norm == 0
    
    (ux, uy, uz) = axis.coord
    (x, y, z ) = @coord

    ct = Math.cos(t)
    st = Math.sin(t)

    newx = (ct + ux * ux * (1-ct)) * x + (ux * uy *(1-ct) -uz * st) * y +(ux*uz *(1-ct) + uy*st) * z
    newy = (uy * ux *(1-ct) + uz* st)*x + (ct + uy * uy *(1-ct)) *y +(uy*uz*(1-ct)-ux*st) * z
    newz = (uz*ux*(1-ct) - uy*st) *x + (uz*uy*(1-ct) +ux*st)*y + (ct + uz*uz*(1-ct))*z

    Point3d.new([newx, newy, newz])

  end

  def dist_sq(p2)
    # return the squared Euclidean distance to p2
    dist = 0.0
    @coord.length.times do |dimension|
      diff = @coord[dimension] - p2.coord[dimension]
      dist += diff * diff
    end
    dist
  end

end