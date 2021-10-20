require_relative '../engine/entity'
require_relative '../res'

class DestructableObject < GravityEntity
  def initialize(id, position)
    # TODO World already loads this, ditto with scenery
    img = Gosu::Image.new(File.join(RES_ROOT, "objects", "#{id}.png"))

    super(
      position: position,
      animations: {
        "static" => Animation.static(img),
      },
      scaling: GLOBAL_SCALE,
      gravity_enabled: false,
    )
 
    self.animation = "static"
    @rotation_speed = 0
    @x_speed = 0
  end

  def knock_off
    self.gravity_enabled = true
    self.position.z = 99

    # Give score
    if knocked_off?
      $state.juggle_object
    else
      self.base_floors_only = true
      $state.destroy_object
    end 

    @y_speed = 10
    @x_speed = 3 * ($world.cat.mirror_x ? -1 : 1)
    @rotation_speed = $world.cat.mirror_x ? 1 : -1
  end

  def knocked_off?
    # We disable collisions when knocked off so we can just use that to check
    self.base_floors_only
  end

  def tick
    super
    @rotation += @rotation_speed
    position.x += @x_speed
  end
end
