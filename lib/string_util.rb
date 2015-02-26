require 'digest/sha1'
require_relative 'string_util'

class StringUtil
  def self.tts_file_name(text, target, service)
    hash = StringUtil.tts_hash(text, target, service)
    "#{Application.app_dir}/pronunciations/#{hash}.mp3"
  end

  def self.tts_hash(text, target, service)
    Digest::SHA1.hexdigest("#{text}_#{target}_#{service}")
  end
end
