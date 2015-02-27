require_relative 'dictionary'
require_relative '../google'

# Class for the Google Dictionary (actually Translate)
class GoogleDictionary < Dictionary
  include Google
  API_URL = 'http://translate.google.com/translate_a/t'

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

  def define(word, source, target, options = {})
    fail "Unknown language code '#{source}'" unless langs.include?(source)
    fail "Unknown language code '#{target}'" unless langs.include?(target)

    if options[:tts]
      file_name = StringUtil.tts_file_name(word, target, 'google')
      get_pronunciation(word, source, file_name) unless File.exist?(file_name)
    end

    json = JSON.parse(get_data(word, source, target, options))
    render extract_definitions(json)
  end

  private

  def extract_definitions(json)
    result = []
    if json.include?('dict')
      json['dict'].each do |item|
        definition = { class: item['pos'], entries: [] }
        item['entry'].each do |e|
          data = { word: e['word'], score: (e['score'] || 1e9) }
          definition[:entries] << data
        end
        result << definition
      end
    elsif json.include?('sentences')
      json['sentences'].each do |item|
        if item.include?('trans')
          definition = { class: 'translation', entries: [] }
          definition[:entries] << { word: item['trans'], score: 0 }
          result << definition
          break
        end
      end
    end
    result
  end

  def render(result)
    output = ''
    result.each do |entry|
      output << "#{entry[:class]}\n#{'-' * entry[:class].length}\n"
      entry[:entries].sort! { |x, y| x[:score] <=> y[:score] }
      output << entry[:entries].map { |e| e[:word] }.join(', ') + "\n\n"
    end
    output
  end
end
