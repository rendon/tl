class TextDecoder
  def self.decode(text, lang_code)
    result = ''
    case lang_code
    when 'en', 'es', 'fr', 'pt'
      result = text.force_encoding('ISO-8859-1').encode('UTF-8')
    when 'ru'
      result = text.force_encoding('Windows-1251').encode('UTF-8')
    when 'ja'
      result = text.force_encoding('Shift_JIS').encode('UTF-8')
    end
    result
  end
end
