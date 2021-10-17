require_relative '../engine/entity'

class DestructableObject < GravityEntity
  def initialize(id, position)
    img = Gosu::Image.new(File.join(RES_ROOT, "objects", "#{id}.png"))

    super(
      position: position,
      animations: {
        "static" => Animation.static(img),
      },
      scaling: 5,
    )
 
    self.animation = "static"
  end
end
