require 'gosu'
require_relative 'engine/entity'
require_relative 'entities/cat'
require_relative 'entities/destructable_object'
require_relative 'entities/scenery'
require_relative 'world'

RES_ROOT = File.expand_path(File.join(__dir__, "..", "res"))

Gosu::enable_undocumented_retrofication

def sc!(id, x, y, floor)
  $world.entities << Scenery.new(id, Point.new(x, y, 2), floor: floor)
end

def obj!(id, x, y)
  $world.entities << DestructableObject.new(id, Point.new(x, y, 2))
end

$world = World.new
$world.extra_floors << World::Floor.new(Point.new(50, 700), 1000, false)

sc!("small_chest_of_drawers", 200, 530, true)
obj!("radio", 210, 400)

sc!("small_table", 600, 580, true)
obj!("alarm_clock", 620, 530)
obj!("mug", 690, 500)
obj!("mug", 750, 500)

sc!("large_bed", 1000, 450, 100)
obj!("pillow", 1050, 350)
obj!("pillow", 1260, 350)

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
