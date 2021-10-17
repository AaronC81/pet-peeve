class Animation
  def initialize(images, ticks_per_image)
    @images = images
    @ticks_per_image = ticks_per_image

    reset
  end

  def self.static(image)
    new([image], -1)
  end

  def reset
    @ticks = 0
    @image_idx = 0
  end

  def tick
    return if @ticks_per_image == -1

    @ticks += 1
    if @ticks == @ticks_per_image
      @image_idx += 1
      @image_idx %= @images.length
      @ticks = 0
    end
  end

  def image
    @images[@image_idx]
  end
end
