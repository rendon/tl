require 'rest_client'
require_relative 'translator'
require_relative '../player'
require_relative '../string_util'
require_relative '../google'

# Class for the Google Translate service.
class GoogleTranslator < Translator
  include Google

  def self.name
    'Google Translate'
  end

  def provide_tts?
    true
  end

  def langs
    { 'af'  => 'Afrikaans',   'sq'  => 'Albanian',        'ar'  => 'Arabic',
      'hy'  => 'Armenian',    'az'  => 'Azerbaijani',     'eu'  => 'Basque',
      'be'  => 'Belarusian',  'bg'  => 'Bulgarian',       'ca'  => 'Catalan',
      'hr'  => 'Croatian',    'cs'  => 'Czech',           'et'  => 'Estonian',
      'da'  => 'Danish',      'nl'  => 'Dutch',           'en'  => 'English',
      'tl'  => 'Filipino',    'fi'  => 'Finnish',         'fr'  => 'French',
      'gl'  => 'Galician',    'ht'  => 'Haitian, Creole', 'is'  => 'Icelandic',
      'ka'  => 'Georgian',    'de'  => 'German',          'el'  => 'Greek',
      'iw'  => 'Hebrew',      'hi'  => 'Hindi',           'hu'  => 'Hungarian',
      'id'  => 'Indonesian',  'ga'  => 'Irish',           'it'  => 'Italian',
      'ko'  => 'Korean',      'la'  => 'Latin',           'lv'  => 'Latvian',
      'mk'  => 'Macedonian',  'ms'  => 'Malay',           'mt'  => 'Maltese',
      'fa'  => 'Persian',     'pl'  => 'Polish',          'pt'  => 'Portuguese',
      'ro'  => 'Romanian',    'sl'  => 'Slovenian',       'th'  => 'Thai',
      'ja'  => 'Japanese',    'lt'  => 'Lithuanian',      'no'  => 'Norwegian',
      'vi'  => 'Vietnamese',  'cy'  => 'Welsh',           'yi'  => 'Yiddish',
      'ru'  => 'Russian',     'sr'  => 'Serbian',         'sk'  => 'Slovak',
      'es'  => 'Spanish',     'sw'  => 'Swahili',         'sv'  => 'Swedish',
      'tr'  => 'Turkish',     'uk'  => 'Ukrainian',       'ur'  => 'Urdu',
      'zh-TW' => 'Chinese, (Traditional)', 'zh-CN' => 'Chinese, (Simplified)' }
  end

  def translate(text, source, target, options = {})
    fail "Unknown language code '#{source}'" unless langs.include?(source)
    fail "Unknown language code '#{target}'" unless langs.include?(target)

    if options[:tts]
      file_name = StringUtil.tts_file_name(text, target, 'google')
      unless File.exist?(file_name)
        get_pronunciation(text, source, file_name)
      end
    end
    json = JSON.parse(get_data(text, source, target, options))
    extract_translation(json)
  end

  def self.info
    File.open(Application.strings_dir + '/google_info.txt').read
  end

  private

  def extract_translation(json)
    translation = ''
    if json.include?('sentences')
      json['sentences'].each do |entry|
        if entry.include?('trans')
          translation = entry['trans']
          break
        end
      end
    end
    translation
  end
end
