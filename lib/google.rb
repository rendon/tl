module Google
  TEXT_API_URL    = 'http://translate.google.com/translate_a/t'
  SPEECH_API_URL  = 'http://translate.google.com/translate_tts'

  def get_pronunciation(text, source, target, file_name)
    File.open(file_name, "w") do |f|
      f.write(RestClient.get(SPEECH_API_URL, params: { tl: source, q: text }))
    end
  end
end
