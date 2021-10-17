class World
  Floor = Struct.new("Floor", :position, :width, :base)

  def initialize
    @floors = []
    @entities = []
  end

  def find_entity_at(x, y, type: nil)
    @entities.find do |e|
      x > e.position.x \
      && x < e.position.x + e.image.width * e.scaling \
      && y > e.position.y \
      && y < e.position.y + e.image.height * e.scaling \
      && (type ? type === e : true)
    end
  end

  attr_reader :floors, :entities
end
