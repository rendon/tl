class Player
  def self.play(file_name)
    `mplayer #{file_name} 2>&1 /dev/null &`
    puts '♬'
  end
end
