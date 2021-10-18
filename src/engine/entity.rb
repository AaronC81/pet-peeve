require 'matrix' 
require_relative 'animation'
require_relative 'point'
 
class Entity
  attr_accessor :position, :animations, :scaling, :mirror_x, :rotation, :floors

  def initialize(position: nil, animations: nil, scaling: nil, floors: nil)
    @position = position || Point.new(0, 0)
    @animations = animations || {}
    @scaling = scaling || 1
    @rotation = 0
    @floors = floors || []

    @current_animation = nil
    @current_animation_name = nil

    @mirror_x = false
  end

  def image
    @current_animation&.image
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
    return unless image

    image.draw_rot(
      position.x + (mirror_x ? image.width * scaling : 0), position.y, position.z,
      rotation, 0, 0,
      scaling * (mirror_x ? -1 : 1),
      scaling
    )
  end
end
