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
      },
      scaling: 5,
    )

    self.animation = "idle"
  end

  def move_right
    self.position.x += MOVE_SPEED
    self.animation = "run"
    self.mirror_x = false
  end

  def move_left
    self.position.x -= MOVE_SPEED
    self.animation = "run"
    self.mirror_x = true
  end

  def idle
    self.animation = "idle"
  end
end
