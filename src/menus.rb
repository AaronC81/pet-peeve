require_relative 'game_state'

class Menus
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

  def tick
    case @showing_menu
    when :main
      tick_main_menu
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

    # Horizontal divider
    Gosu.draw_line(0, 700, Gosu::Color::WHITE, 1600, 700, Gosu::Color::WHITE)

    # Start game
    KEY_IMAGES['space'].draw(630, 730, 0, GLOBAL_SCALE, GLOBAL_SCALE)
    GameState::BIG_FONT.draw_text("Press               to start!", 400, 730, 0)
  end
end
