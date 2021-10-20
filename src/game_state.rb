class GameState
  BIG_FONT = Gosu::Font.new(120, name: File.join(RES_ROOT, "orange-kid.ttf"))

  def initialize
    @score = 0
  end

  def reset
    initialize
  end

  def destroy_object
    @score += 100

    # Is this room now empty?
    if $world.entities.filter { |x| x.is_a?(DestructableObject) }.all?(&:knocked_off?)
      # TODO regenerate world
    end
  end

  def juggle_object
    @score += 50
  end

  def tick

  end
  
  def draw
    BIG_FONT.draw_text(@score.to_i, 50, 20, 100)
  end
end
