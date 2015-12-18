require "uri"
require 'rest_client'
require_relative 'translator'
require_relative '../player'
require_relative '../string_util'
require_relative '../google'

# Class for the Yandex Translate service.
class YandexTranslator < Translator
  include Google

  def self.name
    'Yandex Translate'
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

  def translate(text, source, target, options = {})
    fail "Unknown language code '#{source}'" unless langs.include?(source)
    fail "Unknown language code '#{target}'" unless langs.include?(target)

    key = ENV["YANDEX_TR_KEY"]
    text = URI.encode(text)
    resp = RestClient.get "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{key}&text=#{text}&lang=#{source}-#{target}"
    data = JSON.parse(resp)
    return data["text"].join(" ")
  end

  def self.info
    File.open(Application.strings_dir + '/google_info.txt').read
  end
end
