require 'rest_client'
require_relative '../lib/string_util'
SPEECH_API_URL  = 'http://translate.google.com/translate_tts'

if ARGV.length != 3
  STDERR.puts 'Usage: ruby fetchtl.rb <target> <service> <text>'
  exit(1)
end

target  = ARGV[0]
service = ARGV[1]
text    = ARGV[2]
hash = StringUtil.tts_hash(text, target, service)
file_name = File.dirname(__FILE__) + "/../fixtures/pronunciations/#{hash}.mp3"
begin
  unless File.exist?(file_name)
    File.open(file_name, 'w') do |f|
      f.write(RestClient.get(SPEECH_API_URL, params: { tl: target, q: text }))
    end
  end
  puts 'Done!'
rescue => e
  puts e.message
end
