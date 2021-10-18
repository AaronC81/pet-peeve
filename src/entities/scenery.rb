require_relative '../world'

class Scenery < Entity
  def initialize(id, position, floor: false)
    img = Gosu::Image.new(File.join(RES_ROOT, "scenery", "#{id}.png"))

    super(
      position: position,
      animations: {
        "static" => Animation.static(img),
      },
      scaling: 5,
    )
  
    self.animation = "static"

    if floor
      self.floors << World::Floor.new(position, img.width * scaling, false)
    end
  end
end
