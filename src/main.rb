require 'gosu'
require_relative 'engine/entity'
require_relative 'entities/cat'

RES_ROOT = File.expand_path(File.join(__dir__, "..", "res"))

Gosu::enable_undocumented_retrofication

class GameWindow < Gosu::Window
  def initialize
    super(1600, 900)

    @cat = Cat.new
  end

  def update
    @cat.tick

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
  end

  def draw
    @cat.draw
  end
end

GameWindow.new.show
