RES_ROOT = File.expand_path(File.join(__dir__, "..", "res"))
GLOBAL_SCALE = 5

AUDIO = Dir[File.join(RES_ROOT, "audio", "*.wav")].to_h do |s|
  [File.basename(s, ".wav"), Gosu::Sample.new(s)]
end
