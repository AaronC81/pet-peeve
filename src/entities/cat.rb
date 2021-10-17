require_relative '../engine/entity'

class Cat < Entity
  MOVE_SPEED = 5
  FLOOR_CLIP_THRESHOLD = 20

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

    @y_speed = 0.0
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

  def jumping?
    @y_speed > 0
  end

  def falling?
    @y_speed < 0
  end

  def tick
    super

    if falling?
      self.animation = "fall"
    end

    if !on_floor?
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
        && !jumping? \
        && position.x + (image.height * scaling * 0.7) > floor.position.x \
        && position.x + (image.height * scaling * 0.25) < (floor.position.x + floor.width)

        self.position.y = floor.position.y - image.height * scaling
        true
      else
        false
      end
    end
  end
end
