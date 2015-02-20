require 'rest_client'
require_relative 'translator'
require_relative '../text_decoder'

class GoogleTranslator < Translator
  API_URL = 'http://translate.google.com/translate_a/t'
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

  def translate(text, source, target)
    raise "Unknown language code '#{source}'" if !get_langs.include?(source)
    raise "Unknown language code '#{target}'" if !get_langs.include?(target)
    response = RestClient.get(API_URL, params: {client: 'p', text: text, sl: source, tl: target})
    json = JSON.parse(TextDecoder.decode(response.to_s, target))
    translation = ''
    json['sentences'].each do |entry|
      if entry.include?('trans')
        translation = entry['trans']
        break
      end
    end
    translation
  end
end


