require 'matrix' 
require_relative 'animation'
require_relative 'point'
 
class Entity
  attr_accessor :position, :animations, :scaling, :mirror_x

  def initialize(position: nil, animations: nil, scaling: nil)
    @position = position || Point.new(0, 0)
    @animations = animations || {}
    @scaling = scaling || 1

    @current_animation = nil
    @current_animation_name = nil

    @mirror_x = false
  end

  def image=(image)
    raise "use Entity animations or image, not both" unless [[], [:_static]].include?(@animations.keys)

    @animations = { _static: Animation::new([image], 1000) }
    self.animation = :_static
  end

  def animation=(anim_name)
    return if @current_animation_name == anim_name

    @current_animation = @animations[anim_name]
    @current_animation_name = anim_name
    raise "no animation named #{anim_name}" if !@current_animation

    @current_animation.reset
  end

  def tick
    @current_animation&.tick
  end

  def draw
    img = @current_animation&.image
    return unless img

    img.draw(
      position.x + (mirror_x ? img.width * scaling : 0), position.y, position.z,
      scaling * (mirror_x ? -1 : 1),
      scaling
    )
  end
end
