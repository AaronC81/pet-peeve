require_relative '../world'
require_relative '../res'
require_relative '../engine/entity'

class CatFlap < Entity
  attr_accessor :active

  def initialize(position)
    img = Gosu::Image.new(File.join(RES_ROOT, "special", "cat_flap.png"))

    super(
      position: position,
      animations: {
        "static" => Animation.static(img),
      },
      scaling: GLOBAL_SCALE,
    )
  
    self.animation = "static"

    @active = false
    @arrow = Entity.new(
      # The sprite is padded with transparency so X does not need to be adjusted
      position: Point.new(
        position.x,
        position.y - img.height * GLOBAL_SCALE,
        position.y,
      ),
      animations: {
        "static" => Animation.static(
          Gosu::Image.new(File.join(RES_ROOT, "special", "cat_flap_arrow.png"))
        ),
      },
      scaling: GLOBAL_SCALE,
    )
    @arrow.animation = "static"
    @tick_count = 0
  end

  def tick
    return unless active
    @tick_count += 1

    @arrow.opacity = Math.sin(@tick_count.to_f / 20).abs * 200 + 55

    if $world.cat.bounding_box.overlaps?(bounding_box)
      # Next level!
      $world.next_level
      @active = false
    end
  end

  def draw
    super
    @arrow.draw if active
  end
end
