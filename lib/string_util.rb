require 'digest/sha1'

class StringUtil
  def self.translation_id(text, source, target, service)
    Digest::SHA1.hexdigest("#{text}_#{source}_#{target}_#{service}")
  end
end
