require_relative 'res'
require_relative 'entities/wall'
require_relative 'entities/cat_flap'

class World
  GLOBAL_FLOOR_Y = 850

  Floor = Struct.new("Floor", :position, :width, :base)

  def initialize
    @extra_floors = []
    @entities = []
    @cat = nil
  end

  def find_entity_at(x, y, type: nil)
    @entities.find do |e|
      x > e.position.x \
      && x < e.position.x + e.image.width * e.scaling \
      && y > e.position.y \
      && y < e.position.y + e.image.height * e.scaling \
      && (type ? type === e : true)
    end
  end

  def floors
    @extra_floors + @entities.flat_map(&:floors)
  end

  attr_reader :extra_floors, :entities
  attr_accessor :cat

  def clear
    @entities = []
  end

  # without scaling!
  def self.load_res_dir(dir)
    Dir[File.join(RES_ROOT, dir, "*.png")].map do |path|
      [File.basename(path, ".png"), Gosu::Image.new(path, retro: true)]
    end
  end

  OBJECTS = load_res_dir("objects")
  SCENERIES = load_res_dir("scenery")
  WALLS = load_res_dir("walls")

  def self.object(name)
    OBJECTS.find { |k, _| k == name }
  end

  def self.scenery(name)
    SCENERIES.find { |k, _| k == name }
  end

  def self.wall(name)
    WALLS.find { |k, _| k == name }
  end

  NON_DEFAULT_FLOORS = {
    "large_bed" => 100,
  }

  GROUND_SCENERIES = SCENERIES.reject { |k, _| k == "shelf" }
  ELEVATED_SCENERIES = [scenery("shelf")]

  OBJECT_SET_FOR_SCENERY = {
    "large_bed" => [
      # Make stuffed animals rarer
      object("pillow"),
      object("pillow"),
      object("pillow"),
      object("pillow"),
      object("pillow"),
      object("stuffed_shark"),
      object("plush_dog"),
      object("teddy_bear"),
      object("plush_fish"),
    ],
    "default" => OBJECTS.reject { |k, _| %w{pillow stuffed_shark teddy_bear plush_dog plush_fish}.include?(k) },
  }

  # So we do not get too many small objects bunched close to each other
  # (This is a scaled size)
  MINIMUM_OBJECT_WIDTH = 100

  def cleared
    $world.entities.find { |e| e.is_a?(CatFlap) }.active = true
  end

  def next_level
    $state.level_complete
    $state.timer_running = false
    Audio.play_effect("next")

    $transition.fade_out(40) do
      clear
      generate
      reposition
      $state.timer_running = true
      $transition.fade_in(40) {}
    end
  end

  def generate
    wn, wi = WALLS.sample
    $world.entities << Wall.new(wn)

    generation_pass(GROUND_SCENERIES, GLOBAL_FLOOR_Y) { (50..200).to_a.sample }
    generation_pass(ELEVATED_SCENERIES, GLOBAL_FLOOR_Y - 300) { (150..250).to_a.sample }
    generation_pass(ELEVATED_SCENERIES, GLOBAL_FLOOR_Y - 450) { (300..500).to_a.sample }

    $world.entities << CatFlap.new(Point.new(100, GLOBAL_FLOOR_Y - 150, 1))
  end

  def generation_pass(sceneries, y, &x_padding_fn)
    scenery_x = 300

    loop do
      # Pick an item of scenery
      sn, si = sceneries.sample
      sgw = si.width * GLOBAL_SCALE

      # If it wouldn't fit, stop generating
      if scenery_x + sgw > 1600
        break
      end

      # Figure out the Y and the floor
      sy = y - GLOBAL_SCALE * si.height
      floor = NON_DEFAULT_FLOORS[sn] || true

      # Add it to the world
      $world.entities << Scenery.new(sn, Point.new(scenery_x, sy, 2), floor: floor)

      # Select random objects up to the width of the surface
      objects = []
      objects_total_width = 0
      loop do
        on, oi = OBJECT_SET_FOR_SCENERY[sn]&.sample || OBJECT_SET_FOR_SCENERY["default"].sample
        ogw = oi.width * GLOBAL_SCALE
        ogw = [ogw, MINIMUM_OBJECT_WIDTH].max # TODO: leads to misaligned objects
        if objects_total_width + ogw < sgw
          objects << [on, oi]
          objects_total_width += ogw
        else
          redo if objects.empty? # At least one object required
          break
        end
      end

      # Distribute objects across the surface
      padding_between_items = (sgw - objects_total_width) / (objects.length + 1)
      object_x = padding_between_items
      objects.each do |on, oi|
        $world.entities << DestructableObject.new(
          on, Point.new(
            scenery_x + object_x,
            # If object has non-default floor, consider that too
            sy - oi.height * GLOBAL_SCALE + (floor.is_a?(Integer) ? floor : 0),
            5
          ),
        )

        object_x += oi.width * GLOBAL_SCALE + padding_between_items
      end

      scenery_x += sgw + x_padding_fn.()
    end
  end

  def reposition
    cat.position.x = 120
    cat.position.y = GLOBAL_FLOOR_Y - 150
  end
end
