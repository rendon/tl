require_relative 'translators/google_translator.rb'
class Tli
  def Tli.translate(text, params = {})
    translator = GoogleTranslator.new
    return translator.translate(text, params[:source], params[:target])
  end
end
