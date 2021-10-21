require_relative 'game_state'

class Menus
  attr_accessor :showing_menu, :score

  KEY_IMAGES = %w{a d e w space}.to_h do |key|
    [
      key,
      Gosu::Image.new(
        File.join(RES_ROOT, "special", "key_#{key.downcase}.png"),
        retro: true
      )
    ]
  end

  def initialize
    @showing_menu = :main
  end

  def transition_into_menu(menu)
    @showing_menu = :pending
    $transition.fade_out(40) do
      @showing_menu = menu
      $transition.fade_in(40) {}
    end
  end

  def tick
    case @showing_menu
    when :main
      tick_main_menu
      true
    when :game_over
      tick_game_over
      true
    when :pending
      true
    else
      false
    end
  end
  
  def draw
    case @showing_menu
    when :main
      draw_main_menu
      true
    when :game_over
      draw_game_over
      true
    when :pending
      false
    else
      false
    end
  end

  def tick_main_menu
    if Gosu.button_down?(Gosu::KB_SPACE)
      $transition.fade_out(40) do
        @showing_menu = nil
        $transition.fade_in(40) {}
      end
    end
  end

  def draw_main_menu
    # Keys
    KEY_IMAGES['a'].draw(50, 100, 0, GLOBAL_SCALE, GLOBAL_SCALE)
    KEY_IMAGES['d'].draw(200, 100, 0, GLOBAL_SCALE, GLOBAL_SCALE)
    GameState::BIG_FONT.draw_text("Move", 350, 100, 0)

    KEY_IMAGES['w'].draw(125, 250, 0, GLOBAL_SCALE, GLOBAL_SCALE)
    GameState::BIG_FONT.draw_text("Jump", 350, 250, 0)

    KEY_IMAGES['space'].draw(87, 400, 0, GLOBAL_SCALE, GLOBAL_SCALE)
    GameState::BIG_FONT.draw_text("Knock over", 350, 400, 0)
    
    # Vertical divider
    Gosu.draw_line(800, 0, Gosu::Color::WHITE, 800, 700, Gosu::Color::WHITE)

    # Description
    GameState::MEDIUM_FONT.draw_text(
      "Knock over every object in the\n" \
      "room!\n" \
      "Once the room is clear, use the\n" \
      "cat flap to go to the next level.\n" \
      "Get the highest score in 1 minute!\n" \
      "- Knock over: +100\n" \
      "- Juggle object in the air: +50\n" \
      "- Next level: +200\n",
      850, 30, 0
    )

    play_prompt
  end

  def tick_game_over
    if Gosu.button_down?(Gosu::KB_SPACE)
      $transition.fade_out(40) do
        $world.clear
        $world.generate
        $world.reposition
        $state.reset

        @showing_menu = nil
        $transition.fade_in(40) {}
      end
    end
  end

  def draw_game_over
    text_start = 800 - GameState::MEDIUM_FONT.text_width("Score") / 2
    GameState::MEDIUM_FONT.draw_text("Score", text_start, 200, 0)

    text_start = 800 - GameState::BIG_FONT.text_width(score.to_s) / 2
    GameState::BIG_FONT.draw_text(score, text_start, 280, 0)

    play_prompt
  end

  def play_prompt
    # Horizontal divider
    Gosu.draw_line(0, 700, Gosu::Color::WHITE, 1600, 700, Gosu::Color::WHITE)

    # Start game
    KEY_IMAGES['space'].draw(630, 730, 0, GLOBAL_SCALE, GLOBAL_SCALE)
    GameState::BIG_FONT.draw_text("Press               to start!", 400, 730, 0)
  end    
end
