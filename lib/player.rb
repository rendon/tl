# encoding: utf-8

# Plays an audio file using an external program.
class Player
  def self.play(audio_file, player)
     `#{player} #{audio_file} 2>&1 > /dev/null &`
  end
end
