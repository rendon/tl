require 'rest_client'
require_relative 'translator'
require_relative '../player'
require_relative '../string_util'
require_relative '../google'

class GoogleTranslator < Translator
  include Google
  def self.name; 'Google Translate' end
  def provide_tts?; true end

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

  def translate(text, source, target, options = {})
    raise "Unknown language code '#{source}'" if !get_langs.include?(source)
    raise "Unknown language code '#{target}'" if !get_langs.include?(target)

    if options[:tts]
      file_name = StringUtil.tts_file_name(text, target, 'google')
      if !File.exists?(file_name)
        get_pronunciation(text, source, target, file_name)
      end
    end
    json = JSON.parse(get_data(text, source, target, options))
    translation = extract_translation(json)
  end

  def self.get_info
    %{
                          Google Translate

Google  Translate is  a multilingual  service provided  by Google  Inc. to
translate  written  text  from  one  language into  another.  It  over  60
languages.  Google  Translate  also  provides  Text  To  Speech  for  your
translations.

Supported languages:
====================

Code    Language
----    ------
af      Afrikaans
sq      Albanian
ar      Arabic
hy      Armenian
az      Azerbaijani
eu      Basque
be      Belarusian
bg      Bulgarian
ca      Catalan
zh-CN   Chinese, (Simplified)
zh-TW   Chinese, (Traditional)
hr      Croatian
cs      Czech
da      Danish
nl      Dutch
en      English
et      Estonian
tl      Filipino
fi      Finnish
fr      French
gl      Galician
ka      Georgian
de      German
el      Greek
ht      Haitian, Creole
iw      Hebrew
hi      Hindi
hu      Hungarian
is      Icelandic
id      Indonesian
ga      Irish
it      Italian
ja      Japanese
ko      Korean
la      Latin
lv      Latvian
lt      Lithuanian
mk      Macedonian
ms      Malay
mt      Maltese
no      Norwegian
fa      Persian
pl      Polish
pt      Portuguese
ro      Romanian
ru      Russian
sr      Serbian
sk      Slovak
sl      Slovenian
es      Spanish
sw      Swahili
sv      Swedish
th      Thai
tr      Turkish
uk      Ukrainian
ur      Urdu
vi      Vietnamese
cy      Welsh
yi      Yiddish
    }
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

