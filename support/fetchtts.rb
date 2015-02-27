require 'rest_client'
require_relative '../lib/string_util'
SPEECH_API_URL  = 'http://translate.google.com/translate_tts'

if ARGV.length != 3
  STDERR.puts "Usage: ruby fetchtl.rb <text> <target> <service>"
  exit(1)
end

text    = ARGV[0]
target  = ARGV[1]
service = ARGV[2]
hash = StringUtil.tts_hash(text, target, service)
file_name = File.dirname(__FILE__) + "/../fixtures/pronunciations/#{hash}.mp3"
begin
  if !File.exists?(file_name)
    File.open(file_name, 'w') do |f|
      f.write(RestClient.get(SPEECH_API_URL, params: { tl: target, q: text }))
    end
  end
  puts 'Done!'
rescue => e
  puts e.message
end
