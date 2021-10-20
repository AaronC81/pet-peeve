require_relative 'entity'

class GravityEntity < Entity
  FLOOR_CLIP_THRESHOLD = 30

  attr_accessor :base_floors_only, :gravity_enabled
  alias base_floors_only? base_floors_only

  def initialize(*a, gravity_enabled: true, **k)
    super(*a, **k)

    @y_speed = 0.0
    @gravity_enabled = gravity_enabled
  end

  def rising?
    @y_speed > 0
  end
  alias jumping? rising?

  def falling?
    @y_speed < 0
  end

  def tick
    super

    if gravity_enabled && !on_floor?
      self.position.y -= @y_speed.to_i
      @y_speed -= 0.9
    else
      @y_speed = 0
    end
  end

  def on_floor?
    $world.floors.any? do |floor|
      v_dist = (position.y + image.height * scaling) - floor.position.y
      if v_dist >= 0 && v_dist < FLOOR_CLIP_THRESHOLD \
        && !rising? \
        && position.x + (image.height * scaling * left_floor_collision_scaling) > floor.position.x \
        && position.x + (image.height * scaling * right_floor_collision_scaling) < (floor.position.x + floor.width) \
        && (base_floors_only? ? floor.base : true)
        
        self.position.y = floor.position.y - image.height * scaling
        true
      else
        false
      end
    end
  end

  def left_floor_collision_scaling; 1 end
  def right_floor_collision_scaling; 1 end
end
