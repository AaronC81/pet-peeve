class Transition
  attr_reader :ongoing
  alias ongoing? ongoing

  def initialize
    @ongoing = false
    @total_frames = 0
    @current_frames = 0
    @callback = nil
  end

  def tick
    if ongoing?
      @current_frames += 1
      if @current_frames == @total_frames
        @ongoing = false
        @callback.()
      end
    end
  end

  def fade_out(frames, &callback)
    @ongoing = :out
    @current_frames = 0
    @total_frames = frames
    @callback = callback
  end

  def fade_in(frames, &callback)
    @ongoing = :in
    @current_frames = 0
    @total_frames = frames
    @callback = callback
  end

  def draw
    progress = @current_frames.to_f / @total_frames.to_f
    fade_amount = @ongoing == :out ? progress : (1 - progress)
    fade_amount = 0 if fade_amount.nan?
    Gosu.draw_rect(0, 0, 1600, 900, Gosu::Color.new(fade_amount * 255, 0, 0, 0), 1000)
  end
end
