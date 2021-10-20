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
  end

  def tick
    return unless active

    # Is cat touching?
    cp = $world.cat.position
    ci = $world.cat.image
    if (cp.x + ci.width * GLOBAL_SCALE >= position.x \
      && cp.x <= position.x + image.width * GLOBAL_SCALE \
      && cp.y >= position.y - image.height * GLOBAL_SCALE)

      # Next level!
      $world.next_level
      @active = false
    end
  end
end
