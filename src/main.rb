require 'gosu'
require_relative 'engine/entity'
require_relative 'entities/cat'
require_relative 'entities/destructable_object'
require_relative 'world'

RES_ROOT = File.expand_path(File.join(__dir__, "..", "res"))

Gosu::enable_undocumented_retrofication

$world = World.new
$world.floors << World::Floor.new(Point.new(50, 400), 1000, false)
$world.floors << World::Floor.new(Point.new(500, 200), 300, false)
$world.floors << World::Floor.new(Point.new(200, 230), 150, false)

$world.entities << DestructableObject.new("small_tv", Point.new(225, 100, 2))

class GameWindow < Gosu::Window
  def initialize
    super(1600, 900)

    @cat = Cat.new(Point.new(200, 200, 100))
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

    Gosu::Image.new(File.join(RES_ROOT, "scenery", "small_chest_of_drawers.png"), retro: true).draw(200, 230, 0, 5, 5)
  end
end

GameWindow.new.show
