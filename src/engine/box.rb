Box = Struct.new('Box', :origin, :width, :height) do
  def overlaps?(other)
    self.origin.x < other.origin.x + other.width \
    && other.origin.x < self.origin.x + self.width \
    && self.origin.y < other.origin.y + other.height \
    && other.origin.y < self.origin.y + self.height
  end
end 
