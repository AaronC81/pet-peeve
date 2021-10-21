RES_ROOT = File.expand_path(File.join(__dir__, "..", "res"))
GLOBAL_SCALE = 5

AUDIO = Dir[File.join(RES_ROOT, "audio", "*.wav")].to_h do |s|
  [File.basename(s, ".wav"), Gosu::Sample.new(s)]
end

MUSIC = Dir[File.join(RES_ROOT, "music", "*.wav")].to_h do |s|
  [File.basename(s, ".wav"), Gosu::Song.new(s).tap { |m| m.volume = 0.4 }]
end

module Audio
  MUSIC_SCALING = 0.4

  def self.volume
    @volume
  end

  def self.volume=(val)
    @volume = val
    MUSIC.map { |_, m| m.volume = MUSIC_SCALING * @volume }
  end

  def self.play_effect(name)
    AUDIO[name].play(volume)
  end 

  def self.play_music(name)
    MUSIC[name].play(true)
    @music_playing = name
  end

  def self.stop_music
    MUSIC[@music_playing].stop
  end
end

# Start low so we don't deafen anybody
Audio.volume = 0.3
