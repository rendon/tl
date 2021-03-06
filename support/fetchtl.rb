require 'rest_client'
require 'sqlite3'
TEXT_API_URL    = 'http://translate.google.com/translate_a/t'

if ARGV.length != 4
  STDERR.puts 'Usage: ruby fetchtl.rb <source> <target> <service> <text>'
  exit(1)
end

source  = ARGV[0]
target  = ARGV[1]
service = ARGV[2]
text    = ARGV[3]

begin
  if service == 'google'
    db_file = File.dirname(__FILE__) + '/../fixtures/translations.db'
    db = SQLite3::Database.open(db_file)
    query = %(SELECT response FROM translations WHERE text = ? AND source = ?
              AND target = ? AND service = ?)
    parameters = [text, source, target, 'google']
    result = db.execute(query, parameters)
    if result.empty?
      headers = {
        params: { client: 'p', text: text, sl: source, tl: target },
        user_agent: 'Mozilla/5.0'
      }
      response = RestClient.get(TEXT_API_URL, headers)
      data = [nil, text, source, target, 'google',
              response.to_s.force_encoding(Encoding::UTF_8),
              Time.now.to_s, Time.now.to_s]
      query = 'INSERT INTO translations VALUES(?, ?, ?, ?, ?, ?, ?, ?)'
      db.execute(query, data)
    end
  end
  puts 'Done!'
rescue => e
  STDERR.puts e.message
end
