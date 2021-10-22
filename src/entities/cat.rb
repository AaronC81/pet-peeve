require_relative '../engine/gravity_entity'
require_relative 'destructable_object'

class Cat < GravityEntity
  MOVE_SPEED = 7
  SWIPE_COOLDOWN_FRAMES = 8

  def initialize(position)
    cat_tiles = Gosu::Image.load_tiles(File.join(RES_ROOT, "cat.png"), -8, -10, retro: true)

    super(
      position: position,
      animations: {
        "idle" => Animation.new(cat_tiles[0..3], 8),
        "run" => Animation.new(cat_tiles[40..47], 4),
        "jump" => Animation.new(cat_tiles[66..66], 1000),
        "fall" => Animation.new(cat_tiles[67..67], 1000),
        "swipe" => Animation.static(cat_tiles[60]),
      },
      scaling: 5,
    )

    self.animation = "idle"

    @swipe_cooldown = 0
  end

  def move_right
    self.position.x += MOVE_SPEED if position.x + image.width * GLOBAL_SCALE < 1640 - MOVE_SPEED
    self.animation = "run" unless jumping? || swipe_cooling_down?
    self.mirror_x = false
  end

  def move_left
    self.position.x -= MOVE_SPEED if position.x + 40 > MOVE_SPEED
    self.animation = "run" unless jumping? || swipe_cooling_down?
    self.mirror_x = true
  end

  def idle
    self.animation = "idle" unless jumping? || falling? || swipe_cooling_down?
  end

  def jump
    return if jumping? || falling?
    @y_speed = 20.0
    self.animation = "jump"
  end
  
  def swipe_release
    @waiting_for_swipe_release = false
  end
  
  def swipe
    return if swipe_cooling_down? || @waiting_for_swipe_release
    @waiting_for_swipe_release = true
    @swipe_cooldown = SWIPE_COOLDOWN_FRAMES

    self.animation = "swipe"

    # Two sample points, front and back of paw
    obj = $world.find_entity_at(
      position.x + image.width * scaling / 2 + (image.width * scaling * 0.25 * (mirror_x ? -1 : 1)),
      position.y + image.height * scaling * 0.9,
      type: DestructableObject,
    )
    if obj
      obj.knock_off
    else
      $world.find_entity_at(
        position.x + image.width * scaling / 2 + (image.width * scaling * 0.15 * (mirror_x ? -1 : 1)),
        position.y + image.height * scaling * 0.9,
        type: DestructableObject,
      )&.knock_off
    end
  end

  def tick
    super

    if falling?
      self.animation = "fall"
    end

    @swipe_cooldown -= 1 if swipe_cooling_down?
  end

  def left_floor_collision_scaling; 0.7 end
  def right_floor_collision_scaling; 0.25 end

  def swipe_cooling_down?
    @swipe_cooldown > 0
  end

  # Override due to lots of transparency in sprite
  def bounding_box
    width = image.width * scaling
    height = image.height * scaling

    Box.new(
      Point.new(position.x + width * 0.3, position.y + height * 0.6, position.z),
      width * 0.4,
      height * 0.4,
    )
  end
end
