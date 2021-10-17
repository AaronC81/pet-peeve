require 'matrix'

class Point
  attr_accessor :x, :y, :z

  def initialize(x, y, z = 0)
    @x = x
    @y = y
    @z = z
  end
end
