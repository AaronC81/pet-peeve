require 'gosu'
require_relative 'engine/entity'
require_relative 'entities/cat'
require_relative 'entities/destructable_object'
require_relative 'entities/scenery'
require_relative 'world'

RES_ROOT = File.expand_path(File.join(__dir__, "..", "res"))

Gosu::enable_undocumented_retrofication

$world = World.new
$world.extra_floors << World::Floor.new(Point.new(50, 700), 1000, false)

$world.entities << Scenery.new("small_chest_of_drawers", Point.new(200, 530, 2), floor: true)
$world.entities << DestructableObject.new("radio", Point.new(210, 400, 2))

$world.entities << Scenery.new("small_table", Point.new(600, 580, 2), floor: true)
$world.entities << DestructableObject.new("alarm_clock", Point.new(620, 530, 2))
$world.entities << DestructableObject.new("mug", Point.new(690, 500, 2))
$world.entities << DestructableObject.new("mug", Point.new(750, 500, 2))

class GameWindow < Gosu::Window
  def initialize
    super(1600, 900)

    @cat = Cat.new(Point.new(200, 200, 100))
    $world.cat = @cat
  end

  def update
    if Gosu.button_down?(Gosu::KB_W)
      @cat.jump 
    end
    
    if Gosu.button_down?(Gosu::KB_D)
      @cat.move_right
    elsif Gosu.button_down?(Gosu::KB_A)
      @cat.move_left
    else
      @cat.idle
    end

    if Gosu.button_down?(Gosu::KB_SPACE)
      @cat.swipe
    end

    @cat.tick
    $world.entities.map(&:tick)
  end

  def draw
    @cat.draw
    $world.entities.map(&:draw)

    $world.floors.each do |floor|
      Gosu.draw_line(
        floor.position.x, floor.position.y, Gosu::Color::WHITE,
        floor.position.x + floor.width, floor.position.y, Gosu::Color::WHITE
      )
    end
  end
end

GameWindow.new.show
