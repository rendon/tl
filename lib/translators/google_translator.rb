require 'rest_client'
require_relative 'translator'
require_relative '../text_decoder'
require_relative '../player'
require_relative '../playable'
require_relative '../string_util'
require_relative '../google'

class GoogleTranslator < Translator
  include Playable
  include Google


  def get_langs
    { 'af'    => 'Afrikaans',   'sq'  => 'Albanian',        'ar'  => 'Arabic',
      'hy'    => 'Armenian',    'az'  => 'Azerbaijani',     'eu'  => 'Basque',
      'be'    => 'Belarusian',  'bg'  => 'Bulgarian',       'ca'  => 'Catalan',
      'hr'    => 'Croatian',    'cs'  => 'Czech',           'et'  => 'Estonian',
      'da'    => 'Danish',      'nl'  => 'Dutch',           'en'  => 'English',
      'tl'    => 'Filipino',    'fi'  => 'Finnish',         'fr'  => 'French',
      'gl'    => 'Galician',    'ht'  => 'Haitian, Creole', 'is'  => 'Icelandic',
      'ka'    => 'Georgian',    'de'  => 'German',          'el'  => 'Greek',
      'iw'    => 'Hebrew',      'hi'  => 'Hindi',           'hu'  => 'Hungarian',
      'id'    => 'Indonesian',  'ga'  => 'Irish',           'it'  => 'Italian',
      'ko'    => 'Korean',      'la'  => 'Latin',           'lv'  => 'Latvian',
      'mk'    => 'Macedonian',  'ms'  => 'Malay',           'mt'  => 'Maltese',
      'fa'    => 'Persian',     'pl'  => 'Polish',          'pt'  => 'Portuguese',
      'ro'    => 'Romanian',    'sl'  => 'Slovenian',       'th'  => 'Thai',
      'ja'    => 'Japanese',    'lt'  => 'Lithuanian',      'no'  => 'Norwegian',
      'vi'    => 'Vietnamese',  'cy'  => 'Welsh',           'yi'  => 'Yiddish',
      'ru'    => 'Russian',     'sr'  => 'Serbian',         'sk'  => 'Slovak',
      'es'    => 'Spanish',     'sw'  => 'Swahili',         'sv'  => 'Swedish',
      'tr'    => 'Turkish',     'uk'  => 'Ukrainian',       'ur'  => 'Urdu',
      'zh-TW' => 'Chinese, (Traditional)','zh-CN'=> 'Chinese, (Simplified)' }
  end

  def translate(text, source, target, play = false)
    raise "Unknown language code '#{source}'" if !get_langs.include?(source)
    raise "Unknown language code '#{target}'" if !get_langs.include?(target)
    params = {client: 'p', text: text, sl: source, tl: target}
    response = RestClient.get(TEXT_API_URL, params: params)
    json = JSON.parse(TextDecoder.decode(response.to_s, target))
    translation = ''
    if json.include?('sentences')
      json['sentences'].each do |entry|
        if entry.include?('trans')
          translation = entry['trans']
          break
        end
      end
    end
    if play
      file_name = get_pronunciation(text, source, target)
      play_pronunciation(file_name)
    end
    translation
  end
end

