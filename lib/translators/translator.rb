# Base class for translators
class Translator
  def translate(text, source, target, options = {}); end

  def langs; end

  def provide_tts?; end

  def info; end

  def self.name; end
end
