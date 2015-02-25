module Google
  TEXT_API_URL    = 'http://translate.google.com/translate_a/t'
  SPEECH_API_URL  = 'http://translate.google.com/translate_tts'

  def get_pronunciation(text, source, target, file_name)
    File.open(file_name, "w") do |f|
      f.write(RestClient.get(SPEECH_API_URL, params: { tl: source, q: text }))
    end
  end

  def get_translation(text, source, target)
    params = {client: 'p', text: text, sl: source, tl: target}
    response = RestClient.get(TEXT_API_URL, params: params)
    TextDecoder.decode(response.to_s, target)
  end

  def get_data(text, source, target, options = {})
      return get_translation(text, source, target) if !options[:cache_results]

      entry = Translation.find_by(text: text,
                                  source: source,
                                  target: target,
                                  service: 'google')
      if entry.nil?
          response = get_translation(text, source, target)
          entry = Translation.create!(text: text,
                                      source: source,
                                      target: target,
                                      service: 'google',
                                      response: response)
      end
      entry.response
  end
end
