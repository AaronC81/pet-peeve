require_relative '../engine/entity'

class Cat < Entity
  MOVE_SPEED = 5

  def initialize
    cat_tiles = Gosu::Image.load_tiles(File.join(RES_ROOT, "cat.png"), -8, -10, retro: true)

    super(
      position: Point.new(200, 200),
      animations: {
        "idle" => Animation.new(cat_tiles[0..3], 8),
        "run" => Animation.new(cat_tiles[40..47], 4),
        "jump" => Animation.new(cat_tiles[66..66], 1000),
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
    self.animation = "idle" unless jumping?
  end

  def jump
    return if jumping?
    @y_speed = 15.0
    self.animation = "jump"
  end

  def jumping?
    @y_speed > 0
  end

  def tick
    super

    if @y_speed > 0
      self.position.y -= @y_speed.to_i
      @y_speed -= 0.9
      # TODO: fall down
    end
  end
end
