require 'sinatra'

require 'active_record'
require_relative '../lib/application'
require_relative '../lib/string_util'
require_relative '../lib/translation'

set :port, 80

get '/translate_a/t' do
  begin
    serve_response(200, params)
  rescue
    content_type :json
    status 500
    '{"message": "Oop! Something went wrong"}'
  end
end

get '/translate_tts' do
  hash = StringUtil.tts_hash(params[:q], params[:tl], 'google')
  audio_file = File.dirname(__FILE__) + "/../fixtures/pronunciations/#{hash}.mp3"
  content_type 'audio/mpeg'
  status 200
  File.open(audio_file).read
end

private

def serve_response(response_code, params)
  db_file = File.dirname(__FILE__) + '/../fixtures/translations.db'
  db = SQLite3::Database.open(db_file)
  query = %(SELECT response FROM translations WHERE text = ? AND source = ?
            AND target = ? AND service = ?)
  parameters = [params[:text], params[:sl], params[:tl], 'google']
  content = ''
  db.execute(query, parameters) do |row|
    content = row[0]
  end

  content_type :json
  status response_code
  content
end
