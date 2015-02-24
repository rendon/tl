require_relative 'dictionary'
require_relative '../text_decoder'
require_relative '../google'
class GoogleDictionary < Dictionary
  include Google
  API_URL = 'http://translate.google.com/translate_a/t'

  def provide_tts?; true; end

  def get_langs
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
      'zh-TW' => 'Chinese, (Traditional)','zh-CN'=> 'Chinese, (Simplified)' }
  end

  def define(word, source, target, options = {})
    raise "Unknown language code '#{source}'" if !get_langs.include?(source)
    raise "Unknown language code '#{target}'" if !get_langs.include?(target)

    if options[:cache_results]
      entry = Translation.find_by(text: word, source: source,
                                  target: target, service: 'google')
      return entry.translation if !entry.nil?
    end

    params = {client: 'p', text: word, sl: source, tl: target}
    response = RestClient.get(API_URL, params: params)
    json = JSON.parse(TextDecoder.decode(response.to_s, target))
    result = []
    if json.include?('dict')
      json['dict'].each do |item|
        definition = {:class => item['pos'], entries: []}
        item['entry'].each do |e|
          definition[:entries] << {word: e['word'], score: (e['score'] or 1e9)}
        end
        result << definition
      end
    elsif json.include?('sentences')
      json['sentences'].each do |item|
        if item.include?('trans')
          definition = {:class => 'translation', entries: []}
          definition[:entries] << {word: item['trans'], score: 0}
          result << definition
          break
        end
      end
    end
    if options[:tts]
      file_name = StringUtil.tts_file_name(word, source, target, 'google')
      if !File.exists?(file_name)
        get_pronunciation(word, source, target, file_name)
      end
    end

    translation = render result
    if options[:cache_results]
      Translation.create!(text: word, source: source, target: target,
                          service: 'google', translation: translation)
    end
    translation
  end

  private
    def render(result)
      output = ""
      result.each do |entry|
        output << "#{entry[:class]}\n#{'-' * entry[:class].length}\n"
        entry[:entries].sort! {|x, y| x[:score] <=> y[:score]}
        output << entry[:entries].map {|e| e[:word] }.join(', ') + "\n\n"
      end
      output
    end
end
