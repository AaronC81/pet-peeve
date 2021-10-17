require_relative '../engine/gravity_entity'

class Cat < GravityEntity
  MOVE_SPEED = 5

  def initialize(position)
    cat_tiles = Gosu::Image.load_tiles(File.join(RES_ROOT, "cat.png"), -8, -10, retro: true)

    super(
      position: position,
      animations: {
        "idle" => Animation.new(cat_tiles[0..3], 8),
        "run" => Animation.new(cat_tiles[40..47], 4),
        "jump" => Animation.new(cat_tiles[66..66], 1000),
        "fall" => Animation.new(cat_tiles[67..67], 1000),
      },
      scaling: 5,
    )

    self.animation = "idle"
  end

  def move_right
    self.position.x += MOVE_SPEED
    self.animation = "run" unless jumping?
    self.mirror_x = false
  end

  def move_left
    self.position.x -= MOVE_SPEED
    self.animation = "run" unless jumping?
    self.mirror_x = true
  end

  def idle
    self.animation = "idle" unless jumping? || falling?
  end

  def jump
    return if jumping? || falling?
    @y_speed = 20.0
    self.animation = "jump"
  end

  def tick
    super

    if falling?
      self.animation = "fall"
    end
  end

  def left_floor_collision_scaling; 0.7 end
  def right_floor_collision_scaling; 0.25 end
end
