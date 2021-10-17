class World
  Floor = Struct.new("Floor", :position, :width)

  def initialize
    @floors = []
  end

  attr_reader :floors
end
