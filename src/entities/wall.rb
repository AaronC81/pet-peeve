require_relative '../world'
require_relative '../res'
require_relative '../engine/entity'

class Wall < Entity
  def initialize(id)
    img = Gosu::Image.new(File.join(RES_ROOT, "walls", "#{id}.png"))

    super(
      position: Point.new(0, World::GLOBAL_FLOOR_Y - img.height * GLOBAL_SCALE, 0),
      animations: {
        "static" => Animation.static(img),
      },
      scaling: GLOBAL_SCALE,
    )
  
    self.animation = "static"
  end
end
