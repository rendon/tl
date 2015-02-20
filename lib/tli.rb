require_relative 'translators/google_translator.rb'
class Tli
  def Tli.translate(text, source, target)
    translator = GoogleTranslator.new
    return translator.translate(text, source, target)
  end
end
