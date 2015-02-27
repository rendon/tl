# encoding: utf-8

# Plays an audio file using an external program.
class Player
  def self.play(file_name)
     `mplayer #{file_name} 2>&1 /dev/null &`
  end
end
