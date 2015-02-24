require 'digest/sha1'
require_relative 'string_util'

class StringUtil
  def self.tts_file_name(text, source, target, service)
    id = Digest::SHA1.hexdigest("#{text}_#{source}_#{target}_#{service}")
    "#{Application.app_dir}/pronunciations/#{id}.mp3"
  end
end
