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
    @rotation_speed = 0
  end

  def knock_off
    self.base_floors_only = true
    @y_speed = 10
    @rotation_speed = 1
  end

  def tick
    super
    @rotation += @rotation_speed
  end
end
