require 'gosu'
require_relative 'engine/entity'
require_relative 'engine/transition'
require_relative 'entities/cat'
require_relative 'entities/destructable_object'
require_relative 'entities/scenery'
require_relative 'world'
require_relative 'res'
require_relative 'game_state'
require_relative 'menus'

Gosu::enable_undocumented_retrofication

def sc!(id, x, y, floor)
  $world.entities << Scenery.new(id, Point.new(x, y, 2), floor: floor)
end

def obj!(id, x, y)
  $world.entities << DestructableObject.new(id, Point.new(x, y, 2))
end

$world = World.new
$world.extra_floors << World::Floor.new(Point.new(0, World::GLOBAL_FLOOR_Y), 1600, false)

$world.generate

$state = GameState.new
$transition = Transition.new
$menus = Menus.new

class GameWindow < Gosu::Window
  def initialize
    super(1600, 900)

    @cat = Cat.new(Point.new(200, 200, 100))
    $world.cat = @cat
  end

  def update
    $transition.tick
    return if $menus.tick

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
    else
      @cat.swipe_release
    end

    @cat.tick
    $world.entities.map(&:tick)
    $state.tick
  end

  def draw
    $transition.draw
    return if $menus.draw

    @cat.draw
    $world.entities.map(&:draw)

    $world.floors.each do |floor|
      Gosu.draw_line(
        floor.position.x, floor.position.y, Gosu::Color::WHITE,
        floor.position.x + floor.width, floor.position.y, Gosu::Color::WHITE
      )
    end

    $state.draw
  end
end

GameWindow.new.show
