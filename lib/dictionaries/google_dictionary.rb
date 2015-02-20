require_relative 'dictionary'
class GoogleDictionary < Dictionary
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

  def define(word, source, target)
    raise "Unknown language code '#{source}'" if !get_langs.include?(source)
    raise "Unknown language code '#{target}'" if !get_langs.include?(target)
    response = RestClient.get(API_URL, params: {client: 'p', text: word, sl: source, tl: target})
    json = JSON.parse(TextDecoder.decode(response.to_s, target))
    result = []
    if json.include?('dict')
      json['dict'].each do |item|
        definition = {:class => item['pos'], entries: []}
        item['entry'].each do |entry|
          definition[:entries] << {word: entry['word'], score: (entry['score'] or 1e9)}
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
    render result
  end

  private
  def render(result)
    output = ""
    result.each do |entry|
      output << "#{entry[:class]}\n#{'-' * entry[:class].length}\n"
      entry[:entries].sort! {|x, y| x[:score] <=> y[:score]}
      output << entry[:entries].map {|e| e[:word] }.join(', ') + "\n\n"
    end
    #puts output
    output
  end
end
