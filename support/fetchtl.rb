require 'rest_client'
require 'sqlite3'
TEXT_API_URL    = 'http://translate.google.com/translate_a/t'

if ARGV.length != 4
  STDERR.puts "Usage: ruby fetchtl.rb <text> <source> <target> <service>"
  exit(1)
end

text    = ARGV[0]
source  = ARGV[1]
target  = ARGV[2]
service = ARGV[3]

begin
  if service == 'google'
    db_file = File.dirname(__FILE__) + '/../fixtures/translations.db'
    db = SQLite3::Database.open(db_file)
    query = %{
        SELECT response
        FROM translations
        WHERE text = ?     AND
              source = ?   AND
              target = ?   AND
              service = ?
    }
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
      db.execute('INSERT INTO translations VALUES(?, ?, ?, ?, ?, ?, ?, ?)', data)
    end
  end
  puts "Done!"
rescue => e
  STDERR.puts e.message
end
