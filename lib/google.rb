# Provides common functionality for both GoogleTranslator and GoogleDictionary
module Google
  TEXT_API_URL    = 'http://translate.google.com/translate_a/t'
  SPEECH_API_URL  = 'http://translate.google.com/translate_tts'

  def get_pronunciation(text, source, file_name)
    File.open(file_name, 'w') do |f|
      f.write(RestClient.get(SPEECH_API_URL, params: { tl: source, q: text }))
    end
  end

  def get_translation(text, source, target)
    headers = {
      params: { client: 'p', text: text, sl: source, tl: target },
      user_agent: 'Mozilla/5.0'
    }
    RestClient.get(TEXT_API_URL, headers).to_s.force_encoding(Encoding::UTF_8)
  end

  def get_data(text, source, target, options = {})
    return get_translation(text, source, target) unless options[:cache_results]

    data = { text: text, source: source, target: target, service: 'google' }
    entry = Translation.find_by(data)
    if entry.nil?
      data[:response] = get_translation(text, source, target)
      entry = Translation.create(data)
    end
    entry.response
  end
end
