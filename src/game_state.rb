class GameState
  attr_accessor :timer_running
  alias timer_running? timer_running

  BIG_FONT = Gosu::Font.new(120, name: File.join(RES_ROOT, "orange-kid.ttf"))
  MEDIUM_FONT = Gosu::Font.new(80, name: File.join(RES_ROOT, "orange-kid.ttf"))
  TICKS_PER_SECOND = 60
  GAME_SECONDS = 15

  def initialize
    @score = 0
    @timer = GAME_SECONDS * TICKS_PER_SECOND
    @timer_running = true
  end

  def reset
    initialize
  end

  def destroy_object
    @score += 100

    AUDIO["knock"].play

    # Is this room now empty?
    if $world.entities.filter { |x| x.is_a?(DestructableObject) }.all?(&:knocked_off?)
      $world.cleared
    end
  end

  def level_complete
    @score += 200
  end

  def juggle_object
    @score += 50

    AUDIO["knock"].play
  end

  def tick
    return unless timer_running?

    @timer -= 1 
    if @timer % TICKS_PER_SECOND == 0 && @timer / 60 <= 5 
      AUDIO["timer"].play
    end

    if @timer < 0
      @timer_running = false
      $menus.score = @score
      $menus.transition_into_menu(:game_over)
    end
  end

  def seconds_remaining
    [0, @timer / TICKS_PER_SECOND].max
  end
  
  def draw
    BIG_FONT.draw_text(@score, 50, 20, 100)
    BIG_FONT.draw_text(seconds_remaining, 1400, 20, 100)
  end
end
