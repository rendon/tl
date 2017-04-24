require_relative 'dictionary'

# Class for the Google Dictionary (actually Translate)
class YandexDictionary < Dictionary
  API_URL = 'http://translate.google.com/translate_a/t'
  attr_accessor :directions

  def initialize
    @directions = Hash.new({})
    langs = ["be", "bg", "cs", "da", "de", "el", "en", "es", "et", "fi", "fr",
             "it", "lt", "lv", "nl", "no", "pl", "pt", "ru", "sk", "sv", "tr",
             "tt", "uk"]
    langs.each do |l|
      @directions[l] = Hash.new(false)
    end
    @directions["be"]["be"] = true
    @directions["be"]["ru"] = true
    @directions["bg"]["ru"] = true
    @directions["cs"]["en"] = true
    @directions["cs"]["ru"] = true
    @directions["da"]["en"] = true
    @directions["da"]["ru"] = true
    @directions["de"]["en"] = true
    @directions["de"]["ru"] = true
    @directions["de"]["tr"] = true
    @directions["el"]["en"] = true
    @directions["el"]["ru"] = true
    @directions["en"]["cs"] = true
    @directions["en"]["da"] = true
    @directions["en"]["de"] = true
    @directions["en"]["el"] = true
    @directions["en"]["en"] = true
    @directions["en"]["es"] = true
    @directions["en"]["et"] = true
    @directions["en"]["fi"] = true
    @directions["en"]["fr"] = true
    @directions["en"]["it"] = true
    @directions["en"]["lt"] = true
    @directions["en"]["lv"] = true
    @directions["en"]["nl"] = true
    @directions["en"]["no"] = true
    @directions["en"]["pt"] = true
    @directions["en"]["ru"] = true
    @directions["en"]["sk"] = true
    @directions["en"]["sv"] = true
    @directions["en"]["tr"] = true
    @directions["es"]["en"] = true
    @directions["es"]["ru"] = true
    @directions["et"]["en"] = true
    @directions["et"]["ru"] = true
    @directions["fi"]["en"] = true
    @directions["fi"]["ru"] = true
    @directions["fr"]["en"] = true
    @directions["fr"]["ru"] = true
    @directions["it"]["en"] = true
    @directions["it"]["ru"] = true
    @directions["lt"]["en"] = true
    @directions["lt"]["ru"] = true
    @directions["lv"]["en"] = true
    @directions["lv"]["ru"] = true
    @directions["nl"]["en"] = true
    @directions["nl"]["ru"] = true
    @directions["no"]["en"] = true
    @directions["no"]["ru"] = true
    @directions["pl"]["ru"] = true
    @directions["pt"]["en"] = true
    @directions["pt"]["ru"] = true
    @directions["ru"]["be"] = true
    @directions["ru"]["bg"] = true
    @directions["ru"]["cs"] = true
    @directions["ru"]["da"] = true
    @directions["ru"]["de"] = true
    @directions["ru"]["el"] = true
    @directions["ru"]["en"] = true
    @directions["ru"]["es"] = true
    @directions["ru"]["et"] = true
    @directions["ru"]["fi"] = true
    @directions["ru"]["fr"] = true
    @directions["ru"]["it"] = true
    @directions["ru"]["lt"] = true
    @directions["ru"]["lv"] = true
    @directions["ru"]["nl"] = true
    @directions["ru"]["no"] = true
    @directions["ru"]["pl"] = true
    @directions["ru"]["pt"] = true
    @directions["ru"]["ru"] = true
    @directions["ru"]["sk"] = true
    @directions["ru"]["sv"] = true
    @directions["ru"]["tr"] = true
    @directions["ru"]["tt"] = true
    @directions["ru"]["uk"] = true
    @directions["sk"]["en"] = true
    @directions["sk"]["ru"] = true
    @directions["sv"]["en"] = true
    @directions["sv"]["ru"] = true
    @directions["tr"]["de"] = true
    @directions["tr"]["en"] = true
    @directions["tr"]["ru"] = true
    @directions["tt"]["ru"] = true
    @directions["uk"]["ru"] = true
    @directions["uk"]["uk"] = true
  end

  def self.name
    'Yandex Dictionary'
  end

  def provide_tts?
    false
  end

  def langs
    {
      "sq" => "Albanian",
      "en" => "English",
      "ar" => "Arabic",
      "hy" => "Armenian",
      "az" => "Azerbaijan",
      "af" => "Afrikaans",
      "eu" => "Basque",
      "be" => "Belarusian",
      "bg" => "Bulgarian",
      "bs" => "Bosnian",
      "cy" => "Welsh",
      "vi" => "Vietnamese",
      "hu" => "Hungarian",
      "ht" => "Haitian (Creole)",
      "gl" => "Galician",
      "nl" => "Dutch",
      "el" => "Greek",
      "ka" => "Georgian",
      "da" => "Danish",
      "he" => "Yiddish",
      "id" => "Indonesian",
      "ga" => "Irish",
      "it" => "Italian",
      "is" => "Icelandic",
      "es" => "Spanish",
      "kk" => "Kazakh",
      "ca" => "Catalan",
      "ky" => "Kyrgyz",
      "zh" => "Chinese",
      "ko" => "Korean",
      "la" => "Latin",
      "lv" => "Latvian",
      "lt" => "Lithuanian",
      "mg" => "Malagasy",
      "ms" => "Malay",
      "mt" => "Maltese",
      "mk" => "Macedonian",
      "mn" => "Mongolian",
      "de" => "German",
      "no" => "Norwegian",
      "fa" => "Persian",
      "pl" => "Polish",
      "pt" => "Portuguese",
      "ro" => "Romanian",
      "ru" => "Russian",
      "sr" => "Serbian",
      "sk" => "Slovakian",
      "sl" => "Slovenian",
      "sw" => "Swahili",
      "tg" => "Tajik",
      "th" => "Thai",
      "tl" => "Tagalog",
      "tt" => "Tatar",
      "tr" => "Turkish",
      "uz" => "Uzbek",
      "uk" => "Ukrainian",
      "fi" => "Finish",
      "fr" => "French",
      "hr" => "Croatian",
      "cs" => "Czech",
      "sv" => "Swedish",
      "et" => "Estonian",
      "ja" => "Japanese"
    }
  end

  def define(word, source, target, options = {})
    if directions[source][target] == false
      fail "Unsuported direction #{source} -> #{target}"
    end
    key = ENV["YANDEX_DICTIONARY_KEY"]
    text = URI.encode(word)
    resp = RestClient.get "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=#{key}&lang=#{source}-#{target}&text=#{text}"
    data = JSON.parse(resp)
    render(extract_definitions(data))
  end

  private
  def extract_definitions(json)
    result = []
    if json.include?('def')
      json['def'].each do |item|
        definition = { type: item['pos'], entries: [] }
        item['tr'].each do |e|
          means = e["mean"].map { |item| item["text"] } unless e["mean"].nil?
          data = { word: e['text'], type: e["pos"], mean: means || [] }
          definition[:entries] << data
        end
        result << definition
      end
    end
    result
  end

  def render(result)
    output = ''
    result.each do |entry|
      output << "#{entry[:type]}\n#{'-' * entry[:type].length}\n"
      output << entry[:entries].map { |e| e[:word] }.join(', ') + "\n\n"
    end
    output
  end
end
