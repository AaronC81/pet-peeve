require_relative '../world'
require_relative '../res'

class Scenery < Entity
  def initialize(id, position, floor: false)
    img = Gosu::Image.new(File.join(RES_ROOT, "scenery", "#{id}.png"))

    super(
      position: position,
      animations: {
        "static" => Animation.static(img),
      },
      scaling: GLOBAL_SCALE,
    )
  
    self.animation = "static"

    if floor
      floor_offset = floor.is_a?(Integer) ? floor : 0
      self.floors << World::Floor.new(Point.new(
        position.x,
        position.y + floor_offset,
        position.z,
      ), (img.width) * scaling, false)
    end
  end
end
